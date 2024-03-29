#!/bin/bash
exec 1> >(exec logger -s -t $(basename $0)) 2>&1
set -o xtrace

KUBEVIRT_OPERATOR_TEMPLATE="/home/ubuntu/kubevirt-operator.yaml"
KUBEVIRT_CR_TEMPLATE="/home/ubuntu/kubevirt-cr.yaml"
KUBEVIRT_CR_TEMPLATE="/home/ubuntu/kubevirt-cr.yaml"
METRIC_SERVER_TEMPLATE="/home/ubuntu/metric_server.yaml"
DASHBOARD_TEMPLATE="/home/ubuntu/dashboard.yaml"
VMI_TEMPLATE="/home/ubuntu/fedora_vmi.yaml"

function wait_for_cluster () {
    while true; do
        if [ ! -f "/home/ubuntu/config/ready" ]; then
            sleep 10
        else
            sleep 30
            kubectl get pods -A > /dev/null 2>&1 
            if [[  $? -eq 0 ]]; then
                break
            fi
        fi
    done

    while true; do
        ids=$(kubectl get pods -A | grep calico | awk '{print $3}')
        if [[  $ids != "" ]] && [[ $ids != *"0/1"* ]]; then
            break
        fi
        sleep 10
    done
}

function install_kubevirt () {
    if [ -f "$KUBEVIRT_OPERATOR_TEMPLATE" ]; then
        kubectl apply -f $KUBEVIRT_OPERATOR_TEMPLATE
        sleep 10
    else
        echo "$KUBEVIRT_OPERATOR_TEMPLATE does not exist."
    fi

    if [ -f "$KUBEVIRT_CR_TEMPLATE" ]; then
        kubectl apply -f $KUBEVIRT_CR_TEMPLATE
        sleep 10
    else
        echo "$KUBEVIRT_CR_TEMPLATE does not exist."
    fi

    while true; do
        ids=$(kubectl get pods -A | grep kubevirt | awk '{print $3}')
        if [[  $ids != *"0/1"* ]]; then
            break
        fi
        sleep 30
    done
}

function install_components () {
    if [ -f "$METRIC_SERVER_TEMPLATE" ]; then
        kubectl apply -f $METRIC_SERVER_TEMPLATE
        sleep 10
    else
        echo "$METRIC_SERVER_TEMPLATE does not exist."
    fi

    if [ -f "$DASHBOARD_TEMPLATE" ]; then
        kubectl apply -f $DASHBOARD_TEMPLATE
        sleep 10
    else
        echo "$DASHBOARD_TEMPLATE does not exist."
    fi
}

function run_vmi () {
    while true; do
        kubectl get nodes | grep k8s-worker-1 > /dev/null 2>&1 
        if [[  $? -eq 0 ]]; then
            break
        fi
        sleep 90
    done

    if [ -f "$VMI_TEMPLATE" ]; then
        kubectl apply -f $VMI_TEMPLATE
    else
        echo "$VMI_TEMPLATE does not exist."
    fi
}

wait_for_cluster
install_kubevirt
#install_components
run_vmi

#curl -X POST --data-urlencode "payload={\"channel\": \"#devops\", \"username\": \"tommy\", \"text\": \"Meow...Meows... Kubevirt VM is deployed successfully.\", \"icon_emoji\": \":smirk_cat:\"}" https://hooks.slack.com/services/XX/YY/ZZ

exit 0
