@description('Nombre del entorno (lab, dev o prod)')
@allowed(['lab', 'dev', 'prod'])
param environmentName string = 'lab'

@description('Región de Azure para todos los recursos')
param location string = resourceGroup().location

@description('SKU de la Storage Account')
@allowed(['Standard_LRS', 'Standard_GRS', 'Standard_ZRS'])
param storageAccountSku string = 'Standard_LRS'

@description('Sufijo único para evitar conflictos de nombres (ej. nombre-del-alumno)')
param uniqueSuffix string

var storageAccountName = toLower('st${uniqueSuffix}${uniqueString(resourceGroup().id)}')
var keyVaultName = 'kv-${uniqueSuffix}-${environmentName}'

var tags = {
  Environment: environmentName
  Proyecto: 'NativeIaC'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    accessTier: 'Hot'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
}

output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
