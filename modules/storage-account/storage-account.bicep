@description('Storage Account Prefix')
@minLength(3)
@maxLength(11)
param storageAccountPrefix string = 'sftp'

@description('Storage Account SKU')
@allowed([
  'Standard_LRS'
  'Standard_ZRS'
])
param storageAccountSKU string = 'Standard_ZRS'

// Only allowing US Regions that support multiple zones
@description('Region')
@allowed([
  'centralus'
  'eastus'
  'eastus2'
  'westus2'
  'westus3'
])
param location string = resourceGroup().location

@description('Username of primary user')
param userName string = 'administrator'

@description('Home directory of primary user. Should be a container.')
param homeDirectory string = 'administrator'

@description('SSH Public Key for primary user. If not specified, Azure will generate a password which can be accessed securely')
param publicKey string = ''

var storageAccountName = '${storageAccountPrefix}${uniqueString(resourceGroup().id)}'

resource sa 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSKU
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    isLocalUserEnabled: true
    isSftpEnabled: true
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${sa.name}/default/${homeDirectory}'
  properties: {
    publicAccess: 'None'
  }

}

resource user 'Microsoft.Storage/storageAccounts/localUsers@2021-04-01' = {
  parent: sa
  name: userName
  properties: {
    permissionScopes: [
      {
        permissions: 'rcwdl'
        service: 'blob'
        resourceName: homeDirectory
      }
    ]
    homeDirectory: homeDirectory
    sshAuthorizedKeys: empty(publicKey) ? null : [
      {
        description: '${userName} public key'
        key: publicKey
      }
    ]
    hasSharedKey: false
  }
}
