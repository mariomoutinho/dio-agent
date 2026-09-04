# 🚀 Automação de Sincronização com o GitHub

Este repositório está configurado para salvar e sincronizar seu progresso diretamente com o seu perfil do GitHub.

- **Seu Repositório Remoto (`origin`):** [https://github.com/mariomoutinho/dio-agent](https://github.com/mariomoutinho/dio-agent)
- **Repositório Base da DIO (`upstream`):** [https://github.com/digitalinnovationone/dio-agent](https://github.com/digitalinnovationone/dio-agent)

---

## 🛠️ Como usar o script `sync.ps1`

Você pode executar o script no terminal PowerShell dentro da pasta do projeto:

### 1. Sincronização Rápida (Automática)
Adiciona todos os arquivos modificados/novos, gera uma mensagem com data/hora e envia para o seu GitHub:
```powershell
.\sync.ps1
```

### 2. Sincronização com Mensagem Personalizada
Especifique o que você fez no commit:
```powershell
.\sync.ps1 "feat: adicionando nova quest para o agente"
```

### 3. Puxar Atualizações da DIO (`upstream`)
Se o repositório oficial da Digital Innovation One receber melhorias ou novas funcionalidades, atualize seu projeto rodando:
```powershell
.\sync.ps1 -PullUpstream
```

### 4. Apenas Ver o Status
```powershell
.\sync.ps1 -StatusOnly
```

---

## 📌 Comandos Manuais do Git (Referência)

Caso prefira usar os comandos tradicionais do Git:
- **Ver alterações:** `git status`
- **Adicionar tudo:** `git add .`
- **Commit:** `git commit -m "sua mensagem"`
- **Enviar para seu repositório:** `git push origin main`
- **Atualizar da DIO:** `git pull upstream main`
