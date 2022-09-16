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

@description('Company Name')
@minLength(3)
@maxLength(11)
param companyName string = 'TennCare'

@description('Administrator Username')
param administratorUserName string = 'administrator'

@description('Contributor Username')
param contributorUserName string = 'contributor'

@description('Reader Username')
param readerUserName string = 'reader'

@description('Default Container. Must be a valid container name. This container will be created, and will be the home directory for all users.')
param defaultContainer string = 'default'

var administratorKeyName = toLower('${companyName}_${administratorUserName}')

var contributorKeyName = toLower('${companyName}_${contributorUserName}')

var readerKeyName = toLower('${companyName}_${readerUserName}')

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

resource administratorKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' existing = {
  name: administratorKeyName
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
        key: administratorKey.properties.publicKey
      }
    ]
    hasSharedKey: false
  }
}

resource contributorKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' existing = {
  name: contributorKeyName
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
        key: contributorKey.properties.publicKey
      }
    ]
    hasSharedKey: false
  }
}

resource readerKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' existing = {
  name: readerKeyName
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
        key: readerKey.properties.publicKey
      }
    ]
    hasSharedKey: false
  }
}
