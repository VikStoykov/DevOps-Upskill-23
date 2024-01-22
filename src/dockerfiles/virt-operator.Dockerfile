FROM docker.io/vikstoykov/virt-operator:vs0.2-v0.59.0

COPY ./kubevirt/_out/cmd/virt-operator/virt-operator /usr/bin/virt-operator