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
    sleep 5s;
    SUCCESS=true;
  else
    sleep 5s;
  fi
done
clear

echo "To specify a memory request and a memory limit. include the 'resources:requests' and 'resources:limits' fields in the Container's resource manifest.";
echo ""
echo "Generate the declarative configuration for the Pod with below configuration:"
echo ""
echo "Pod Name: memory-demo"
echo "Namespace: mem-example"
echo "Image: polinux/stress"
echo "Container Name: memory-demo-ctr"
echo "resources.limits.memory: 200Mi"
echo "resources.requests.memory: 100Mi"
echo "Container start command: stress"
echo "Container args array: --vm, 1, --vm-bytes, 150M, --vm-hang, 1"

SUCCESS=false;
while ! $SUCCESS; do
    if [ $($KUBECTL_CMD get pods -n mem-example -o go-template --template '{{"\n"}}{{range .items}}{{if eq .metadata.name "memory-demo"}}{{range .spec.containers}}{{$command := (index .command 0)}}{{$args := .args}}{{if and (eq .image "polinux/stress") (eq .name "memory-demo-ctr") (eq .resources.limits.memory "200Mi") (eq .resources.requests.memory "100Mi") (eq $command "stress")}}{{if and (or (eq (index $args 0) "--vm") (eq (index $args 2) "--vm") (eq (index $args 4) "--vm"))  (or (eq (index $args 1) "1") (eq (index $args 3) "1") (eq (index $args 5) "1")) (or (eq (index $args 0) "--vm-bytes") (eq (index $args 2) "--vm-bytes") (eq (index $args 4) "--vm-bytes")) (or (eq (index $args 1) "150M") (eq (index $args 3) "150M") (eq (index $args 5) "150M")) (or (eq (index $args 0) "--vm-hang") (eq (index $args 2) "--vm-hang") (eq (index $args 4) "--vm-hang"))}}{{.}}{{end}}{{end}}{{end}}{{end}}{{end}}{{"\n\n"}}' | wc | awk '{ print $2 }') -gt 0 ]; then 
      echo "";
      echo "Great job creating the Pod!";
      sleep 5s
      SUCCESS=true;
    else 
      sleep 5s;
    fi
done
clear

echo "You can verify the Pod Container is running by executing: "
echo "    $KUBECTL_CMD get pod memory-demo --namespace=mem-example"
sleep 5s; echo "";

echo "For more detailed information about the Pod:"
echo "    $KUBECTL_CMD get pod memory-demo --output=yaml --namespace=mem-example"
sleep 5s; echo "";

echo "Get metrics for the pod:"
echo "    $KUBECTL_CMD top pod memory-demo --namespace=mem-example"
sleep 5s; echo "";

echo "Delete the pod 'memory-demo' that you just created in the namespace 'mem-example'."

SUCCESS=false;
while ! $SUCCESS; do
    if [[ -z "$($KUBECTL_CMD get pods --field-selector=metadata.name=memory-demo --namespace mem-example -o custom-columns=NAME:.metadata.name --no-headers)" ]]; then 
      echo "";
      echo "Great job deleting the pod!";
      SUCCESS=true;
      sleep 5s;
    else
      sleep 5s;
    fi
done
clear

echo "In this exercise, we will create a Pod that attempts to allocate more memory than its limit."
echo ""
echo "Containers can exceed their memory request if the Node has memory available but a Container cannot use more than its memory limit."
echo ""
echo "If a Container allocates more memory than it's limit, the container becomes a candidate for termincation. If it continues to consume memory beyond its limit, it is terminated. Terminated containers can be restarted. The kubelet would restart it similar to any other type of runtime failure."
echo ""
echo "Generate the declarative configuration for the Pod with below configuration:"
echo ""
echo "Pod Name: memory-demo-2"
echo "Namespace: mem-example"
echo "Image: polinux/stress"
echo "Container Name: memory-demo-2-ctr"
echo "resources.limits.memory: 100Mi"
echo "resources.requests.memory: 50Mi"
echo "Container start command: stress"
echo "Container args array: --vm, 1, --vm-bytes, 4G, --vm-hang, 1"

SUCCESS=false;
while ! $SUCCESS; do
    if [ $($KUBECTL_CMD get pods -n mem-example -o go-template --template '{{"\n"}}{{range .items}}{{if eq .metadata.name "memory-demo-2"}}{{range .spec.containers}}{{$command := (index .command 0)}}{{$args := .args}}{{if and (eq .image "polinux/stress") (eq .name "memory-demo-2-ctr") (eq .resources.limits.memory "100Mi") (eq .resources.requests.memory "50Mi") (eq $command "stress")}}{{if and (or (eq (index $args 0) "--vm") (eq (index $args 2) "--vm") (eq (index $args 4) "--vm"))  (or (eq (index $args 1) "1") (eq (index $args 3) "1") (eq (index $args 5) "1")) (or (eq (index $args 0) "--vm-bytes") (eq (index $args 2) "--vm-bytes") (eq (index $args 4) "--vm-bytes")) (or (eq (index $args 1) "4G") (eq (index $args 3) "4G") (eq (index $args 5) "4G")) (or (eq (index $args 0) "--vm-hang") (eq (index $args 2) "--vm-hang") (eq (index $args 4) "--vm-hang"))}}{{.}}{{end}}{{end}}{{end}}{{end}}{{end}}{{"\n\n"}}' | wc | awk '{ print $2 }') -gt 0 ]; then 
      echo "";
      echo "Great job creating the Pod!";
      sleep 5s
      SUCCESS=true;
    else 
      sleep 5s;
    fi
done
clear

echo "You can verify the Pod Container is running by executing: "
echo "    $KUBECTL_CMD get pod memory-demo-2 --namespace=mem-example"
sleep 5s; echo "";

echo "For more detailed information about the Pod:"
echo "    $KUBECTL_CMD get pod memory-demo-2 --output=yaml --namespace=mem-example"
sleep 5s; echo "";

echo "Get metrics for the pod:"
echo "    $KUBECTL_CMD top pod memory-demo-2 --namespace=mem-example"
sleep 5s; echo "";

echo "You should see that the Container is killed, restarted, killed again, and restarted. This is happeningg due to the Container running out of memory due to using more than it's limit is set to."
sleep 5s; echo "";

echo "View detailed information about your cluster's Nodes"
echo "    $KUBECTL_CMD describe nodes"
echo ""; sleep 5s

echo "Delete the pod 'memory-demo-2' that you just created in the namespace 'mem-example'."

SUCCESS=false;
while ! $SUCCESS; do
    if [[ -z "$($KUBECTL_CMD get pods --field-selector=metadata.name=memory-demo-2 --namespace mem-example -o custom-columns=NAME:.metadata.name --no-headers)" ]]; then 
      echo "";
      echo "Great job deleting your pod";
      sleep 5s;
      SUCCESS=true;
    else
      sleep 5s;
    fi
done
clear
