FROM quay.io/kubevirt/virt-api:v0.59.0

COPY ./kubevirt/_out/cmd/virt-api/virt-api /usr/bin/virt-api
