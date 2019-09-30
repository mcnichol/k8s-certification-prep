KUBECTL_CMD=""

if [ "$(uname)" == "Darwin" ]; then
  echo "Using Mac; assuming minikube and using native kubectl";
  KUBECTL_CMD="kubectl"
else
  echo "$(uname)"
  echo "Using Linux; assuming microk8s and using microk8s.kubectl";
  KUBECTL_CMD="microk8s.kubectl"
fi

# Before you begin you need to have K8s cluster and the kubectl command-line tool congfigured to communicate with your cluster.

# Each node in the cluster must have a least 300 MiB of memory.

# metrics-server must be enabled for a few of the steps

# check if metrics API is available via `kubectl get apiservices` with output containing `metrics.k8s.io`

# Create a namespace so that the resources you create in this exkubectl create namespace mem-example
# microk8s.kubectl create namespace mem-example

SUCCESS=false;
while ! $SUCCESS; do
  if [ $($KUBECTL_CMD get namespace mem-example | wc -l) -eq 2 ]; then
    echo "Nice work, you did it!";
    SUCCESS=true;
  else
    echo "Failure";
    sleep 5s;
  fi
done
