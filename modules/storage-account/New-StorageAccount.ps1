#
# Script to create a Storage Account configured for SFTP
#

# Deploy Resources
New-AzResourceGroup -Name "Storage" `
                    -Location "Central US"

New-AzResourceGroupDeployment -Name "StorageAccountDeployment" `
                             -Location "Central US" `
                             -TemplateFile storage-account.bicep `
                             -TemplateParameterFile storage-account.parameters.json

# Confirm Resources
Get-AzResourceGroupDeployment -Name "StorageAccountDeployment" `
                              -ResourceGroupName "Storage"
