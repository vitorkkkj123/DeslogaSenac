# 🛡️ DeslogaSenac v1.0

O **DeslogaSenac** é uma solução de infraestrutura e segurança digital desenvolvida para os laboratórios do **SENAC Bahia**. O foco principal é a proteção de dados dos usuários (alunos e docentes) através da automação do encerramento de sessões e limpeza de rastros de navegação, garantindo total conformidade com a **LGPD (Lei Geral de Proteção de Dados)**.

## 🚀 O Problema
Em ambientes de uso compartilhado, é comum que usuários esqueçam contas pessoais logadas (Google, WhatsApp, LinkedIn, e-mails). Isso gera um risco crítico de exposição de dados e vulnerabilidades de segurança para a instituição.

## ✨ Solução e Funcionalidades
O DeslogaSenac transforma uma tarefa manual e negligenciada em um processo sistêmico:

- **Interface Gráfica (GUI):** Operação intuitiva com barra de progresso, removendo a complexidade técnica para o usuário final.
- **Limpeza Multi-Browser:** Suporte completo para **Google Chrome, Microsoft Edge e Brave**.
- **Exclusão Profunda:** Vai além de limpar cookies; remove pastas de sessão e perfis locais para garantir o logoff real.
- **Instalação Automatizada:** Script de deploy que configura o Agendador de Tarefas do Windows com apenas um clique.
- **Resiliência:** Configurado para rodar no logon, garantindo que o computador inicie o dia limpo.

## 📂 Estrutura do Projeto
- `src/`: Contém o cérebro do projeto (Script PowerShell) e o lançador (Batch).
- `deploy/`: Contém o script de automação para implementação em larga escala.
- `assets/`: Demonstrações visuais e capturas de tela do software em operação.

## 🛠️ Como Instalar (Para TI)
Para implementar em uma máquina ou via servidor (AD):
1. Navegue até a pasta `deploy/`.
2. Execute o arquivo `instalar.ps1` como Administrador.
3. O sistema criará automaticamente a tarefa agendada `DeslogaSenac_Startup`.

> **Nota:** O script foi desenhado para rodar em modo *Hidden* (escondido) quando acionado pelo sistema, mantendo a experiência do usuário limpa.

## 🏗️ Tecnologias
- **PowerShell & WinForms:** Interface e lógica de manipulação de sistema.
- **Batch:** Wrapper para elevação de privilégios e execução silenciosa.
- **Schtasks:** Orquestração de tarefas nativas do Windows.

## 📄 Licença
Distribuído sob a **Licença MIT**. Veja `LICENSE` para mais informações.

---
**Desenvolvido por Vitor Guilherme**  
*Foco em Segurança da Informação e Automação de Infraestrutura.*