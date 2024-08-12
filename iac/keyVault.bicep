param location string = resourceGroup().location
@description('Provide a unique datetime and initials string to make your instances unique. Use only lower case letters and numbers')
@minLength(11)
@maxLength(11)
param uniqueIdentifier string = '20251231acw'

@minLength(10)
@maxLength(13)
param keyVaultName string = 'KV-ProtSec'

@description('Provide the object id of the admin user/group that will have access to the key vault')
param keyVaultAdminObjectId string

var vaultName = '${keyVaultName}-${uniqueIdentifier}'
var skuName = 'standard'
var softDeleteRetentionInDays = 7

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: vaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    sku: {
      name: skuName
      family: 'A'
    }
    accessPolicies: [
      {
        tenantId: tenant().tenantId
        objectId: keyVaultAdminObjectId
        permissions: {
          certificates: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'ManageContacts'
            'ManageIssuers'
            'GetIssuers'
            'ListIssuers'
            'SetIssuers'
            'DeleteIssuers'
            'Purge'
          ]
          keys: [
            'Get'
            'List'
            'Update'
            'Create'
            'Import'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'GetRotationPolicy'
            'SetRotationPolicy'
            'Rotate'
            'Encrypt'
            'Decrypt'
            'UnwrapKey'
            'WrapKey'
            'Verify'
            'Sign'
            'Purge'
            'Release'
          ]
          secrets: [
            'Get'
            'List'
            'Set'
            'Delete'
            'Recover'
            'Backup'
            'Restore'
            'Purge'
          ]
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource KeyVault_Secret_ProtSecAppConfigConnection 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'ProtSecAppConfigConnection'
  properties: {
    contentType: 'string'
    attributes: {
      enabled: true
    }
  }
}

resource KeyVault_Secret_ProtSecDbConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'ProtSecDbConnectionString'
  properties: {
    contentType: 'string'
    attributes: {
      enabled: true
    }
  }
}

resource KeyVault_Secret_ProtSecStorageSASToken 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'ProtSecStorageSASToken'
  properties: {
    contentType: 'string'
    attributes: {
      enabled: true
    }
  }
}
