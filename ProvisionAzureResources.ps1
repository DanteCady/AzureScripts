#### Author: Dante Cady
#### Title: Azure Environment Build
#### Purpose: This script will provision Azure resources including resource groups and services
#### Date: 6/18/2023

#### Variables
$resourceGroupName = "Resource Group Name"
$resourceName = "ResourceName"
$resourceType = "ResourceType"
$location = "Location"
$nsgName = "Network Secuirty Group Name"
$vnetName = "Virtual Network Name"
$vmName= "Virtual Machine Name"
$addressprefix = "VNet Address range"
$vmImage = "Virtual Machine Image"
$appServicePlan = "App Service Plan"
# Optional
$tags = @{"Key1"="Value1"; "Key2"="Value2"} 

####Authenticate to Azure
$Authentication = Connect-AzAccount

if ($Authentication -eq $null) {
    Write-Host "Cannot authenticate Azure account"
} else {
    Write-Host "Account authenticated"
}


#### Identify if Resource Group is available, if not provision Resource Group
$existingResourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if ($existingResourceGroup -eq $null) {
    Write-Host "Resource Group does not exist. Creating..."

    # Create the resource group
    New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tags
} else {
    Write-Host "Resource GSroup already exists."
}

#### Provision Azure services #####

#### Network Security Group
#### Identify if Network Secuirty Group is available, if not provision Resource Group
$existingNetworkSecurityGroup = New-AzNetworkSecurityGroup -Name $nsgName -Tag $tags
 
if ($existingNetworkSecurityGroup -eq $null) {
    write-host "Network Secuirty Group does not exist. Creating..."

    # Create Network Security Group
   New-AzNetworkSecurityGroup - Name $nsgName -Location $location -ResourceGroupName $existingResourceGroup -Tag $tags
} else {
    Write-Host "Network Security Group already exists."
}
#### Virtual Network (VNet)
$existingVirtualNetwork = New-AzVirtualNetwork -Name $vnetName -Location $location -ResourceGroupName $existingResourceGroup -AddressPrefix  $addressprefix -Tag $tags
if ($existingVirtualNetwork -eq $null) {
    write-host " Virtual Network does not exist. Creating..."
} else {
    write-Host "Virtual Network already exists"
}
#### Azure Virtual Machine
#### Uncomment if a virtual machine needs to be provisioned
$existingVirtualMachine = New-AzVM -Name $vmName -Location $location -ResourceGroupName $existingResourceGroup -Credential (Get-Credential) -Image $vmImage -Tag $tags
if ($existingVirtualMachine -eq $null) {
    write-host " Virtual Machine does not exist. Creating..."
} else {
    write-Host "Virtual Machine already exists"
}

#### Azure App Service
$existingWebApp = New-AzWebApp -Name $vmName -Location $location -ResourceGroupName $existingResourceGroup -AppServicePlan $appServicePlan -Tag $tags
if ($existingVirtualMachine -eq $null) {
    write-host " Web App does not exist. Creating..."
} else {
    write-Host "Web App already exists"
}
#### Uncomment if an app service needs to be provisioned
