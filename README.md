# SenecOps

### BEFORE YOU START
<b>if not exists and it is a first run and only storage account for .tfstate doesn't exist </b>
1. in your terminal type a az cli command to login to azure: (replace upparcase words by proper values)
`az login --service-principal --username "APP_ID" --password "CLIENT_SECRET" --tenant "TENANT_ID"`
2. create resource group by a below command, where we will create in next step a storage account to keep tfstate files.
`az group create --name "rg-iaac" --location "westeurope"`
3. create a storage account for tfstate by below command:
`az storage account create --resource-group "rg-iaac" --name "stiaacsenops" --sku Standard_LRS --encryption-services blob`
4. create container in storage account where we will collect tfstate files:
`az storage container create --name "terraform" --account-name "stiaacsenops"`
5. adjust file: dev.tfbackend under path: terraform/infrastructure/backend/ with above values

### CI/CD:

1. GitHub action as an infrastructure provisioning process
`https://github.com/lukakozlowski/senecops/actions`

### Terraform
To run code locally, adjust terraform.dev.tfvars file with your values.

1. initialize code and providers:
`terraform init -backend-config=backend/dev.tfbackend`

2. Prepare a tfplan:
`terraform plan -var-file=backend/terraform.dev.tfvars`

3. Review plan and run apply:
`terraform apply -var-file=backend/terraform.dev.tfvars`

Code structure:
```text
├── README.md
└── terraform
    ├── infrastructure
    │   ├── backend
    │   │   ├── dev.tfbackend
    │   │   ├── dev.tfbackend.example
    │   │   ├── terraform.dev.tfvars
    │   │   └── terraform.dev.tfvars.example
    │   ├── data.tf
    │   ├── locals.tf
    │   ├── main.tf
    │   ├── provider.tf
    │   └── variables.tf
    ├── manifests
    │   └── cluster_issuer.yaml
    └── modules
        ├── aks
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── mysql
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── psql
        │   ├── main.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── tools
        │   ├── cert_manager.tf
        │   ├── external_dns.tf
        │   ├── ingress.tf
        │   └── variables.tf
        └── wordpress
            ├── main.tf
            ├── outputs.tf
            └── variables.tf
```