KUBECTL_CMD=""

clear 

if [ "$(uname)" == "Darwin" ]; then
  echo "Using Mac; assuming minikube and using native kubectl";
  KUBECTL_CMD="kubectl"
else
  echo "Using Linux; assuming microk8s and using microk8s.kubectl";
  KUBECTL_CMD="microk8s.kubectl"
fi

# Before you begin you need to have K8s cluster and the kubectl command-line tool congfigured to communicate with your cluster.

# Each node in the cluster must have a least 300 MiB of memory.

# metrics-server must be enabled for a few of the steps

# check if metrics API is available via `kubectl get apiservices` with output containing `metrics.k8s.io`

echo "In this exercise, you will create a Pod that has one Container. The Container will have a memory request of 100 MiB and a memory limit of 200 MiB.";
echo ""
echo "Create a namespace called mem-example so that resources you create in this Task are isolated"; 
# Answer: microk8s.kubectl create namespace mem-example

SUCCESS=false;
while ! $SUCCESS; do
  if [ $($KUBECTL_CMD get namespaces --field-selector=metadata.name=mem-example -o custom-columns=NAME:.metadata.name --no-headers | wc -l) -eq 1 ]; then
    echo "Great job creating the namespace!";
    SUCCESS=true;
  else
    sleep 5s;
  fi
done

echo "To specify a memory request and a memory limit. include the 'resources:requests' and 'resources:limits' fields in the Container's resource manifest.";
echo ""
echo "Generate the declarative configuration for the Pod with below configuration:"
echo ""
echo "Pod Name: memory-demo"
echo "Image: polinux/stress"
echo "Container Name: memory-demo-ctr"
echo "resources.limits.memory: 200Mi"
echo "resources.requests.memory: 100Mi"
echo "Container start command: stress"
echo "Container args array: --vm, 1, --vm-bytes, 150M, --vm-hang, 1"

# microk8s.kubectl get pods -n mem-example -o go-template --template '{{"\n"}}{{range .items}}{{if eq .metadata.name "memory-demo"}}{{.}}{{end}}{{end}}{{"\n\n"}}'

SUCCESS=false;
while ! $SUCCESS; do
    if [ "$($KUBECTL_CMD get namespaces)" == "DATA" ]; then
      SUCCESS=true;
    else
      sleep 5s;
    fi
done

SUCCESS=false;
while ! $SUCCESS; do
    if [ "$($KUBECTL_CMD get namespaces)" == "DATA" ]; then
      SUCCESS=true;
    else
      sleep 5s;
    fi
done
