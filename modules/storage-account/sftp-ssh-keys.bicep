@description('Company Name')
@minLength(3)
@maxLength(11)
param companyName string = 'TennCare'

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

@description('Administrator SSH Public Key.')
param administratorPublicKey string = ''

@description('Contributor Username')
param contributorUserName string = 'contributor'

@description('Contributor SSH Public Key.')
param contributorPublicKey string = ''

@description('Reader Username')
param readerUserName string = 'reader'

@description('Reader SSH Public Key.')
param readerPublicKey string = ''

var administratorKeyName = toLower('${companyName}_${administratorUserName}')

var contributorKeyName = toLower('${companyName}_${contributorUserName}')

var readerKeyName = toLower('${companyName}_${readerUserName}')

resource administratorKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: administratorKeyName
  location: location
  tags: {
    Environment: 'Sandbox'
  }
  properties: {
    publicKey: administratorPublicKey
  }
}

resource contributorKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: contributorKeyName
  location: location
  tags: {
    Environment: 'Sandbox'
  }
  properties: {
    publicKey: contributorPublicKey
  }
}

resource readerKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: readerKeyName
  location: location
  tags: {
    Environment: 'Sandbox'
  }
  properties: {
    publicKey: readerPublicKey
  }
}

output administratorKeyNameOutput string = administratorKeyName
output contributorKeyNameOutput string = contributorKeyName
output readerKeyNameOutput string = readerKeyName
