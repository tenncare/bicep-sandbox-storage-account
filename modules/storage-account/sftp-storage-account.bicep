@description('Storage Account Prefix')
@minLength(3)
@maxLength(11)
param storageAccountPrefix string = 'sftp'

@description('Storage Account Type')
@allowed([
  'Standard_LRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

// Only allowing US Regions that support multiple zones
@description('Region')
//@allowed([
//  'centralus'
//  'eastus'
//  'eastus2'
//  'westus2'
//  'westus3'
//])
param location string = resourceGroup().location // Can't use @allowed with this function as the default!

@description('Administrator Username')
param administratorUserName string = 'administrator'

@description('Administrator SSH Public Key. If not specified, Azure will generate a password which can be accessed securely')
param administratorPublicKey string = ''

@description('Contributor Username')
param contributorUserName string = 'contributor'

@description('Contributor SSH Public Key. If not specified, Azure will generate a password which can be accessed securely')
param contributorPublicKey string = ''

@description('Reader Username')
param readerUserName string = 'reader'

@description('Reader SSH Public Key. If not specified, Azure will generate a password which can be accessed securely')
param readerPublicKey string = ''

@description('Default Container. Must be a container name. This container will be created. Home directory for all users.')
param defaultContainer string = 'default'

var storageAccountName = toLower('${storageAccountPrefix}${uniqueString(resourceGroup().id)}')

resource sa 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    isLocalUserEnabled: true
    isSftpEnabled: true
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${sa.name}/default/${defaultContainer}'
  properties: {
    publicAccess: 'None'
  }
}

resource administratorUser 'Microsoft.Storage/storageAccounts/localUsers@2022-05-01' = {
  parent: sa
  name: administratorUserName
  properties: {
    permissionScopes: [
      {
        permissions: 'rcwdl'
        service: 'blob'
        resourceName: defaultContainer
      }
    ]
    homeDirectory: defaultContainer
    sshAuthorizedKeys: empty(administratorPublicKey) ? null : [
      {
        description: '${administratorUserName} public key'
        key: administratorPublicKey
      }
    ]
    hasSharedKey: false
  }
}

resource contributorUser 'Microsoft.Storage/storageAccounts/localUsers@2022-05-01' = {
  parent: sa
  name: contributorUserName
  properties: {
    permissionScopes: [
      {
        permissions: 'rcwdl'
        service: 'blob'
        resourceName: defaultContainer
      }
    ]
    homeDirectory: defaultContainer
    sshAuthorizedKeys: empty(contributorPublicKey) ? null : [
      {
        description: '${contributorUserName} public key'
        key: contributorPublicKey
      }
    ]
    hasSharedKey: false
  }
}

resource readerUser 'Microsoft.Storage/storageAccounts/localUsers@2022-05-01' = {
  parent: sa
  name: readerUserName
  properties: {
    permissionScopes: [
      {
        permissions: 'rcdl'
        service: 'blob'
        resourceName: defaultContainer
      }
    ]
    homeDirectory: defaultContainer
    sshAuthorizedKeys: empty(readerPublicKey) ? null : [
      {
        description: '${readerUserName} public key'
        key: readerPublicKey
      }
    ]
    hasSharedKey: false
  }
}
