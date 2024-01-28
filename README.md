# DevOps-Upskill-23

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/VikStoykov/DevOps-Upskill-23">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
  <h3 align="center">Telerik DevOps-Upskill 2023</h3>

  [![Kubevirt build](https://github.com/VikStoykov/DevOps-Upskill-23/actions/workflows/build_and_push_kubevirt.yml/badge.svg)](https://github.com/VikStoykov/DevOps-Upskill-23/actions/workflows/build_and_push_kubevirt.yml)

  <p align="center">
    Public training repository for Telerik DevOps-Upskill program - 2023
    <br />
    <a href="docs/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/VikStoykov/DevOps-Upskill-23/issues">Report Bug</a>
    ·
    <a href="https://github.com/VikStoykov/DevOps-Upskill-23/pulls">Request Feature</a>
    ·
    <a href="https://hub.docker.com/u/vikstoykov">Docker repository</a>
  </p>
  
</div>

<!-- ABOUT THE PROJECT -->
## About The Project

This is my main repository for 'Telerik DevOps-Upskill program 2023'.

Banches:
* main
* terraform - Terraform IaC
* kubevirt-cpu-pinning - Feature for Kubevirt cpu pinning
* config-management - Ansible playbooks for building of custom AMI
* build-it - GitHub Workflow


See the [closed pull requests](https://github.com/VikStoykov/DevOps-Upskill-23/pulls?q=is%3Apr+is%3Aclosed) for a full list of  added features.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Used tools

Here you can find all tools and languages that are used in this project.

* Docker
* Ansible
* GitHub Workflows
* Terraform
* Slack
* Kubernetes
* Go/Bash/Python

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

If you want to run one of examples in 'homeworks', go to 'homeworks' directory and read instructions.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
  ```sh
  sudo apt-get update
  sudo apt-get install docker.io
  sudo apt install software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible
  ```
  Terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Installation and usage

1. [Build custom AMI](docs/build_aws_ami.md)
2. [Start AWS Cluster with Terraform](docs/start_aws_cluster_terraform.md)
3. [ChatOps configuration](docs/chat_ops.md)
4. [Jenkins configuration](docs/jenkins.md)
5. [CPU Pinning patch](docs/cpu_pinning_feature.md)

_For more examples, please refer to the [Documentation](./docs)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [x] Idea for the project
  _CI/CD pipeline for own Kubevirt features_
  - [X] _Phases of SDLC_
  - [x] _Value stream mapping_
  - [x] _Documentation_
  - [X] _Choose source control- GitHub_
  - [X] _Branching strategies_
- [x] Choosed building tools
  - _GoLang;_
  - _GitHub Actions;_
  - _Ansible;_
  - _Docker/DockerHub for sharing container images;_
  - _Snyk and Sonar for source code security source code testing._
- [x] Choosed languages and tools
  - _GoLang_ 
- [ ] Secrets management
  - [x] Ansible vault
  - [ ] HashiCorp vault
- [x] Security
  - [x] Sonarcloud
  - [x] Snyk
  - [x] Linters
  - [x] Gitleaks
- [x] ChatOps
  - [x] AWS Lambda
  - [x] AWS CloudWatch
  - [x] Slack
- [x] Create, build and test
  - [x] Build AWS custom AMI (_part of 'Configuration management'_)
  - [x] Create _patches for Kubevirt_
  - [x] Build _with GitHub Actions (Building Pipelines) and publish to DockerHub_
  - [x] Test _on AWS with Terraform_
- [x] Run on Kubernetes cluster with Jenkins
  - [x] AWS Custom AMI and EC2 instances
  - [x] Cluster with 2 or more workers
- [ ] Observability
  - [ ] Prometheus statistics
- [x] Test the project with one step
  - [x] Send notification to Slack
- [x] Documentation 

See the [open issues](https://github.com/VikStoykov/DevOps-Upskill-23/issues?q=is%3Aopen+is%3Aissue) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ROADMAP -->
## High-level design

In our infrastructure setup, we rely on three pivotal Terraform modules, each fulfilling a vital role in orchestrating the deployment and oversight of our resources:

__Main Init Module__
Acting as the keystone of our cluster initialization process, this module oversees the provisioning of two EC2 instances within the AWS environment. Leveraging cloud-init scripts, it meticulously tailors their configurations to meet our precise specifications. These instances serve as the bedrock upon which our entire infrastructure is constructed, furnishing the requisite compute resources for our workloads.

__Kubernetes Templates Module__
This module shoulders the responsibility for deploying and configuring essential Kubernetes resources in our environment. It encompasses the deployment of kubevirt, an extension for Kubernetes dedicated to managing virtual machines, and the Kubernetes dashboard, offering a centralized interface for monitoring and administering our Kubernetes clusters. Through the automated deployment of these resources via templated configurations, we ensure uniformity and dependability across our Kubernetes infrastructure.

__ChatOps Module__
Our ChatOps module embodies an inventive strategy to boost operational efficiency by seamlessly integrating with Slack. This module not only provisions a CloudWatch instance for monitoring our infrastructure but also establishes a bidirectional communication channel between CloudWatch and our Slack server. This integration empowers us with automated notifications, alerts, and interactive commands within our Slack workspace, facilitating real-time insights and actions to streamline collaboration and decision-making processes.

Moreover, it's worth mentioning that we utilize Jenkins for nightly builds. Through the orchestrated execution of these Terraform modules, combined with Jenkins' capabilities, we realize a comprehensive and automated infrastructure setup that lays the groundwork for efficient, dependable, and collaborative operations within our environment. From the initial resource provisioning to continuous management and communication, Terraform and Jenkins serve as indispensable tools for safeguarding the resilience and adaptability of our infrastructure.

In addition to the Terraform modules outlined above, we have the capability to further customize their AWS environment by building custom Amazon Machine Images (AMIs) using Ansible. This approach allows for the creation of tailored images that encapsulate specific configurations and software setups required for their applications.

With Ansible, we can define the desired state of their infrastructure through playbooks, which specify the tasks and configurations to be applied to the instances. By leveraging Ansible's declarative nature, we can ensure consistency and repeatability in the AMI creation process, facilitating seamless deployment and scaling of their applications.

### VSM

![Alt text](/homeworks/lecture2-SDLC/vsm_viktor_stoykov.jpg)

### SDLC

![Alt text](/images/diagrams-SDLC.png)


### Flow

![Alt text](/images/flow.png)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Viktor Stoykov

Project Link: [https://github.com/VikStoykov/DevOps-Upskill-23](https://github.com/VikStoykov/DevOps-Upskill-23)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[Docker.com]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Docker-url]: https://docker.com/
