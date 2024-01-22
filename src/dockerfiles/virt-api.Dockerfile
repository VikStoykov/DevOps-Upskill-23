FROM docker.io/vikstoykov/virt-api:vs0.2-v0.59.0

COPY ./kubevirt/_out/cmd/virt-api/virt-api /usr/bin/virt-api
