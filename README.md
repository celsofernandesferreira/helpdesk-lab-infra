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
