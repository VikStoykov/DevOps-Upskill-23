FROM docker.io/vikstoykov/virt-launcher:vs0.2-v0.59.0

COPY ./kubevirt/_out/cmd/virt-launcher/virt-launcher /usr/bin/virt-launcher