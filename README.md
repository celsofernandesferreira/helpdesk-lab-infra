# helpdesk-lab-infra
Corporate Lab featuring Windows Server, Active Directory, DNS, and PowerShell Automation.

# Project Description:
Implementation of a complete corporate lab using Windows Server 2022, focused on centralized management, network security, and automated software provisioning for IT support teams.

# Technologies Used:
OS: Windows Server 2022, Windows 10/11 (Client).

Infrastructure: Active Directory (AD DS), DNS, RRAS (Routing and NAT), GPO.

Automation: PowerShell, Chocolatey (Package Manager).

ITSM: Jira Service Management.

<img width="959" height="800" alt="Captura de ecrã 2026-03-18 155442" src="https://github.com/user-attachments/assets/d2ad5142-4bb2-417c-b9d0-cb3a7350c055" />


# Architecture and Implemented Solutions:
# 1. Identity and Access Management (Active Directory):

Creation of the helpdesk.local domain.

Structuring of OUs (Organizational Units) for logical separation of computers and technical users (e.g., zemanel).
<img width="908" height="843" alt="Captura de ecrã 2026-03-18 005425" src="https://github.com/user-attachments/assets/a4c0abcd-b0bc-4be1-bcc0-13745420cf53" />


# 2. Network Engineering and Security (RRAS & NAT):

Configuration of the Server (DC1) as the network Gateway.

Isolation of the workstation from direct internet access, providing secure and filtered access via network sharing (NAT Routing) from the central server.
<img width="1847" height="844" alt="Captura de ecrã 2026-03-18 005358" src="https://github.com/user-attachments/assets/dd1876ee-32dc-4729-a621-a96e9747ff46" />


# 3. Advanced Troubleshooting: DNS Conflict in a Multihomed Server:

The Incident: The server had two network interface cards (LAN and NAT). The DNS service automatically registered the NAT IP (10.0.3.15), causing intermittent Kerberos failures and breaking Group Policies on the client PC.

The Surgical Resolution: In the DNS Manager server properties, interface listening was changed from "All IP addresses" exclusively to the static internal network IP (10.0.2.10). Additionally, dynamic DNS registration on the NAT interface was disabled. This instantly stabilized the domain and the nslookup resolution on the client side.
<img width="959" height="534" alt="Captura de ecrã 2026-03-18 160429" src="https://github.com/user-attachments/assets/68401182-6d7f-4d53-8f80-becf856aff4c" />


# 4. "Zero-Touch" Software Automation (Chocolatey):

Development of a PowerShell script (ins-choco.ps1) to inject the package manager and silently download critical tools (Chrome, AnyDesk, Greenshot, etc.).

Exception Handling: Resolution of Installation Error 1603 (conflict with older Chrome versions) by forcing registry cleanups and deleting orphaned directories via CLI (Remove-item -recurse -force "c:\program files\google\chrome";
choco install Googlechrome -y --force --ignore-checksums).

<img width="1014" height="743" alt="Captura de ecrã 2026-03-18 005930" src="https://github.com/user-attachments/assets/a338a195-a51c-4804-9ce2-7aec2e0a54ae" />
<img width="1015" height="748" alt="Captura de ecrã 2026-03-18 005958" src="https://github.com/user-attachments/assets/212210cd-9792-42a5-ad24-bc613cbfb456" />



# 5. Environment Standardization (GPOs):

Dynamic mapping of network drives (Drive Z: for "Company Share").

Enforcement of a corporate UI (Wallpaper) and blocking of sensitive functions (Control Panel) from the end-user.

Implementation of a direct Desktop shortcut integrated with the Cloud ticketing platform (Jira)
<img width="928" height="786" alt="Captura de ecrã 2026-03-18 010322" src="https://github.com/user-attachments/assets/7cdece91-7a3d-4650-892d-3509697589ee" />
<img width="1861" height="837" alt="Captura de ecrã 2026-03-18 004601" src="https://github.com/user-attachments/assets/4f1a1776-22c5-4523-b58c-163365ca06e9" />




# Em Português

# helpdesk-lab-infra
Laboratório corporativo com Windows Server, Active Directory, DNS e Automação via PowerShell.

# Descrição do Projeto:

Implementação de um laboratório corporativo completo utilizando Windows Server 2022, focado na gestão centralizada, segurança de rede e provisionamento automatizado de software para equipas de suporte de TI.

# Tecnologias Utilizadas:

OS: Windows Server 2022, Windows 10/11 (Client).

Infraestrutura: Active Directory (AD DS), DNS, RRAS (Routing and NAT), GPO.

Automação: PowerShell, Chocolatey (Package Manager).

ITSM: Jira Service Management.

# Arquitetura e Soluções Implementadas:

# 1º Gestão de Identidade e Acesso (Active Directory):

Criação do domínio helpdesk.local.

Estruturação de OUs (Organizational Units) para separação lógica de computadores e utilizadores técnicos (ex: zemanel).


# 2º Engenharia de Rede e Segurança (RRAS & NAT):

Configuração do Servidor (DC1) como Gateway da rede.

Isolamento do posto de trabalho da internet direta, fornecendo acesso seguro e filtrado através de partilha de rede (NAT Routing) a partir do servidor central.

# 3º Troubleshooting Avançado: O Conflito DNS em Servidor Multihomed:

O Incidente: O Servidor possuía duas placas de rede (LAN e NAT). O serviço DNS registava automaticamente o IP da NAT (10.0.3.15), causando falhas intermitentes de Kerberos e quebra nas Políticas de Grupo no PC cliente.

A Resolução Cirúrgica: No DNS Manager, nas propriedades do servidor, a escuta das interfaces foi alterada de "Todos os endereços IP" exclusivamente para o IP estático da rede interna (10.0.2.10). Adicionalmente, o registo DNS dinâmico na placa NAT foi desativado. Isto estabilizou instantaneamente o domínio e a resolução via nslookup no cliente.

# 4º Automação de Software "Zero-Touch" (Chocolatey):

Desenvolvimento de script em PowerShell (ins-choco.ps1) para injetar o gestor de pacotes e descarregar silenciosamente as ferramentas críticas (Chrome, AnyDesk, Greenshot, etc.).

Tratamento de Exceções: Resolução do Erro de Instalação 1603 (conflito de versões antigas do Chrome) forçando limpezas de registo e diretórios órfãos via CLI (choco uninstall googlechrome -y).

# 5º Padronização de Ambiente (GPOs):

Mapeamento dinâmico de unidades de rede (Disco Z: para "Partilha da Empresa").

Aplicação de UI corporativa (Wallpaper) e bloqueio de funções sensíveis (Painel de Controlo) ao utilizador final.

Implementação de atalho direto no Ambiente de Trabalho integrado com a plataforma de ticketing na Cloud (Jira).
