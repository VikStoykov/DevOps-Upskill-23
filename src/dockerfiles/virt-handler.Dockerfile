FROM docker.io/vikstoykov/virt-handler:vs0.2-v0.59.0

COPY ./kubevirt/_out/cmd/virt-handler/virt-handler /usr/bin/virt-handler
