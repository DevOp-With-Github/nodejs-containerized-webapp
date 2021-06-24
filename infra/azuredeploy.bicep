param envprefix string
param name string = '${envprefix}tic-tac-toe'
param location string = resourceGroup().location

param acrServerURL string = ' https://docker.pkg.github.com'
param dockerUsername string
param dockerUserPassword string


var websiteName = name

resource site 'microsoft.web/sites@2020-06-01' = {
  name: websiteName
  location: location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: acrServerURL
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: dockerUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: dockerUserPassword
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|nginx'
    }
    serverFarmId: farm.id
  }
}

var farmName = '${envprefix}-actions-ttt-deployment'

resource farm 'microsoft.web/serverFarms@2020-06-01' = {
  name: farmName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    targetWorkerSizeId: 0
    targetWorkerCount: 1
    reserved: true
  }
}

output publicUrl string = site.properties.defaultHostName
output ftpUser string = any(site.properties).ftpUsername // TODO: workaround for missing property definition
