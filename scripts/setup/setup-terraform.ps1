if (az group show --name $(rgterraform)) {
    if (az storage account show --name $(saterraform) --resource-group $(rgterraform)) {
        exit 0
    }
    else {
        az storage account create --name $(saterraform) --resource-group $(rgterraform) --location southeastasia --sku Standard_LRS

        az storage container create --name terraform --account-name $(saterraform)

        az storage account keys list -g $(rgterraform) -n $(saterraform)
    }
}
else {
    az group create --name $(rgterraform) --location southeastasia

    az storage account create --name $(saterraform) --resource-group $(rgterraform) --location southeastasia --sku Standard_LRS

    az storage container create --name terraform --account-name $(saterraform)

    az storage account keys list -g $(rgterraform) -n $(saterraform)
}