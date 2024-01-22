# Implementation

KubeVirt inherently supports CPU pinning for NUMA hardware, but it doesn't provide native support for users to manually perform CPU pinning. However, an extension of this feature exists, enabling users to manually assign virtual CPUs (vCPU) to physical CPUs (pCPU).

To manually set CPU pinning, include the cpuPinning: ["0-2", "1-3"] configuration. In this setting, vCPU 0 is mapped to pCPU 2, and vCPU 1 is mapped to pCPU 3. To clarify, in a scenario with a VM or hardware device having 2 cores and 2 threads per core (resulting in a total of 4 CPUs), core counting starts from zero.

Example:
|Core|Number|
|-|-|
|1|0|
|2|1|
|3|2|
|4|3|

If user want to start VM with 2 cores (2 cores with 1 thread per core) and pin core 0 of VM to core 2 of host and core 1 of VM to core 3 of VM, he need to add in VM template:

```bash
domain:     
  cpu:       
    pinning: ["0-2", "1-3"]
      sockets: 1
      cores: 2
      threads: 1
```

We can then verify that they have been successfully pinned:

`kubectl get pods`

```bash
NAME                                  READY   STATUS            RESTARTS   AGE
virt-launcher-fedora-vm-test4-nrlzs   2/2     Running           0          5s
kubectl exec -it virt-launcher-fedora-vm-test4-nrlzs /bin/sh

sh-4.4# virsh vcpupin 1
 VCPU   CPU Affinity
----------------------
 0      2
 1      3
```

Finally, we have option to test every CPU with stress-ng tool.

Before CPU load:
![Alt text](/images/before_pinning.JPG)

Enter to VM and install stress-ng or another tool:

```bash
kubectl get vmi

NAME              AGE   PHASE     IP           NODENAME                               READY
fedora-vm-test4   18m   Running   10.32.0.12   standardpci440fxpiix1996525400d9e293   True
virtctl console fedora-vm-test4

[root@fedora-vm-test4 fedora]# dnf install stress-ng
[root@fedora-vm-test4 fedora]# dnf install htop
[root@fedora-vm-test4 fedora]# htop
```

 CPU load of VM cores:

And we can start stress test of core 0 of VM:

```bash
[root@fedora-vm-test4 fedora]# stress-ng -c 0 -l 80
stress-ng: info: [9657] defaulting to a 86400 second (1 day, 0.00 secs) run per stressor
stress-ng: info: [9657] dispatching hogs: 2 cpu
```

Now check with htop tool host CPU load:
![Alt text](/images/after_pinning.JPG)

We have checks for:

* Attempting to assign a physical CPU (pCPU) to a non-existent virtual CPU (vCPU).
* Attempting to assign a virtual CPU (vCPU) to a non-existent physical CPU (pCPU). In such cases, users may receive a log message stating: "impossible to pin < N > on host where we have only < N >" (kubectl logs <pod_name> -c compute), and the CPU will be randomly pinned to one of the available pCPUs (0-3 if there are 4 CPUs on the host machine).
* Trying to include additional options for CPU pinning. In this situation, users might encounter a log message like: "impossible to pin < N > on VM where we have only< N >" (kubectl logs <pod_name> -c compute), and the CPU will be randomly pinned to one of the available pCPUs (0-3 if there are 4 CPUs on the host machine).
* Attempting to pin a negative number of vCPUs or pCPUs. Users will receive a log message indicating: "impossible to pin negative number" (kubectl logs <pod_name> -c compute).
* Trying to pin fewer vCPUs than the total requested. For instance, if the intention is to start a VM with 2 CPUs but only one is assigned due to pinning restrictions, the second vCPU will be randomly pinned to an available CPU.

```bash
domain:
    cpu:
      pinning: ["0-2"]
      sockets: 1
      cores: 2
      threads: 1
sh-4.4# virsh vcpupin 1
 VCPU   CPU Affinity
----------------------
 0      2
 1      0-3
 ```
