FROM quay.io/kubevirt/virt-operator:v0.59.0

COPY ./kubevirt/_out/cmd/virt-operator/virt-operator /usr/bin/virt-operator