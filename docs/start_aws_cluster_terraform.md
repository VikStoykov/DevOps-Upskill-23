# Introduction

Terraform is an open-source infrastructure as code (IaC) tool developed by HashiCorp. It allows users to define and provision infrastructure resources using a declarative configuration language. With Terraform, you can manage infrastructure across various cloud providers, on-premises environments, and even third-party services, enabling you to build, change, and version infrastructure efficiently.

Unlike traditional configuration management tools, Terraform focuses on creating and managing infrastructure resources in a predictable and reproducible manner. It provides a unified workflow for provisioning infrastructure, making it easier to manage complex environments and automate infrastructure deployment.

Key features of Terraform include:

1. Declarative Configuration: Terraform uses a declarative configuration language called HashiCorp Configuration Language (HCL) to define infrastructure resources and their dependencies. This allows users to describe the desired state of their infrastructure without specifying the sequence of operations required to achieve it.

2. Infrastructure as Code (IaC): Terraform treats infrastructure as code, enabling infrastructure configurations to be versioned, tested, and managed alongside application code. This makes it easier to collaborate with teams, track changes, and maintain consistency across environments.

3. Multi-Cloud Provisioning: Terraform supports provisioning resources across multiple cloud providers, including AWS, Azure, Google Cloud Platform, and others. This allows users to leverage the best features of each cloud provider and build hybrid or multi-cloud architectures.

4. Resource Graph: Terraform builds a dependency graph of infrastructure resources based on their interdependencies. This allows Terraform to determine the optimal order of provisioning and updating resources, ensuring consistent and predictable deployments.

5. State Management: Terraform maintains a state file that records the current state of the infrastructure managed by Terraform. This state file is used to track changes, plan updates, and ensure that the actual infrastructure matches the desired state defined in the configuration files.

Overall, Terraform simplifies the process of provisioning and managing infrastructure by providing a unified workflow, declarative configuration language, and support for multi-cloud environments. Whether you're managing a small development environment or a large-scale production infrastructure, Terraform helps streamline operations, improve collaboration, and increase agility.

## Implementation

![Alt text](/images/terraform_schematic.png)

In our infrastructure setup, we leverage three distinct Terraform modules, each serving a crucial role in orchestrating the deployment and management of our resources:

__Main Init Module__
This module serves as the cornerstone of our cluster initialization process. It orchestrates the provisioning of two EC2 instances within the AWS environment, utilizing cloud-init scripts to tailor their configurations precisely to our specifications. These instances serve as the foundational elements upon which our entire infrastructure is built, providing the necessary compute resources for our workloads.

__Kubernetes Templates Module__
The Kubernetes Templates module is responsible for the deployment and configuration of Kubernetes resources essential for our environment. This includes the deployment of kubevirt, a Kubernetes extension for managing virtual machines, and the Kubernetes dashboard, providing a centralized interface for monitoring and managing our Kubernetes clusters. By automating the deployment of these resources through templated configurations, we ensure consistency and reliability across our Kubernetes infrastructure.

__ChatOps Module__
Our ChatOps module represents an innovative approach to enhancing operational efficiency through seamless integration with Slack. This module not only provisions a CloudWatch instance for monitoring our infrastructure but also establishes a bi-directional communication channel between CloudWatch and our Slack server. This integration enables automated notifications, alerts, and even interactive commands within our Slack workspace, empowering our team with real-time insights and actions to streamline collaboration and decision-making processes.

Through the orchestration of these Terraform modules, we achieve a comprehensive and automated infrastructure setup that lays the foundation for efficient, reliable, and collaborative operations within our environment. From the initial provisioning of resources to ongoing management and communication, Terraform serves as a powerful tool for ensuring the resilience and agility of our infrastructure.

## How to run

```sudo terraform plan```
```sudo terraform validate```
```sudo terraform apply```

![Alt text](/images/terraform.gif)

Instances:
![Alt text](/images/aws_terraform_instances.png)
