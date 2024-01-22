FROM docker.io/vikstoykov/virt-controller:vs0.2-v0.59.0

COPY ./kubevirt/_out/cmd/virt-controller/virt-controller /usr/bin/virt-controller