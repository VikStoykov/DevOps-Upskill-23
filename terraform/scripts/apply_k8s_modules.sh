#!/bin/bash
set -e
set -x

KUBEVIRT_OPERATOR_TEMPLATE="/home/ubuntu/kubevirt-operator.yaml"
KUBEVIRT_CR_TEMPLATE="/home/ubuntu/kubevirt-cr.yaml"
KUBEVIRT_CR_TEMPLATE="/home/ubuntu/kubevirt-cr.yaml"
METRIC_SERVER_TEMPLATE="/home/ubuntu/metric_server.yaml"
DASHBOARD_TEMPLATE="/home/ubuntu/dashboard.yaml"

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
            echo "1"
            break
        fi
        sleep 10
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


install_kubevirt
install_components
