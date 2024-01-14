FROM quay.io/kubevirt/virt-launcher:v0.59.0

COPY ./kubevirt/_out/cmd/virt-launcher/virt-launcher /usr/bin/virt-launcher