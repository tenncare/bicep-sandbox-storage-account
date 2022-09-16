#
# Script to delete the Resource Group for the SFTP Storage Account configured for SFTP
#

# Delete Resource Group
Delete-AzResourceGroup -Name "SftpStorage"
