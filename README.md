# Desafio Terraform Azure

Este projeto cria uma máquina virtual na Azure, instala Docker e sobe um container WordPress usando Terraform.

## Pré-requisitos

Antes de começar, você precisará ter o seguinte instalado em sua máquina local:

1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) - Ferramenta de infraestrutura como código.
2. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - Interface de linha de comando para gerenciar os recursos da Azure.
3. Uma conta no [GitHub](https://github.com/join).

## Passos para Executar

### 1. Clone este Repositório

Primeiro, clone o repositório para o seu ambiente local:

```bash
git clone https://github.com/seu-usuario/desafio-terraform-azure.git
cd desafio-terraform-azure

2. Configure o Terraform
Inicialize o Terraform no diretório do projeto:

bash
Copiar código
terraform init
3. Autentique-se na Azure
Autentique-se na Azure usando a Azure CLI:


az login
4. Defina as Variáveis Necessárias
Você precisará definir algumas variáveis antes de aplicar a configuração. Você pode fazer isso criando um arquivo terraform.tfvars no diretório do projeto ou definindo as variáveis no terminal.

Exemplo de terraform.tfvars:

locat = "West Europe"
rg = "rg-desafio-iac"
vnet = "vnet-desafio-iac"
vm = "vm-desafio-iac"

Definir variáveis no terminal:

export TF_VAR_locat="West Europe"
export TF_VAR_rg="rg-desafio-iac"
export TF_VAR_vnet="vnet-desafio-iac"
export TF_VAR_vm="vm-desafio-iac"
5. Aplique a Configuração
Aplique a configuração Terraform para provisionar a infraestrutura:

terraform apply

6. Verifique a Configuração
Após a conclusão do terraform apply, você verá a saída com o IP público da máquina virtual. Use esse IP para verificar se o container WordPress está em execução.

Estrutura do Projeto
Este projeto é composto pelos seguintes arquivos:

main.tf: Arquivo principal do Terraform que define os recursos da Azure.
variables.tf: Define as variáveis usadas no projeto.
outputs.tf: Define as saídas do projeto.
install_docker.sh: Script para instalar Docker e subir o container WordPress.



### Dicas para Pessoas Sem Experiência

1. **Instalar Ferramentas**: Certifique-se de seguir os links fornecidos para instalar o Terraform e a Azure CLI corretamente.
2. **Azure CLI**: A Azure CLI é necessária para autenticar e gerenciar os recursos na Azure. Se você encontrar problemas, consulte a [documentação oficial](https://docs.microsoft.com/en-us/cli/azure/).
3. **Variáveis**: As variáveis são usadas para tornar seu código mais flexível e reutilizável. Você pode definir valores padrão ou sobrescrevê-los conforme necessário.
4. **Comandos Terraform**:
   - `terraform init`: Inicializa um diretório contendo arquivos de configuração Terraform.
   - `terraform apply`: Aplica as mudanças necessárias para alcançar o estado desejado da configuração.
   - `terraform plan`: Gera um plano de execução, mostrando as mudanças que serão feitas.

Seguindo essas instruções, qualquer pessoa, mesmo sem experiência prévia, deve ser capaz de configurar e executar o script Terraform para provisionar a infraestrutura necessária na Azure.
