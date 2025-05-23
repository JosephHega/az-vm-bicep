using 'main.bicep'

param vmType = 'Windows'
param location = 'germanywestcentral'
param vmName = 'aw0007'
param targetResourceGroup = 'vm-clone'
param zone = '1'
param subnetId = '/subscriptions/fb4e727e-f4b0-42b0-8950-8a4961a2bce9/resourceGroups/prod-rg/providers/Microsoft.Network/virtualNetworks/vnet-germanywestcentral/subnets/snet-germanywestcentral-1'
param adminUsername = 'skfadmin'
param adminPassword = ''

param diskSizes = [128, 128]
param storageAccountType = 'Premium_LRS'
param caching = 'ReadWrite'
