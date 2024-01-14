FROM quay.io/kubevirt/virt-controller:v0.59.0

COPY ./kubevirt/_out/cmd/virt-controller/virt-controller /usr/bin/virt-controller