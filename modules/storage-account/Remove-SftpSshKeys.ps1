#
# Script to delete only the SSH Keys from the Storage Account configured for SFTP
#

# List SSH Keys
Get-AzSshKey -ResourceGroupName "SftpStorage"

# Delete SSH Keys
Remove-AzSshKey -Name "tenncare_administrator" `
                -ResourceGroupName "SftpStorage"
Remove-AzSshKey -Name "tenncare_contributor" `
                -ResourceGroupName "SftpStorage"
Remove-AzSshKey -Name "tenncare_reader" `
                -ResourceGroupName "SftpStorage"

# List SSH Keys
Get-AzSshKey -ResourceGroupName "SftpStorage"
