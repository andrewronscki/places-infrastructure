#  Places Infrastructure

##  Rodando o projeto

###  Pré-requisitos

- Terraform
- AWS CLI

###  Primeiros passos

Abra o arquivo `variables.tf` e faça as mudanças necessárias.

Abra o terminal no diretório do projeto

- Dê início ao Terraform: `terraform init`

### Comandos úteis:

- `terraform plan`: Faz o planejamento das mudanças da infra, ele mostra o que vai ser alterado/adicionado na AWS.
- `terraform fmt -recursive`: Irá formatar os arquivos que estão desformatados, deixando os arquivos padronizados.
- `terraform apply`: Irá rodar o planejamento e perguntar se você quer subir as alterações. Podemos utilizar o comando `terraform apply -auto-approve` para subir automaticamente (Não é recomendado).
- `terraform destroy`: Irá rodar o planejamento e perguntar se você quer destruir sua infra. Podemos utilizar o comando `terraform destroy -auto-approve` para destruir automaticamente (Não é recomendado).

Para aplicar qualquer mudanças na infra acesse a documentação:
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
