# 🧠 Guia do Baralho Anki: Fichamento Prático & Repetição Espaçada

Bem-vindo ao sistema de repetição espaçada do **DIO Agent**. Este baralho foi projetado com a metodologia de **fichamento multidimensional**, transformando aprendizados práticos, decisões de arquitetura e desafios de código em cartões de alto rendimento.

---

## 🎯 Por que este modelo é diferente?

Em vez de perguntas rasas ou conceituais soltas, cada tema abordado no projeto é desmembrado em:
- **Cartões Conceituais:** Definições, finalidades, funcionamento e arquitetura com contexto prático;
- **Cartões de Verdadeiro ou Falso:** Proposições completas onde as afirmativas falsas explicam detalhadamente a pegadinha e o conceito confundido;
- **Questões de Múltipla Escolha (Estilo FGV):** Enunciados com 5 alternativas (A-E), análise individual de cada alternativa incorreta e justificativa do gabarito.

---

## ⚡ Método 1: Atualização Direta pela IDE (Recomendado - 1 Clique)

Você pode enviar os novos cartões para o Anki **diretamente da IDE ou do terminal**, sem precisar abrir telas de importação nem selecionar arquivos!

### Como habilitar uma única vez no seu Anki:

1. Abra o aplicativo **Anki** no computador;
2. No menu superior, vá em: **Ferramentas** (`Tools`) -> **Complementos** (`Add-ons`) -> **Obter complementos...** (`Get Add-ons...`);
3. Cole o código do complemento oficial **AnkiConnect**:
   ```
   2055492159
   ```
4. Clique em **OK** e reinicie o Anki.

### Como usar no dia a dia pela IDE:

Com o Anki aberto (pode ficar minimizado em segundo plano), abra o terminal na IDE e rode:

```powershell
# Opção A: Sincronizar apenas o Anki direto
.\anki\anki-push.ps1

# Opção B: Sincronizar com o GitHub E com o Anki ao mesmo tempo!
.\sync.ps1 -Anki
```

O script faz tudo sozinho:
- Cria o baralho `DIO Agent::Projetos Praticos` automaticamente (se ainda não existir);
- Verifica quais notas já existem para **NÃO duplicar e NÃO resetar nenhum agendamento**;
- Injeta instantaneamente os novos cartões;
- Dispara a sincronização com o **AnkiWeb** (para os novos cartões irem direto para o seu celular/tablet).

---

## 📁 Método 2: Importação Manual pelo Aplicativo (Arquivo .txt)

Se você preferir não usar o complemento, pode importar o arquivo cumulativo [`anki/dio_agent_deck.txt`](dio_agent_deck.txt) manualmente a qualquer momento:

1. Abra o Anki;
2. Vá em **Arquivo** (`File`) -> **Importar** (`Import...`) ou aperte `Ctrl + I`;
3. Selecione o arquivo `dio-agent/anki/dio_agent_deck.txt`;
4. Na janela de importação que se abre:
   - **Tipo de Nota (Type):** `Básico` (ou `Basic`);
   - **Baralho (Deck):** `DIO Agent::Projetos Praticos`;
   - ⚠️ **Notas Existentes (Existing Notes):** Selecione **"Ignorar linhas onde o primeiro campo coincida com nota existente"** (*Ignore lines where first field matches existing note*).


---

## 🔄 Rotina Diária de Estudos Recomendada

1. **Durante o dia:** Desenvolva seus projetos e estude com o DIO Agent. Sempre que um novo conceito ou desafio for concluído, o agente adicionará novos cards ao arquivo [`anki/dio_agent_deck.txt`](dio_agent_deck.txt);
2. **No final do dia:**
   - Execute o script `.\sync.ps1` para sincronizar suas alterações com seu GitHub;
   - Abra o Anki e importe o arquivo `anki/dio_agent_deck.txt` (com a opção *Ignorar existentes* ativada);
   - Os novos cards entrarão na sua fila de hoje, e os cards antigos continuarão com seus agendamentos matemáticos originais!

---

## 🎨 Layout Trabalhado

Os cartões utilizam estilização moderna (CSS inline com bordas arredondadas, sombras suaves, badges coloridos para cada tipo de questão e blocos de código com fontes monoespaçadas). Eles são 100% responsivos e compatíveis tanto com o tema Claro quanto com o tema Escuro (Dark Mode) do Anki Desktop, AnkiMobile (iOS) e AnkiDroid (Android).
