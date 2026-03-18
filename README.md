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


# 6. Advanced Troubleshooting: 
 # 6.1 Kerberos Time Skew & GPO Failure:

The Incident: Group Policy updates (gpupdate /force) failed completely on the client PC (Zé Manel), preventing the corporate wallpaper and software scripts from deploying.

The Root Cause: A significant time discrepancy was identified between the Domain Controller and the client VM. Active Directory relies heavily on the Kerberos authentication protocol, which enforces a strict maximum time skew tolerance (default 5 minutes) to prevent replay attacks. The desynchronization broke the secure trust relationship, denying the PC access to the SYSVOL folder.

The Resolution: Forced a time synchronization on the client machine to strictly align with the Domain Controller (net time \\10.0.2.10 /set /y). Once the clocks were perfectly synced, Kerberos ticket-granting was restored, and gpupdate /force executed successfully.

# 6.2 Enforcing Localization Settings Under Restricted Environments:

The Incident: The client endpoint (Zé Manel's PC) defaulted to a US keyboard layout (en-US), causing character mapping issues for physical Portuguese (PT) keyboards.

The Complication: The end-user was unable to change the keyboard layout manually because a strict security GPO ("Bloquear Painel de Controlo" / Block Control Panel) was already enforced on their Organizational Unit (OU), stripping away their access to the Windows Settings.

The Resolution: Instead of weakening the security posture by temporarily lifting the Control Panel restriction, a centralized administrative approach was taken. A new Group Policy Object named Forçar Teclado PT was created and linked to the Malucos Do IT OU. This policy automatically forced the pt-PT input method for the user upon login, resolving the localization issue globally without breaking the principle of least privilege.

# 6.3 UNC Path Resolution and SMB Share Mapping:
The Incident: Network drive mapping (Drive Z:) via Group Policy Preferences initially failed when attempting to use the domain name in the UNC path (e.g., \\helpdesk.local\Partilha Da Empresa CF).

The Root Cause: Standard SMB file shares are bound to the specific host server. While Active Directory automatically resolves domain-based paths for built-in folders like \SYSVOL or \NETLOGON, custom shared folders require Distributed File System (DFS) Namespaces to be accessed via the domain root. Without DFS configured, the explicit hostname or IP of the file server is required.

The Resolution: Reconfigured the Drive Maps GPO to use the correct Direct UNC path pointing to the specific Domain Controller's hostname (\\DC1\Partilha Da Empresa CF). The drive mapped successfully upon the next policy refresh.

 6.3.1 How it was fixed:
 Accessing the Group Policy Editor:
You opened the Group Policy Management console on your server and edited the GPO responsible for the company drives (linked to the Malucos Do IT OU).

6.3.2 Navigating to Drive Maps:
Inside the Group Policy Management Editor, you drilled down to the exact configuration path for user preferences:
User Configuration > Preferences > Windows Settings > Drive Maps

6.3.3 Correcting the UNC Path (The Fix):
You opened the properties for the Z: drive mapping and made the crucial change in the Location field:

Removed the wrong path: \\helpdesk.local\Partilha Da Empresa CF

Entered the correct explicit path: \\DC1\Partilha Da Empresa CF (pointing directly to the Domain Controller's hostname where the folder is physically hosted).

6.3.4 Setting the User Experience:
In that same window, you ensured the connection was persistent and user-friendly by configuring:

Action: Create 

Reconnect: Checked (so it survives reboots)

Label as: Dados Administrativos CF Empresa

Drive Letter: Z

6.3.5 Client-Side Update:
Finally, on Zé Manel's PC, the system pulled the new policy (either via a reboot, login, or gpupdate /force). The Z: drive successfully appeared in "This PC" with the exact label and path you defined.

# Thank you for your time =) 


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


#2 Engenharia de Rede e Segurança (RRAS & NAT):

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

# 6º Resolução de Problemas Avançada (Troubleshooting):

# 6.1 Falha de Kerberos por Dessincronização de Tempo e Erro de GPO:
O Incidente: As atualizações de Políticas de Grupo (gpupdate /force) falharam completamente no PC cliente (Zé Manel), impedindo a aplicação do wallpaper corporativo e dos scripts de software.

A Causa Raiz: Foi identificada uma discrepância de tempo significativa entre o Controlador de Domínio e a VM cliente. O Active Directory depende fortemente do protocolo de autenticação Kerberos, que impõe uma tolerância rigorosa de dessincronização de tempo (por defeito, 5 minutos) para evitar ataques de repetição (replay attacks). A dessincronização quebrou a relação de confiança segura, negando ao PC o acesso à pasta SYSVOL.

A Resolução: Foi forçada uma sincronização de tempo na máquina cliente para alinhar estritamente com o Controlador de Domínio (net time \\10.0.2.10 /set /y). Assim que os relógios ficaram perfeitamente sincronizados, a concessão de tickets Kerberos foi restaurada e o comando gpupdate /force foi executado com sucesso.

# 6.2 Aplicação de Definições de Localização (Idioma) em Ambientes Restritos:
O Incidente: O posto de trabalho cliente (PC do Zé Manel) assumiu por defeito o layout de teclado dos EUA (en-US), causando problemas de mapeamento de caracteres para teclados físicos em Português (PT).

A Complicação: O utilizador final não conseguia alterar o layout do teclado manualmente porque uma GPO de segurança rigorosa ("Bloquear Painel de Controlo") já estava aplicada na sua Unidade Organizacional (OU), retirando-lhe o acesso às Definições do Windows.

A Resolução: Em vez de enfraquecer a postura de segurança levantando temporariamente a restrição do Painel de Controlo, foi adotada uma abordagem administrativa centralizada. Foi criado um novo Objeto de Política de Grupo (GPO) chamado Forçar Teclado PT e associado à OU Malucos Do IT. Esta política forçou automaticamente o método de introdução pt-PT para o utilizador no momento do login, resolvendo o problema de localização globalmente sem quebrar o princípio do menor privilégio (principle of least privilege).

# 6.3 Resolução de Caminhos UNC e Mapeamento de Partilhas SMB:
O Incidente: O mapeamento da unidade de rede (Disco Z:) via Preferências de Política de Grupo (GPP) falhou inicialmente ao tentar usar o nome do domínio no caminho UNC (ex: \\helpdesk.local\Partilha Da Empresa CF).

A Causa Raiz: As partilhas de ficheiros SMB padrão estão vinculadas ao servidor anfitrião específico. Embora o Active Directory resolva automaticamente caminhos baseados no domínio para pastas integradas como \SYSVOL ou \NETLOGON, as pastas partilhadas personalizadas requerem Namespaces do Sistema de Ficheiros Distribuído (DFS) para serem acedidas através da raiz do domínio. Sem o DFS configurado, é exigido o nome de anfitrião (hostname) explícito ou o IP do servidor de ficheiros.

A Resolução: A GPO de Mapeamento de Unidades (Drive Maps) foi reconfigurada para usar o caminho UNC Direto correto, apontando para o hostname específico do Controlador de Domínio (\\DC1\Partilha Da Empresa CF). A unidade foi mapeada com sucesso na seguinte atualização de políticas.

6.3.1 Como foi resolvido:
Aceder ao Editor de Políticas de Grupo:
A consola de Gestão de Políticas de Grupo (Group Policy Management) foi aberta no servidor e foi editada a GPO responsável pelas unidades da empresa (associada à OU Malucos Do IT).

6.3.2 Navegar até ao Mapeamento de Unidades:
Dentro do Editor de Gestão de Políticas de Grupo, a navegação seguiu até ao caminho exato de configuração para as preferências do utilizador:
User Configuration > Preferences > Windows Settings > Drive Maps

6.3.3 Corrigir o Caminho UNC (A Correção):
Foram abertas as propriedades do mapeamento da unidade Z: e foi feita a alteração crucial no campo Location (Localização):

Removido o caminho errado: \\helpdesk.local\Partilha Da Empresa CF

Inserido o caminho explícito correto: \\DC1\Partilha Da Empresa CF (apontando diretamente para o hostname do Controlador de Domínio onde a pasta está fisicamente alojada).

6.3.4 Configurar a Experiência do Utilizador:
Nessa mesma janela, garantiu-se que a ligação seria persistente e amigável para o utilizador, configurando:

Action (Ação): Create (Criar)

Reconnect (Voltar a ligar): Marcado (para que sobreviva aos reinícios)

Label as (Etiqueta): Dados Administrativos CF Empresa

Drive Letter (Letra da Unidade): Z

6.3.5 Atualização do Lado do Cliente:
Por fim, no PC do Zé Manel, o sistema obteve a nova política (através de um reinício, novo login ou gpupdate /force). O disco Z: apareceu com sucesso em "Este PC" (This PC) com a etiqueta e o caminho exatos que foram definidos.

# Obrigado Pelo o seu tempo
