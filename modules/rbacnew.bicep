param principalId string
param roleDefinitionId string

resource rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {

  name: guid(principalId, roleDefinitionId)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
