# 🧠 Guia do Baralho Anki: Fichamento Prático & Repetição Espaçada

Bem-vindo ao sistema de repetição espaçada do **DIO Agent**. Este baralho foi projetado com a metodologia de **fichamento multidimensional**, transformando aprendizados práticos, decisões de arquitetura e desafios de código em cartões de alto rendimento.

---

## 🎯 Por que este modelo é diferente?

Em vez de perguntas rasas ou conceituais soltas, cada tema abordado no projeto é desmembrado em:
- **Cartões Conceituais:** Definições, finalidades, funcionamento e arquitetura com contexto prático;
- **Cartões de Verdadeiro ou Falso:** Proposições completas onde as afirmativas falsas explicam detalhadamente a pegadinha e o conceito confundido;
- **Questões de Múltipla Escolha (Estilo FGV):** Enunciados com 5 alternativas (A-E), análise individual de cada alternativa incorreta e justificativa do gabarito.

---

## 🚀 Como Importar no Anki SEM Resetar Agendamentos

O arquivo mestre [`anki/dio_agent_deck.txt`](dio_agent_deck.txt) é **cumulativo**. Você pode importá-lo todos os dias sem medo de perder suas revisões antigas, seguindo os passos abaixo:

### Passo a Passo no Anki Desktop:

1. Abra o Anki;
2. Vá em **Arquivo** (`File`) -> **Importar** (`Import...`) ou aperte `Ctrl + I`;
3. Selecione o arquivo `dio-agent/anki/dio_agent_deck.txt`;
4. Na janela de importação que se abre, configure com atenção:
   - **Tipo de Nota (Type):** `Básico` (ou `Basic`);
   - **Baralho (Deck):** Selecione ou deixe criar automaticamente `DIO Agent::Projetos Praticos`;
   - **Separador de Campo:** `Tab` (reconhecido automaticamente pela diretiva `#separator:tab`);
   - **Permitir HTML nos campos:** Marque como ativado (ou já virá ativo por `#html:true`);
   - ⚠️ **Notas Existentes (Existing Notes / Duplicate Action):** Selecione **"Ignorar linhas onde o primeiro campo coincida com nota existente"** (*Ignore lines where first field matches existing note*).

> [!IMPORTANT]
> **Essa é a garantia do seu agendamento:** Ao selecionar "Ignorar linhas onde o primeiro campo coincida com nota existente", o Anki compara a Frente de cada cartão. Se você já tem aquele cartão no baralho, ele **não altera nada** (mantém seus intervalos, facilidade e data de revisão intactos!). Ele adicionará **apenas os cartões novos criados no dia**.

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
