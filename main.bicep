targetScope = 'subscription'

@allowed([
  'Windows'
  'Linux'
])
param vmType string

@allowed([
  '1'
  '2'
  '3'
])
param zone string

@minLength(1)
param adminUsername string

@secure()
param adminPassword string

param location string
param subnetId string
param vmName string
param targetResourceGroup string

param diskSizes array
param storageAccountType string = 'Premium_LRS'
param caching string = 'ReadOnly'

module windowsVm 'modules/WindowsVM.bicep' = if (vmType == 'Windows') {
  name: 'deployWindowsVM'
  scope: resourceGroup(targetResourceGroup)
  params: {
    location: location
    zone: zone
    subnetId: subnetId
    vmName: vmName
    adminUsername: adminUsername
    adminPassword: adminPassword
    diskSizes: diskSizes
    storageAccountType: storageAccountType
    caching: caching
  }
}

module linuxVm 'modules/LinuxVM.bicep' = if (vmType == 'Linux') {
  name: 'deployLinuxVM'
  scope: resourceGroup(targetResourceGroup)
  params: {
    location: location
    zone: zone
    subnetId: subnetId
    vmName: vmName
    adminUsername: adminUsername
    adminPassword: adminPassword
    diskSizes: diskSizes
    storageAccountType: storageAccountType
    caching: caching
  }
}
