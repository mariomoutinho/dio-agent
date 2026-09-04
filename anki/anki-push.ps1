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
    [string]$DeckPath = "$PSScriptRoot\dio_agent_deck.txt",
    [switch]$AutoSync = $true
)

$ErrorActionPreference = "Stop"

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

# 5. Descobrir quais notas são novas e quais já existem (para não duplicar nem resetar nada)
Write-Info "Verificando quais cartões já existem no seu baralho Anki..."
$canAddBody = @{
    action = "canAddNotes"
    version = 6
    params = @{
        notes = $notes
    }
} | ConvertTo-Json -Depth 5

$canAddResp = Invoke-RestMethod -Uri $ankiUrl -Method Post -Body $canAddBody -ContentType "application/json"
$canAddList = $canAddResp.result

$notesToAdd = @()
$existingCount = 0

for ($i = 0; $i -lt $notes.Count; $i++) {
    if ($canAddList[$i] -eq $true) {
        $notesToAdd += $notes[$i]
    } else {
        $existingCount++
    }
}

Write-Info "Cartões já existentes preservados (agendamento 100% intacto): $existingCount"

if ($notesToAdd.Count -eq 0) {
    Write-Success "Todos os $existingCount cartões já estão no Anki! Nenhuma alteração necessária."
} else {
    Write-Info "Injetando $($notesToAdd.Count) novo(s) cartão(ões) diretamente no baralho '$deckName'..."
    
    $addNotesBody = @{
        action = "addNotes"
        version = 6
        params = @{
            notes = $notesToAdd
        }
    } | ConvertTo-Json -Depth 5

    $addResp = Invoke-RestMethod -Uri $ankiUrl -Method Post -Body $addNotesBody -ContentType "application/json"
    
    if ($addResp.error) {
        Write-Err "Erro ao adicionar notas: $($addResp.error)"
        exit 1
    }
    
    Write-Success "=== SUCESSO: $($notesToAdd.Count) novo(s) cartão(ões) adicionados diretamente no Anki! ==="
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
