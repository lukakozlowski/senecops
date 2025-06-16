# senecops - if not exists and it is a first run and only storage account for .tfstate doesn't exist
1. in your terminal type a az cli command to login to azure: (replace upparcase words by proper values)
`az login --service-principal --username "APP_ID" --password "CLIENT_SECRET" --tenant "TENANT_ID"`
2. create resource group by a below command, where we will create in next step a storage account to keep tfstate files.
`az group create --name "rg-iaac" --location "westeurope"`
3. create a storage account for tfstate by below command:
`az storage account create --resource-group "rg-iaac" --name "stiaacsenops" --sku Standard_LRS --encryption-services blob`
4. create container in storage account where we will collect tfstate files:
`az storage container create --name "terraform" --account-name "stiaacsenops"`
5. adjust file: dev.tfbackend under path: terraform/infrastructure/backend/ with above values

