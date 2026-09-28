# 🛡️ DeslogaSenac

> **Solução prática e transparente de privacidade e conformidade com a LGPD para estações de trabalho compartilhadas.**

---

## 🎯 O Problema

Em computadores de uso coletivo (como laboratórios acadêmicos, bibliotecas e coworkings), é rotineiro que alunos e usuários esqueçam sessões autenticadas ao sair da máquina — incluindo contas institucionais, Google Workspace, GitHub, e-mails, gerenciadores de senhas e mensageiros web (WhatsApp Web). 

Mesmo quando o usuário fecha o navegador, cookies de autenticação, tokens de sessão em `IndexedDB`/`Local Storage` e históricos permanecem em disco, deixando contas vulneráveis ao acesso do usuário seguinte e expondo a instituição a incidentes de privacidade sob a LGPD (Lei Geral de Proteção de Dados).

---

## 🚀 A Solução

O **DeslogaSenac** centraliza a higienização de navegadores em um utilitário simples, visual e de acionamento imediato. 

A solução disponibiliza um atalho persistente e padronizado na Área de Trabalho Pública da máquina (`Public Desktop`), permitindo que qualquer usuário execute a limpeza de sessão ao término de suas atividades com um único clique. 

A ferramenta realiza o encerramento seguro dos navegadores, remove perfis adicionais criados no Chromium, limpa o arquivo central `Local State` (impedindo que fotos e credenciais fiquem salvas no seletor de perfis), apaga bases de dados locais e expurga temporários da sessão ativa sem danificar os executáveis do sistema operacional.

---

## 🛠️ Principais Recursos

* **Interface Gráfica Interativa (GUI):** Desenvolvida em PowerShell com biblioteca nativa `Windows Forms`, com feedback em tempo real (barra de progresso e status detalhado).
* **Reset Cirúrgico de Perfis:** Remove perfis secundários (`Profile 1`, `Profile 2`, etc.) e purga o `Local State`, impedindo a persistência do seletor de contas vinculadas.
* **Limpeza Completa da Camada Web:**
  * Histórico de navegação, abas e sessões salvas (`Sessions`, `Current Tabs`, `Last Tabs`).
  * Bancos de dados de sessão modernos (`IndexedDB`, `Service Worker`, `Local Storage`).
  * Tokens de autenticação e cookies criptografados (`Network\Cookies`).
  * Caches em memória e disco (`Cache`, `Code Cache`, `GPUCache`).
* **Deploy Universal e Resiliente:** Instalador compilado via `PS2EXE` utilizando classes nativas da plataforma `.NET` (`System.IO`), imune a bloqueios de parâmetros e restrições severas de diretivas de domínio (GPO/AppLocker).
* **Identidade Visual Integrada:** Ícone de segurança personalizado embutido no instalador e aplicado ao atalho do Windows.

---

## 📂 Arquitetura do Projeto

```text
DeslogaSenac/
├── assets/
│   └── icone.ico                    <-- Ícone personalizado da aplicação
├── deploy/
│   ├── instalar.exe                 <-- Executável autônomo de provisionamento (Admin)
│   └── instalar.ps1                 <-- Código-fonte do instalador (.NET/PowerShell)
├── src/
│   ├── deslogasenac.ps1             <-- Interface gráfica e lógica profunda de limpeza
│   └── INICIAR_DESLOGA_SENAC.bat    <-- Lançador universal sem restrições de script
├── .gitignore
├── LICENSE
└── README.md


---

## 🌐 Navegadores Suportados

A ferramenta contempla todos os navegadores baseados na arquitetura Chromium instalados no ambiente acadêmico:

* [x] **Google Chrome** (`Default` + `Profile *` + `Local State`)
* [x] **Microsoft Edge** (`Default` + `Profile *` + `Local State`)
* [x] **Brave Browser** (`Default` + `Profile *` + `Local State`)
* [x] **Arquivos Temporários do Usuário** (`%TEMP%`)

---

## 🚀 Como Instalar e Utilizar

### 1. Pré-requisitos
* **Sistema Operacional:** Windows 10 ou Windows 11.
* **Acesso de Administrador:** Apenas no momento da **instalação** (necessário para criar a pasta protegida em `C:\DeslogaSenac` e o atalho público para todos os usuários).

---

### 2. Instalação na Máquina (Feito uma única vez por estação)
1. Baixe, clone ou copie o projeto via pendrive para a máquina.
2. Navegue até o diretório `deploy/`.
3. Clique com o **botão direito** sobre o arquivo **`instalar.exe`** e selecione **"Executar como Administrador"**.
4. O instalador provisionará a estrutura central em `C:\DeslogaSenac` e criará o atalho **DeslogaSenac** na Área de Trabalho de todos os usuários.
5. Pressione qualquer tecla para concluir.

---

### 3. Como Utilizar (Pelo Aluno ou Usuário Final)
Não são necessários privilégios administrativos para executar a limpeza no dia a dia:

1. Antes de se ausentar da estação de trabalho, localize o ícone **DeslogaSenac** na sua **Área de Trabalho**.
2. Dê um **duplo clique** para abrir a aplicação.
3. Clique no botão **"INICIAR LIMPEZA AGORA"**.
4. Os navegadores serão fechados com segurança e todos os rastros de autenticação serão excluídos.
5. Ao exibir o alerta de confirmação em tela, seus dados e credenciais estarão completamente protegidos.

---

## 📜 Licença

Este projeto está sob a licença [MIT](LICENSE).