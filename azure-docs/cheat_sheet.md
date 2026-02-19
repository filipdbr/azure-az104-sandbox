# Azure CLI commands

## Authentication
Log in to your Azure account via the default web browser:
`az login`

Log in using a specific username/password (less common, usually for service accounts):
`az login -u <username> -p <password>`

Log out of the current session:
`az logout`

### Subscription Management
List all subscriptions associated with your account in a clean table:
`az account list --output table`

Set a specific subscription as the active one (essential for Terraform):
`az account set --subscription "Subscription-Name-or-ID"`

Show the details of the currently active subscription:
`az account show`

### Account Details
Show information about the currently signed-in user:
`az ad signed-in-user show`

Check the current CLI version and installed extensions:
`az version`

## Azure Regions & Deployment Availability

### Region Selection & Identification
List all regions to find the technical `name` (use this value in your Terraform `location` variable):
`az account list-locations --query "[].{RegionName:name, FullName:displayName}" --output table`

Filter specifically for European data centers:
`az account list-locations --query "[?contains(displayName, 'Europe')].{RegionName:name, FullName:displayName}" --output table`

### Deployment & Availability Check
Check which regions support **Availability Zones** (crucial for High Availability setups in Terraform):
`az account list-locations --query "[?metadata.availabilityZoneMappings != null].{RegionName:name, Zones:metadata.availabilityZoneMappings[].logicalZone}" --output table`

Verify if a specific resource provider (e.g., Virtual Machines, SQL) is available in your chosen region:
`az provider show --namespace Microsoft.Compute --query "resourceTypes[?resourceType=='virtualMachines'].locations" --output json`

### Current Environment Context
Show the default location currently set in your CLI configuration:
`az configure --list-defaults`

Set a default location for your CLI session (does not affect Terraform, but saves time in CLI):
`az configure --defaults location=westeurope`