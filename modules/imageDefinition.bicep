param imageDefinitionName string
param location string
param computeGalleryName string

resource acg 'Microsoft.Compute/galleries@2022-03-03' existing = {
  name: computeGalleryName
}

resource imageDefinition 'Microsoft.Compute/galleries/images@2022-03-03' = {
  name: imageDefinitionName
  location: location
  parent: acg
  properties: {
    architecture: 'x64'
    hyperVGeneration: 'V1'
    identifier: {
      offer: 'Windows'
      publisher: 'myCo'
      sku: '10avd'
    }
    osState: 'Generalized'
    osType: 'Windows'
    privacyStatementUri: 'string'
  }
}
