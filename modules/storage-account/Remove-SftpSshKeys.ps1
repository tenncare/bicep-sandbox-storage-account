#
# Script to delete only the SSH Keys from the Storage Account configured for SFTP
#

# Delete SSH Keys
Remove-AzSshKey -Name "tenncare_administrator" `
                -ResourceGroupName "SftpStorage"
Remove-AzSshKey -Name "tenncare_contributor" `
                -ResourceGroupName "SftpStorage"
Remove-AzSshKey -Name "tenncare_reader" `
                -ResourceGroupName "SftpStorage"
