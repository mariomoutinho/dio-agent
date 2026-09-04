<#
.SYNOPSIS
    Script de automação para commits e sincronização com o GitHub.
.DESCRIPTION
    Automatiza as etapas de git add, git commit e git push para o repositório
    pessoal (origin) e permite sincronizar com as novidades da DIO (upstream).
.PARAMETER Message
    Mensagem personalizada para o commit. Se omitido, gera uma mensagem automática com data e arquivos modificados.
.PARAMETER PullUpstream
    Puxa e mescla as atualizações mais recentes do repositório oficial da DIO (upstream/main).
.EXAMPLE
    .\sync.ps1
.EXAMPLE
    .\sync.ps1 "Minha mensagem de alteração"
.EXAMPLE
    .\sync.ps1 -PullUpstream
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Message,

    [switch]$PullUpstream,
    [switch]$StatusOnly,
    [switch]$Anki
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

# 1. Verificar se o Git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Err "Git não foi encontrado no PATH do sistema. Certifique-se de que o Git está instalado."
    exit 1
}

# 2. Sincronizar com upstream (se solicitado)
if ($PullUpstream) {
    Write-Info "Buscando atualizações do repositório oficial da DIO (upstream)..."
    try {
        git fetch upstream
        git merge upstream/main --no-edit
        Write-Success "Repositório atualizado com as últimas novidades da DIO!"
    } catch {
        Write-Warn "Houve um conflito ou erro ao mesclar com upstream. Verifique o status com 'git status'."
        exit 1
    }
}

# 3. Verificar status atual
$status = git status --porcelain
if ($StatusOnly) {
    Write-Info "Status do repositório:"
    git status
    exit 0
}

# 4. Se não há alterações
if (-not $status) {
    Write-Warn "Nenhuma alteração detectada para commit."
    
    # Verificar se há commits locais não enviados
    $unpushed = git log origin/main..HEAD --oneline 2>$null
    if ($unpushed) {
        Write-Info "Existem commits locais pendentes de envio. Enviando para o GitHub..."
        git push origin main
        Write-Success "Commits pendentes enviados com sucesso!"
    } else {
        Write-Success "O repositório local já está sincronizado com o GitHub (mariomoutinho/dio-agent)."
    }
    exit 0
}

Write-Info "Arquivos alterados detectados:"
git status -s

# 5. Adicionar arquivos ao stage
Write-Info "Adicionando alterações (git add .)..."
git add .

# 6. Definir mensagem de commit
if ([string]::IsNullOrWhiteSpace($Message)) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $changedFilesCount = ($status -split "`n").Count
    $Message = "update: sincronizacao automatica em $timestamp ($changedFilesCount arquivos)"
}

Write-Info "Criando commit com a mensagem: '$Message'..."
git commit -m $Message

# 7. Realizar Push para o GitHub
Write-Info "Enviando alterações para o GitHub (origin main)..."
try {
    git push origin main
    Write-Success "=== Sincronização concluída com sucesso no GitHub! ==="
    Write-Host "Repositório: https://github.com/mariomoutinho/dio-agent" -ForegroundColor Magenta
} catch {
    Write-Err "Falha ao enviar para o GitHub: $($_.Exception.Message)"
    exit 1
}

# 8. Sincronizar com o Anki (se solicitado via -Anki ou se script específico for invocado)
if ($Anki) {
    Write-Host ""
    Write-Info "Disparando atualização direta no Anki Desktop..."
    if (Test-Path "$PSScriptRoot\anki\anki-push.ps1") {
        & "$PSScriptRoot\anki\anki-push.ps1"
    } else {
        Write-Warn "Script anki-push.ps1 não encontrado na pasta anki/."
    }
}

