#
# Script to create SSH Keys for Local Users associated with a Storage Account configured for SFTP
#

# Deploy Resources
New-AzResourceGroup -Name "SftpStorage" `
                    -Location "Central US"

New-AzResourceGroupDeployment -Name "SftpSshKeysDeployment" `
                              -ResourceGroupName "SftpStorage" `
                              -TemplateFile sftp-ssh-keys.bicep `
                              -TemplateParameterFile sftp-ssh-keys.parameters.json

# Confirm Resources
Get-AzResourceGroupDeployment -Name "SftpSshKeysDeployment" `
                              -ResourceGroupName "SftpStorage"

Get-AzSshKey - ResourceGroupName "SftpStorage"
