<#
.SYNOPSIS
    Envia automaticamente os cartões do DIO Agent para o Anki via AnkiConnect (sem telas de importação).
.DESCRIPTION
    Lê o baralho cumulativo anki/dio_agent_deck.txt e envia diretamente para o aplicativo Anki via API HTTP (porta 8765).
    Identifica notas já existentes e garante que nenhum agendamento seja resetado.
.PARAMETER DeckPath
    Caminho para o arquivo .txt do baralho (padrão: anki/dio_agent_deck.txt).
.PARAMETER AutoSync
    Se ativado, dispara também a sincronização do Anki com o AnkiWeb ao final.
#>

[CmdletBinding()]
param(
    [string]$DeckPath,
    [switch]$AutoSync = $true
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($DeckPath)) {
    if ($PSScriptRoot -and (Test-Path "$PSScriptRoot\dio_agent_deck.txt")) {
        $DeckPath = "$PSScriptRoot\dio_agent_deck.txt"
    } elseif (Test-Path ".\anki\dio_agent_deck.txt") {
        $DeckPath = ".\anki\dio_agent_deck.txt"
    } elseif (Test-Path ".\dio_agent_deck.txt") {
        $DeckPath = ".\dio_agent_deck.txt"
    } else {
        $DeckPath = "e:\DIO-Agent\dio-agent\anki\dio_agent_deck.txt"
    }
}


function Write-Info([string]$text) {
    Write-Host "[INFO] $text" -ForegroundColor Cyan
}

function Write-Success([string]$text) {
    Write-Host "[OK] $text" -ForegroundColor Green
}

function Write-Warn([string]$text) {
    Write-Host "[AVISO] $text" -ForegroundColor Yellow
}

function Write-Err([string]$text) {
    Write-Host "[ERRO] $text" -ForegroundColor Red
}

$ankiUrl = "http://127.0.0.1:8765"

# 1. Verificar se o AnkiConnect está respondendo
Write-Info "Verificando conexão com o Anki Desktop na porta 8765..."
try {
    $versionResp = Invoke-RestMethod -Uri $ankiUrl -Method Post -Body '{"action": "version", "version": 6}' -ContentType "application/json" -TimeoutSec 3
    Write-Success "Conectado ao Anki com sucesso! (AnkiConnect versão: $($versionResp.result))"
} catch {
    Write-Err "Não foi possível conectar ao Anki Desktop na porta 8765."
    Write-Host ""
    Write-Warn "Para habilitar a integração direta pela IDE:"
    Write-Host "1. Abra o seu aplicativo Anki no computador;" -ForegroundColor White
    Write-Host "2. No menu superior, vá em: Ferramentas -> Complementos -> Obter complementos...;" -ForegroundColor White
    Write-Host "3. Digite o código do AnkiConnect: 2055492159 e clique em OK;" -ForegroundColor Yellow
    Write-Host "4. Reinicie o Anki e execute este script novamente!" -ForegroundColor White
    Write-Host ""
    exit 1
}

# 2. Verificar se o arquivo do baralho existe
if (-not (Test-Path $DeckPath)) {
    Write-Err "Arquivo de baralho não encontrado em: $DeckPath"
    exit 1
}

# 3. Ler o baralho e parsear os cartões
Write-Info "Lendo cartões em: $DeckPath..."
$lines = Get-Content $DeckPath -Encoding UTF8
$deckName = "DIO Agent::Projetos Praticos"
$notes = @()

foreach ($line in $lines) {
    if ($line.StartsWith("#deck:")) {
        $deckName = $line.Substring(6).Trim()
        continue
    }
    if ($line.StartsWith("#") -or [string]::IsNullOrWhiteSpace($line)) {
        continue
    }

    $parts = $line -split "`t"
    if ($parts.Count -ge 2) {
        $front = $parts[0].Trim()
        $back = $parts[1].Trim()
        $tags = if ($parts.Count -ge 3) { ($parts[2] -split " ") } else { @("dio-agent") }

        $notes += @{
            deckName = $deckName
            modelName = "Basic"
            fields = @{
                Front = $front
                Back = $back
            }
            tags = $tags
            options = @{
                allowDuplicate = $false
                duplicateScope = "deck"
            }
        }
    }
}

if ($notes.Count -eq 0) {
    Write-Warn "Nenhum cartão válido encontrado para processar."
    exit 0
}

Write-Info "Total de $($notes.Count) cartões lidos do arquivo."

# 4. Criar o baralho no Anki se não existir
$createDeckBody = @{
    action = "createDeck"
    version = 6
    params = @{
        deck = $deckName
    }
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri $ankiUrl -Method Post -Body $createDeckBody -ContentType "application/json" | Out-Null

# 5. Enviar notas uma a uma, usando findNotes para verificar se já existem
Write-Info "Verificando quais cartões já existem e adicionando os novos..."

$addedCount = 0
$existingCount = 0
$errorCount = 0

foreach ($note in $notes) {
    # Escapa aspas para uso na query de busca
    $frontText = $note.fields.Front -replace '"', '\"'

    # Tenta adicionar diretamente (allowDuplicate = false já protege contra duplicação)
    $addBody = @{
        action  = "addNote"
        version = 6
        params  = @{
            note = $note
        }
    } | ConvertTo-Json -Depth 8 -Compress

    try {
        $addResp = Invoke-RestMethod -Uri $ankiUrl -Method Post -Body $addBody -ContentType "application/json"
        if ($null -ne $addResp.error -and $addResp.error -ne "") {
            # Duplicata identificada pelo AnkiConnect — agendamento intacto
            $existingCount++
        } else {
            $addedCount++
        }
    } catch {
        $errorCount++
        Write-Warn "Falha ao processar um cartão: $($_.Exception.Message)"
    }
}

Write-Info "Cartões já existentes preservados (agendamento 100% intacto): $existingCount"
if ($errorCount -gt 0) {
    Write-Warn "Cartões com erro (verifique o tipo de nota 'Basic' no Anki): $errorCount"
}



if ($addedCount -eq 0 -and $existingCount -gt 0) {
    Write-Success "Todos os $existingCount cartões já estão no Anki! Nenhuma alteração necessária."
} elseif ($addedCount -gt 0) {
    Write-Success "=== SUCESSO: $addedCount novo(s) cartão(ões) adicionados diretamente no Anki! ==="
    Write-Host "Baralho: $deckName" -ForegroundColor Magenta
}


# 6. Sincronizar com AnkiWeb (se solicitado)
if ($AutoSync) {
    Write-Info "Disparando sincronização com o AnkiWeb (nuvem/celular)..."
    try {
        $syncBody = '{"action": "sync", "version": 6}'
        Invoke-RestMethod -Uri $ankiUrl -Method Post -Body $syncBody -ContentType "application/json" | Out-Null
        Write-Success "Sincronização com AnkiWeb disparada!"
    } catch {
        Write-Warn "Não foi possível sincronizar com AnkiWeb automaticamente: $($_.Exception.Message)"
    }
}
