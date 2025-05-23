using 'main.bicep'

param vmType = 'Linux'
param location = 'germanywestcentral'
param vmName = ''
param targetResourceGroup = ''
param zone = '1'
param subnetId = ''
param adminUsername = '0'
param adminPassword = ''

param diskSizes = [128, 128]
param storageAccountType = 'Premium_LRS'
param caching = 'ReadWrite'
