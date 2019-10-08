KUBECTL_CMD=""

clear

if [ "$(uname)" == "Darwin" ]; then
  echo "Using Mac; assuming minikube and using native kubectl";
  KUBECTL_CMD="kubectl"
  echo ""; sleep 3s

  echo "Ensure metrics-server is enabled. You can enable with:"
  echo "    minikube addons enable metrics-server"
  echo ""; sleep 5s
else
  echo "Using Linux; assuming microk8s and using microk8s.kubectl";
  KUBECTL_CMD="microk8s.kubectl"
  echo ""; sleep 3s

  echo "Ensure metrics-server is enabled. You can enable with:"
  echo "    microk8s.enable metrics-server"
  echo ""; sleep 5s
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
echo "Container Name: memory-demo-ctr"
echo "Image: polinux/stress"
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
echo "";
echo "Containers can exceed their memory request if the Node has memory available but a Container cannot use more than its memory limit."
echo "";
echo "If a Container allocates more memory than it's limit, the container becomes a candidate for termincation. If it continues to consume memory beyond its limit, it is terminated. Terminated containers can be restarted. The kubelet would restart it similar to any other type of runtime failure."
echo "";
echo "Generate the declarative configuration for the Pod with below configuration:"
echo "";
echo "Pod Name: memory-demo-2"
echo "Namespace: mem-example"
echo "Container Name: memory-demo-2-ctr"
echo "Image: polinux/stress"
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
echo ""; sleep 5s

echo "For more detailed information about the Pod where you can see terminateion details under 'lastState':"
echo "    $KUBECTL_CMD get pod memory-demo-2 --output=yaml --namespace=mem-example"
echo ""; sleep 5s

echo "You should see that the Container is killed, restarted, killed again, and restarted. This is happeningg due to the Container running out of memory due to using more than it's limit is set to."
echo ""; sleep 5s

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

echo "In this exercise, we will create a Pod that requests more memory than exists on the Nodes."
echo "";
echo "Memory requests and limits are Container level resources. Many containers can make up a single Pod.  When thinking about the Pod Request/Limit, it is the aggregate of all containers within the pod."
echo "";
echo "Scheduling a Pod is based on requests. A pod is scheduled to run on a Node only if the Node has enough available memory to satisfy the Pod's memory request."
echo "";
echo "Generate the declarative configuration for the Pod with below configuration:"
echo "";
echo "Pod Name: memory-demo-3"
echo "Namespace: mem-example"
echo "Container Name: memory-demo-3-ctr"
echo "Image: polinux/stress"
echo "resources.limits.memory: 100Gi"
echo "resources.requests.memory: 100Gi"
echo "Container start command: stress"
echo "Container args array: --vm, 1, --vm-bytes, 150M, --vm-hang, 1"

SUCCESS=false;
while ! $SUCCESS; do
    if [ $($KUBECTL_CMD get pods -n mem-example -o go-template --template '{{"\n"}}{{range .items}}{{if eq .metadata.name "memory-demo-3"}}{{range .spec.containers}}{{$command := (index .command 0)}}{{$args := .args}}{{if and (eq .image "polinux/stress") (eq .name "memory-demo-3-ctr") (eq .resources.limits.memory "100Gi") (eq .resources.requests.memory "100Gi") (eq $command "stress")}}{{if and (or (eq (index $args 0) "--vm") (eq (index $args 2) "--vm") (eq (index $args 4) "--vm"))  (or (eq (index $args 1) "1") (eq (index $args 3) "1") (eq (index $args 5) "1")) (or (eq (index $args 0) "--vm-bytes") (eq (index $args 2) "--vm-bytes") (eq (index $args 4) "--vm-bytes")) (or (eq (index $args 1) "150M") (eq (index $args 3) "150M") (eq (index $args 5) "150M")) (or (eq (index $args 0) "--vm-hang") (eq (index $args 2) "--vm-hang") (eq (index $args 4) "--vm-hang"))}}{{.}}{{end}}{{end}}{{end}}{{end}}{{end}}{{"\n\n"}}' | wc | awk '{ print $2 }') -gt 0 ]; then
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
echo "    $KUBECTL_CMD get pod memory-demo-3 --namespace=mem-example"
echo ""; sleep 5s

echo "The output shows that the Pod status is in a PENDING state. The Pod is not scheduled to run on any Node and it will remain in this PENDING state indefinitely."
echo ""; sleep 5s

echo "View detailed information about the Pod, including events:"
echo "    $KUBECTL_CMD describe pod memory-demo-3 --namespace=mem-example"
echo ""; sleep 5s

echo "The output shows the Container cannot be scheduled because of insufficient memory on the Nodes:"
echo "  ...  FailedScheduling  No nodes are available that match all of the following predicates:: Insufficient memory (3)."
echo ""; sleep 5s

echo "Memory resources are measured in bytes. You can express memory as a plain integer or fixed point integer with one of the following suffixes:"
echo "    E, P, T, G, M, K, Ei, Pi, Ti, Gi, Mi, Ki"
echo "    For example, these are all approximately the same: 128974848, 129e6, 129M, 123Mi"
echo ""; sleep 5s

echo "Delete the pod 'memory-demo-3' that you just created in the namespace 'mem-example'."

SUCCESS=false;
while ! $SUCCESS; do
    if [[ -z "$($KUBECTL_CMD get pods --field-selector=metadata.name=memory-demo-3 --namespace mem-example -o custom-columns=NAME:.metadata.name --no-headers)" ]]; then
      echo "";
      echo "Great job deleting your pod";
      sleep 5s;
      SUCCESS=true;
    else
      sleep 5s;
    fi
done
clear

echo "If you do not specify a memory limit for a Container, one of the following situations apply:"
echo ""; sleep 5s
echo "* The Container has no upper bound on the amount of memory it uses. The Container could use all of the memory available on the Node where it is running which in turn could invoke the OOM Killer. Containers with no resource limits have a greater chance of being killed by the memory killer."
echo "* The Container is running in a namespace that has a default memory limit, and the Container is automatically assigned the default limit. Cluster administrators can use a LimitRange to specify a default value for the memory limit."
echo ""; sleep 5s

echo "Motivation for memory requests and limits"
echo ""; sleep 5s
echo "By configuring memory requests and limits for the Containers that run in your cluster, you can make efficient use of the memory resources available on your cluster's Nodes. By keeping a Pod's memory request low, you give the Pod a good chance of being scheduled. By having a memory limit that is greater than the memory request you accomplish two things:"
echo ""; sleep 5s
echo "* The Pod can have bursts of activity where it makes use of memory that happens to be available."
echo "* The amount of memory a Pod can use during a burst is limited to some reasonable amount."
echo ""; sleep 5s

echo "Delete your namespace. This will delete all the pods that you created for this task"
SUCCESS=false;
while ! $SUCCESS; do
    if [[ -z "$($KUBECTL_CMD get namespaces --field-selector=metadata.name=mem-example -o custom-columns=NAME:.metadata.name --no-headers)" ]]; then
      echo "";
      echo "Great job deleting your namespace";
      sleep 5s;
      SUCCESS=true;
    else
      sleep 5s;
    fi
done
clear

echo "You've completed the task: Assign Memory Resources to Containers and Pods  [https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/]"
