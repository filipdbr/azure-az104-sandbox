# azure-az104-sandbox
A ready-to-deploy lab environment designed to help you ace the AZ-104 certification exam.

## Why this project?
I built this infrastructure while preparing for **AZ-104** and learning **Terraform**, mainly to have a place to practice. Now I’m sharing it with the community.

This environment is a sandbox to run exercises, test configurations, and get comfortable with Azure administration in a hands-on way.

The goal is to practice various scenarius, which is helpfull during AZ-104 exam and in real life while working with Azure.

## Conceputal Diagram

![Conceptual diagram](docs/az_104_conceptual_diagram.png "Conceptual diagram")

## Tech Stack
* **Cloud:** Microsoft Azure
* **IaC:** Terraform
* **CLI:** Azure CLI & GitHub CLI

## Prerequisites

### 1. Azure Account
You’ll need an active Azure subscription to follow along. 
* **If you're a student:** Use the [Azure for Students](https://azure.microsoft.com/free/students/) offer. You get $100 in credits and some free services without even needing a credit card.
* **Otherwise:** Grab a [Free Trial account](https://azure.microsoft.com/free/) with $200 credit.

### 2. Terraform
You’ll also need the Terraform CLI to deploy the infrastructure. You can find the official, step-by-step installation guide for your OS here:

**Installation Guide:** [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Once installed, verify it by running:
`terraform -version` in CLI.

## Project Infrastructure

### Project Strategy
As I am based in Poland, the primary application infrastructure is hosted in the **Poland Central** region to ensure low latency and data residency compliance. The environment is designed using a modular approach, allowing for high availability through Availability Zones and secure connectivity.

You can easily change the deployment region in [variables](variables.tf) by changing location default value.

### Key Features
* **Networking:** Multi-subnet VNet architecture with restricted access.
* **Security:** Implementation of Azure Bastion, NSGs, and User-Defined Routes (UDR).
* **Compute:** High-availability VM deployments (VMSS and Availability Zones) with Load Balancers.
* **Governance:** Resource Locks and Tagging standards.

## Project Organization

### Directory Structure
The repository is organized into reusable modules.

### todo: continue