---
name: anki-cards
description: Transforma aprendizados e decisões práticas de projetos em cartões de revisão de alto rendimento para o Anki (Conceituais, V/F e Múltipla Escolha FGV) com layout trabalhado e formato cumulativo.
---

# Skill: Fichamento Prático & Anki de Alto Rendimento

Esta skill transforma o conhecimento técnico, comandos, padrões de arquitetura e decisões de engenharia vivenciadas na prática dos projetos em cartões atômicos e autossuficientes para o **Anki**, aplicando a metodologia de **fichamento multidimensional**.

---

## Quando Usar

- Sempre que um novo conceito técnico, ferramenta ou padrão for ensinado ou implementado no projeto;
- Ao concluir um Desafio de Código, Desafio de Projeto ou funcionalidade relevante;
- Após investigar e solucionar um bug sutil, erro comum de configuração ou pegadinha de sintaxe/arquitetura;
- Quando o estudante solicitar explicitamente a geração de flashcards para fixação e repetição espaçada.

---

## 1. As 14 Dimensões do Fichamento Técnico Prático

Em vez de perguntas rasas ou retiradas mecanicamente do código, o agente desmembra cada conceito relevante trabalhado no projeto em suas diferentes dimensões práticas:

1. **Definição técnica:** O que é o conceito/ferramenta com rigor técnico e sem simplificações enganosas;
2. **Finalidade:** Qual problema de software ele resolve e por que foi escolhido no projeto;
3. **Funcionamento interno:** Mecânica de execução por baixo do capô (o que acontece nos bastidores);
4. **Características essenciais:** Propriedades que o definem e o diferenciam;
5. **Componentes / Arquitetura:** Partes integrantes e como interagem entre si;
6. **Etapas / Pipeline:** Sequência de execução, fluxo de ciclo de vida ou comandos necessários;
7. **Vantagens:** Benefícios de desempenho, manutenibilidade, segurança ou ergonomia;
8. **Limitações e Trade-offs:** Custos, desvantagens, restrições de uso e quando NÃO usar;
9. **Exemplos práticos de código/comando:** Trechos concisos, sintaxe real e comandos do terminal;
10. **Exceções e Casos de Borda (Edge Cases):** Situações atípicas que quebram o fluxo padrão;
11. **Comparação com semelhantes:** Diferença sutil entre conceitos que costumam ser confundidos;
12. **Erros e confusões comuns:** Más práticas, antipatterns e erros clássicos de desenvolvedores;
13. **Consequências práticas no projeto:** O que acontece se for implementado errado ou esquecido;
14. **Pegadinhas técnicas (Concursos & Entrevistas):** Afirmações que parecem corretas mas contêm armadilhas conceituais ou sutilezas de bancas como FGV e Cebraspe.

---

## 2. Os 3 Tipos Obrigatórios de Cartões

### Tipo 1: Cartão Conceitual
- **Frente:** Pergunta atômica, autossuficiente e contextualizada (ex: *"No Git, qual é a diferença técnica entre os remotes 'origin' e 'upstream' em um fluxo de trabalho com fork?"*).
- **Verso:** Resposta estruturada, clara e suficiente para estudo sem precisar abrir o editor. Destaca a definição, a finalidade e a consequência prática.

### Tipo 2: Cartão de Verdadeiro ou Falso
- **Frente:** Começa estritamente com `Verdadeiro ou falso: [proposição técnica completa]`. A afirmação precisa ser rica em contexto, evitando termos vagos.
- **Verso:** 
  - **Julgamento:** `Verdadeiro.` ou `Falso.`
  - **Justificativa técnica:** Explicação lógica e fundamentada.
  - **Regra estrita para afirmações falsas:** Indicar exatamente qual palavra/termo tornou a afirmativa falsa, como ela deveria ser reescrita e qual conceito foi inadvertidamente confundido.
  - **Pegadinha identificada:** Explicar por que alguém poderia cair na armadilha.

### Tipo 3: Questão de Múltipla Escolha (Estilo FGV)
- **Frente:** Enunciado de situação-problema técnica ou conceitual + exatamente 5 alternativas (A, B, C, D e E).
- **Verso:**
  - **Gabarito:** Letra correta (ex: `Gabarito: C.`).
  - **Justificativa da alternativa correta:** Por que ela atende integralmente ao enunciado.
  - **Análise exaustiva dos distratores:** Análise individual de CADA uma das 4 alternativas incorretas (ex: *"A está incorreta: ... / B está incorreta: ... / D está incorreta: ... / E está incorreta: ..."*).
  - **Pegadinha:** Destaque da armadilha que induz ao erro.

---

## 3. Design System do Layout Trabalhado (HTML/CSS)

Os cartões devem possuir formatação visual moderna, legível e responsiva, com suporte a Dark Mode e Light Mode nativos do Anki.

### Cores e Estilos Padrão (Inline CSS)
- **Container Frente:** `<div style="font-family: 'Segoe UI', -apple-system, sans-serif; font-size: 16px; line-height: 1.5; color: #1e293b; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); text-align: left;">`
- **Badge de Tipo:**
  - Conceitual: `<span style="display: inline-block; padding: 3px 10px; font-size: 11px; font-weight: 700; color: #ffffff; background: #4f46e5; border-radius: 20px; text-transform: uppercase; margin-bottom: 12px;">CONCEITUAL</span>`
  - Verdadeiro ou Falso: `<span style="display: inline-block; padding: 3px 10px; font-size: 11px; font-weight: 700; color: #ffffff; background: #0891b2; border-radius: 20px; text-transform: uppercase; margin-bottom: 12px;">VERDADEIRO OU FALSO</span>`
  - FGV Múltipla Escolha: `<span style="display: inline-block; padding: 3px 10px; font-size: 11px; font-weight: 700; color: #ffffff; background: #7c3aed; border-radius: 20px; text-transform: uppercase; margin-bottom: 12px;">MÚLTIPLA ESCOLHA (FGV)</span>`
- **Caixa de Código:** `<code style="font-family: 'Fira Code', Consolas, monospace; background: #e2e8f0; color: #0f172a; padding: 2px 6px; border-radius: 4px; font-size: 14px;">...</code>`
- **Caixa de Julgamento Verdadeiro:** `<div style="display: inline-block; font-weight: 800; font-size: 18px; color: #16a34a; background: #dcfce7; padding: 6px 16px; border-radius: 8px; margin-bottom: 12px;">VERDADEIRO</div>`
- **Caixa de Julgamento Falso:** `<div style="display: inline-block; font-weight: 800; font-size: 18px; color: #dc2626; background: #fee2e2; padding: 6px 16px; border-radius: 8px; margin-bottom: 12px;">FALSO</div>`
- **Caixa de Gabarito:** `<div style="display: inline-block; font-weight: 800; font-size: 18px; color: #2563eb; background: #dbeafe; padding: 6px 16px; border-radius: 8px; margin-bottom: 12px;">GABARITO: X</div>`
- **Bloco de Análise / Pegadinha:** `<div style="background: #fffbeb; border-left: 4px solid #f59e0b; padding: 10px 14px; margin-top: 14px; border-radius: 0 8px 8px 0; font-size: 14px; color: #92400e;"><b>⚠️ Pegadinha Técnica:</b> ...</div>`

---

## 4. Regras Absolutas de Formato de Arquivo

Para garantir que o Anki interprete o arquivo sem erros e sem resetar agendamentos:

1. **Cabeçalho Obrigatório no topo do arquivo:**
   ```text
   #separator:tab
   #html:true
   #deck:DIO Agent::Projetos Praticos
   #columns:Frente	Verso	Etiquetas
   ```
2. **Estritamente UMA Linha Física por Cartão:**
   - O delimitador entre `Frente`, `Verso` e `Etiquetas` é um único caractere TAB (`\t`).
   - NUNCA quebre a linha dentro do HTML usando `\r\n` ou `\n`.
   - Todas as quebras visuais e parágrafos DEVEM usar tags HTML (`<br>`, `<p style="...">`, `<div>`, `<ul>`, `<li>`).
3. **Estrutura das Etiquetas (Tags):**
   - Separadas por espaço simples.
   - Padrão recomendado: `dio-agent projeto::<nome_do_projeto> tipo::<conceitual|vf|fgv> topico::<assunto> prioridade::<alta|media>`.
4. **Armazenamento:**
   - **Arquivo Mestre Cumulativo:** `anki/dio_agent_deck.txt` (onde todos os cartões são reunidos).
   - **Lotes Diários Opcionais:** `anki/daily/anki_cards_YYYY-MM-DD.txt` para importação isolada da produção do dia.

---

## 5. Como o Usuário Mantém Agendamentos Intactos

Ao instruir o estudante na importação:
- No Anki Desktop: `Arquivo -> Importar -> Selecionar o arquivo .txt`.
- Em **Notas Existentes (Existing Notes)**, selecionar:
  - **"Ignorar linhas onde o primeiro campo coincida com nota existente"** (Ignore lines where first field matches existing note).
- Dessa forma:
  - O Anki examina o primeiro campo (a Frente do cartão);
  - Se o cartão já foi estudado, ele **não é tocado**, preservando intervalos, facilidade, histórico de revisões e agendamento;
  - Apenas os cartões novos são adicionados ao baralho existente.
