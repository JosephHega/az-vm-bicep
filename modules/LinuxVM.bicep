param location string
param subnetId string
param vmName string
param diskSizes array
param storageAccountType string = 'Premium_LRS'
param caching string = 'Readwrite'

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

resource nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    enableAcceleratedNetworking: true

    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource dataDisks 'Microsoft.Compute/disks@2022-07-02' = [for (size, i) in diskSizes: {
  name: '${vmName}-datadisk-${i}'
  location: location
  zones: [ zone ]
  sku: {
    name: storageAccountType
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: size
  }
}]

var diskNames = [for (size, i) in diskSizes: '${vmName}-datadisk-${i}']

var attachedDataDisks = [for (name, i) in diskNames: {
  lun: i
  createOption: 'Attach'
  managedDisk: {
    id: resourceId('Microsoft.Compute/disks', name)
  }
  caching: caching
}]

resource linuxVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
  zones: [ zone ]
  dependsOn: [
    dataDisks
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'RedHat'
        offer: 'RHEL'
        sku: '8-lvm-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: attachedDataDisks
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    securityProfile: {
      securityType: 'TrustedLaunch'
      encryptionAtHost: true
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
  }
}
