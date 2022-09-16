#
# Script to create a Storage Account configured for SFTP
#

# Deploy Resources
New-AzResourceGroup -Name "SftpStorage" `
                    -Location "Central US"

New-AzResourceGroupDeployment -Name "SftpStorageAccountDeployment" `
                              -ResourceGroupName "SftpStorage" `
                              -TemplateFile sftp-storage-account.bicep `
                              -TemplateParameterFile sftp-storage-account.parameters.json

# Confirm Resources
Get-AzResourceGroupDeployment -Name "SftpStorageAccountDeployment" `
                              -ResourceGroupName "SftpStorage"
