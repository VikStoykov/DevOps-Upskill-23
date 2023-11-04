# Homeworks
[![Build and push image to DockerHub for L4 Homework](https://github.com/VikStoykov/DevOps-Upskill-23/actions/workflows/build_and_push_l4.yml/badge.svg)](https://github.com/VikStoykov/DevOps-Upskill-23/actions/workflows/build_and_push_l4.yml)

This is folder with all homeworks. For every homework you can find detailed information how to run it.

## How to run homework
### lecture2-SDLC
Created with draw.io

### lecture3-microservices
Do the Demo content in https://github.com/severel/telerik-devops-course/

### lecture4-devops-programme
Original source code: https://github.com/vutoff/devops-programme
My pull request: https://github.com/vutoff/devops-programme/pull/11

```bash
$ sudo docker build -t test:v0.1 .

...
Successfully built 14fd734fcfc3
Successfully tagged test:v0.1

$ sudo docker images
REPOSITORY                                  TAG                     IMAGE ID       CREATED         SIZE
test                                        v0.1                    14fd734fcfc3   5 minutes ago   476MB
```

#### How to run it on Ubuntu 22.04 LTS
```bash
$ sudo docker build -t test:v0.1 .
2ff974622935c628227b58162eba6445d22cbba9272bd35a4f2dbe4992dd7a6e

$ sudo docker ps -a
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS                       PORTS                                       NAMES
2ff974622935   test:v0.1        "python3 /app/app.py"    4 minutes ago   Up 4 minutes                 0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   nifty_bose

$ netstat -nltp | grep 5000
tcp        0      0 0.0.0.0:5000            0.0.0.0:*               LISTEN      -

$ curl http://127.0.0.1:5000/
Hello, World!
```

### lecture4-containers
#### Requirement
_1. Create an index.html file._<br />
_2. Create a Dockerfile that is based on nginx:1.20-alpine_<br />
_3. Copy the index.html file to the new nginx container_<br />
_4. Create a public image repository in docker hub_<br />
_5. Create a GitHub Actions workflow that builds the container and uploads the image to the repository_

Builder: [![Build and push image to DockerHub for L4 Homework](https://github.com/VikStoykov/DevOps-Upskill-23/actions/workflows/build_and_push_l4.yml/badge.svg)](https://github.com/VikStoykov/DevOps-Upskill-23/actions/workflows/build_and_push_l4.yml)

### M1-3-Ansible
More info in [README.md] in M1-3-Ansible folder(https://github.com/VikStoykov/DevOps-Upskill-23/tree/main/homeworks/M1-3-Ansible)

#### Requirement
Ansible, docker-py, flask (from requirements.txt) and authentication for DockerHub and GitHub via ssh. <br\>You can install requirements with pip install -r <i>requirements.txt</i> or manually for every packet.<br/>Builded image: https://hub.docker.com/r/vikstoykov/python-app/tags

#### How to run it:
ansible-playbook playbook.yaml
```
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [localhost] ********************************************************************************************************************************
TASK [roles/build : Create code directory] ******************************************************************************************************
changed: [localhost]

TASK [roles/build : Get latest app code from GitHub] ********************************************************************************************
changed: [localhost]

TASK [roles/build : Build "vikstoykov/python-app:v0.1" image] ***********************************************************************************
changed: [localhost]

TASK [roles/build : Push "vikstoykov/python-app:v0.1" to docker hub] ****************************************************************************
changed: [localhost]

TASK [roles/build : Run container] **************************************************************************************************************
changed: [localhost]

TASK [roles/build : Test container] *************************************************************************************************************
changed: [localhost]

TASK [roles/build : debug] **********************************************************************************************************************
ok: [localhost] => {
    "command_output.stdout_lines": [
        "Hello, World!"
    ]
}

TASK [roles/build : Remove container] ***********************************************************************************************************
changed: [localhost]

TASK [roles/build : Remove "vikstoykov/python-app:v0.1" image] **********************************************************************************
changed: [localhost]

TASK [roles/build : Delete code directory] ******************************************************************************************************
changed: [localhost]

PLAY RECAP **************************************************************************************************************************************
localhost                  : ok=10   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```