# Before you begin you need to have K8s cluster and the kubectl command-line tool congfigured to communicate with your cluster. 

# Each node in the cluster must have a least 300 MiB of memory.

# metrics-server must be enabled for a few of the steps

# check if metrics API is available via `kubectl get apiservices` with output containing `metrics.k8s.io`

# Create a namespace so that the resources you create in this exkubectl create namespace mem-example
microk8s.kubectl create namespace mem-example

if [ $(microk8s.kubectl get namespace mem-example | wc -l) -eq 2 ]; then
    echo "Nice work, you did it!";
    SUCCESS=True;
else
    echo "Failure";
fi
