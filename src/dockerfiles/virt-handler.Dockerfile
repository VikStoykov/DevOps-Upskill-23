FROM quay.io/kubevirt/virt-handler:v0.59.0

COPY ./kubevirt/_out/cmd/virt-handler/virt-handler /usr/bin/virt-handler
