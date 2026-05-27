# 🛡️ DeslogaSenac

> **Automação inteligente e integrada para segurança da informação e privacidade em computadores compartilhados.**

---

## 🎯 O Problema

Em ambientes com computadores compartilhados (como laboratórios acadêmicos, lan houses ou coworkings), é extremamente comum que os usuários esqueçam suas contas pessoais conectadas (Google, GitHub, redes sociais e e-mails) ao término da sessão. Isso gera uma grave vulnerabilidade de segurança, deixando dados sensíveis e históricos expostos para o próximo usuário da máquina.

## 🚀 A Solução

O **DeslogaSenac** resolve esse problema de forma totalmente automatizada. Integrado diretamente ao **Agendador de Tarefas do Windows**, o sistema é disparado silenciosamente a cada novo logon no sistema operacional. 

Ele realiza o encerramento forçado dos principais navegadores e faz uma varredura cirúrgica, limpando caches, cookies, sessões ativas (`Current Session`/`Tabs`) e arquivos temporários locais, mitigando qualquer risco de exposição de dados sem corromper o perfil padrão de instalação dos browsers.

---

## 🛠️ Recursos e Tecnologias

* **Interface Gráfica Dinâmica**: Desenvolvida em PowerShell usando a biblioteca nativa `Windows Forms` para dar comandos claros e feedback visual ao usuário.
* **Identificação Dinâmica de Diretórios**: O instalador localiza automaticamente a raiz do projeto em qualquer máquina, independente do nome do usuário ou caminho do diretório local.
* **Persistência via Agendador de Tarefas**: Automação nativa do Windows configurada com privilégios elevados para garantir a execução a cada novo logon.
* **Compilação Autônoma**: Scripts de terminal convertidos em executáveis (`.exe`) via `PS2EXE` para facilitar a distribuição e o uso.

---

## 📂 Estrutura do Projeto

```text
DeslogaSenac/
├── deploy/
│   ├── instalar.exe    <-- Executável de instalação automatizada
│   └── instalar.ps1    <-- Código-fonte do instalador
└── src/
    └── INICIAR_DESLOGA_SENAC.bat  <-- Script que invoca a interface e a lógica de limpeza



🚀 Como Instalar e Usar
1. Pré-requisitos
Sistema Operacional Windows 10 ou 11.

Privilégios de Administrador na máquina para registrar a automação.

2. Instalação Automática
Baixe ou clone este repositório no computador.

Abra a pasta deploy/.

Clique com o botão direito sobre o arquivo instalar.exe e selecione "Executar como Administrador".

O terminal fará a configuração sozinho e criará o gatilho no sistema. Pronto!

3. Execução Manual
Se quiser forçar a limpeza a qualquer momento sem precisar deslogar do Windows:

Abra o Agendador de Tarefas do Windows (taskschd.msc).

Localize a tarefa DeslogaSenac_Startup.

Clique com o botão direito nela e selecione Executar. A interface do programa abrirá na tela para você iniciar a limpeza imediatamente.

🔒 Navegadores Suportados
A varredura apaga os rastros e encerra os processos dos seguintes navegadores:

[x] Google Chrome

[x] Microsoft Edge

[x] Brave Browser

[x] Pasta de arquivos temporários do sistema do usuário (%TEMP%)

Trabalho desenvolvido focado em automação de segurança e privacidade.