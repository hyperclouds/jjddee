param computeGalleryName string
param location string

resource acg 'Microsoft.Compute/galleries@2022-03-03' = {
  name: computeGalleryName
  location: location
  properties: {
    description: 'Azure Compute Gallery'
    identifier: {}
  }
}
