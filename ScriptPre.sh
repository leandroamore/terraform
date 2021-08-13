#!/bin/bash
LOCATION=eastus #region de azure donde crear los recursos
STGRG=VUAS_TF #resource group para el storage
STGName=vuasprodterraform  #nombre del storage



#Crear Resource Groups 
az group create -n $STGRG -l $LOCATION

echo "resource groups creados"

#Creo storage account y container para persistencia
az storage account create -n $STGName -g $STGRG -l $LOCATION
echo "storage creado"
az storage container create -n tfstate --account-name $STGName
echo "container creado"
#Asigno la key de acceso al storage
key=$(az storage account keys list -g $STGRG -n $STGName --query [0].value -o tsv)
echo $key
ssh-keygen  -f ~/.ssh/id_rsa_aksprod -q -N ""
#inicializo el backend de terraform para persistencia
#ponerlo en el main 
terraform init -backend-config="storage_account_name=$STGName" -backend-config="container_name=tfstate" -backend-config="access_key=$key" -backend-config="key=Prod.vuas.tfstate"



