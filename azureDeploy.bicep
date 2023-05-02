//Parameters
param resourceGroupName string
param location string
param identityName string
param computeGalleryName string
param imageDefinitionName string
param imageTemplateName string
param sourceImagePublisher string
param sourceImageOffer string
param sourceImageSku string
param sourceImageVersion string
param vmSize string
param diskSize int
param OptimizeOsScriptURI string
param installappszipURI string
param installcoreappsexeURI string
param scriptmsiURI string
//param removebloatwareURI string


var contributor = resourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
var storageBlobReader = resourceId('Microsoft.Authorization/roleDefinitions','2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
//var KeyVaultReader = resourceId('Microsoft.Authorization/roleDefinitions','4633458b-17de-408a-b874-0445c86b69e6')

// Define target scope
targetScope = 'subscription'

//Get existing resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' existing = {
  name: resourceGroupName
}

//Create user assigned managed identity
module identity './modules/identity.bicep' = {
  name: 'identityDeployment'
  scope: rg    
  params: {
    identityName: identityName
    location: location
  }
}

//Assign Contributor Role to the user assigned managed identity
module contibutorRole './modules/rbacnew.bicep' = {
 name: 'contibutorRoleDeployment'
 scope: rg    
 params: {
    principalId: identity.outputs.principalId
    roleDefinitionId: contributor
  }
  dependsOn: [
    identity
 ]
}

//Assign Storage Blob Reader to the user assigned managed identity
module StorageRole './modules/rbacnew.bicep' = {
 name: 'StorageRoleDeployment'
 scope: rg  
 params: {
    principalId: identity.outputs.principalId
    roleDefinitionId: storageBlobReader
  }
  dependsOn: [
    identity
 ]
}

//Create Azure Compute Gallery
module acg './modules/computeGallery.bicep' = {
  name: 'acgDeployment'
  scope: rg    
  params: {
    computeGalleryName: computeGalleryName
    location: location
  }
}

//Create image defination
module imagedef './modules/imageDefinition.bicep' = {
  name: 'imagedefDeployment'
  scope: rg   
  params: {
    computeGalleryName: computeGalleryName
    imageDefinitionName: imageDefinitionName
    location: location
  }
  dependsOn: [
    acg
  ]
}

//Create image template
module imageTemplate './modules/imageTemplate.bicep' = {
  name: 'imageTemplateDeployment'
  scope: rg   
  params: {
    imageTemplateName: imageTemplateName
    imageDefinitionName: imageDefinitionName
    sourceImagePublisher: sourceImagePublisher
    sourceImageOffer: sourceImageOffer
    sourceImageSku: sourceImageSku
    sourceImageVersion: sourceImageVersion
    identityName: identityName
    computeGalleryName: computeGalleryName
    vmSize: vmSize
    diskSize: diskSize
    location: location
    OptimizeOsScriptURI: OptimizeOsScriptURI
    installappszipURI: installappszipURI
    installcoreappsexeURI: installcoreappsexeURI
    scriptmsiURI: scriptmsiURI
    //removebloatwareURI: removebloatwareURI 
  }
  dependsOn: [
    imagedef
    StorageRole
  ]
}
