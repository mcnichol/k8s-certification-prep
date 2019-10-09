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

echo "In this exercise, you will create a Pod that has one Container. The Container will have a CPU request of .5 CPU and a CPU limit of 1 CPU.";
echo ""; sleep 5s

echo "Create a namespace called cpu-example so that resources you create in this Task are isolated";
# Answer: microk8s.kubectl create namespace mem-example

SUCCESS=false;
while ! $SUCCESS; do
    if [ $($KUBECTL_CMD get namespaces --field-selector=metadata.name=cpu-example -o custom-columns=NAME:.metadata.name --no-headers | wc -l) -eq 1 ]; then
    echo ""
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
echo "Pod Name: cpu-demo"
echo "Namespace: cpu-example"
echo "Container Name: cpu-demo-ctr"
echo "Image: vish/stress"
echo "resources.limits.cpu: 1"
echo "resources.requests.cpu: 0.5"
echo "Container args array: [-cpus, 2]"

SUCCESS=false;
while ! $SUCCESS; do
    if [ $($KUBECTL_CMD get pods -n cpu-example -o go-template --template '{{"\n"}}{{range .items}}{{if eq .metadata.name "cpu-demo"}}{{range .spec.containers}}{{$args := .args}}{{if and (eq .image "vish/stress") (eq .name "cpu-demo-ctr") (eq .resources.limits.cpu "1") (eq .resources.requests.cpu "500m") }}{{if and (eq (index $args 0) "-cpus")  (eq (index $args 1) "2")}}{{.}}{{end}}{{end}}{{end}}{{end}}{{end}}{{"\n\n"}}' | wc | awk '{ print $2 }') -gt 0 ]; then
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
echo "    $KUBECTL_CMD get pod cpu-demo --namespace=cpu-example"
sleep 5s; echo "";

echo "For more detailed information about the Pod:"
echo "    $KUBECTL_CMD get pod cpu-demo --output=yaml --namespace=cpu-example"
sleep 5s; echo "";

echo "Get metrics for the pod:"
echo "    $KUBECTL_CMD top pod cpu-demo --namespace=cpu-example"
sleep 5s; echo "";

echo "CPU units"
echo ""
echo "The CPU resource is measured in CPU units. One CPU in K8s is equal to:"
echo " * 1 AWS vCPU"
echo " * 1 GCP Core"
echo " * 1 Azure vCore"
echo " * 1 Hypterthread on a bare-metal Intel processor with Hyperthreading"
echo "";sleep 5s

echo "Fractional values are allowed. A Container that requests 0.5 CPU is guaranteed half as much CPU as a Container that requests 1 CPU."
echo ""; sleep 5s
echo "You can use the suffix m to mean milli. For example 100m CPU, 100 milliCPU, and 0.1 CPU are all the same."
echo ""; sleep 5s
echo "Precision finer than 1m is not allowed"
echo ""; sleep 5s
echo "CPU is always requested as an absolute quantity, never as a relative quantity; 0.1 is the same amount of CPU on a single-core, dual-core, or 48-core machine."
echo ""; sleep 5s

echo "Delete the pod 'cpu-demo' that you just created in the namespace 'cpu-example'."

SUCCESS=false;
while ! $SUCCESS; do
    if [[ -z "$($KUBECTL_CMD get pods --field-selector=metadata.name=cpu-demo --namespace cpu-example -o custom-columns=NAME:.metadata.name --no-headers)" ]]; then
      echo "";
      echo "Great job deleting the pod!";
      SUCCESS=true;
      sleep 5s;
    else
      sleep 5s;
    fi
done
clear

echo "CPU requests and limits are associated with Containers, but itis useful to think of a Pod as having a CPU request and limit. The CPU request for a Pod is the sum of the CPU requests for all the Containers in the Pod. Likewise, the CPU limit for a Pod is the sum of the CPU limits for all the Containers in the Pod."
echo "";
echo "Pod scheduling is based on requests. A Pod is scheduled to run on a Node only if the Node has enough CPU resources available to satisfy the Pod CPU request."
echo "";
echo "In this exercise, you create a Pod that has a CPU request so big that it exceeds the capacity of any Node in your cluster."
echo "";
echo "Generate the declarative configuration for the Pod with below configuration:"
echo "";
echo "Pod Name: cpu-demo-2"
echo "Namespace: cpu-example"
echo "Container Name: cpu-demo-ctr-2"
echo "Image: vish/stress"
echo "resources.limits.cpu: 100"
echo "resources.requests.cpu: 100"
echo "Container args array: -cpus, 2"

SUCCESS=false;
while ! $SUCCESS; do
    if [ $($KUBECTL_CMD get pods -n cpu-example -o go-template --template '{{"\n"}}{{range .items}}{{if eq .metadata.name "cpu-demo-2"}}{{range .spec.containers}}{{$args := .args}}{{if and (eq .image "vish/stress") (eq .name "cpu-demo-ctr-2") (eq .resources.limits.cpu "100") (eq .resources.requests.cpu "100") }}{{if and (eq (index $args 0) "-cpus")  (eq (index $args 1) "2")}}{{.}}{{end}}{{end}}{{end}}{{end}}{{end}}{{"\n\n"}}' | wc | awk '{ print $2 }') -gt 0 ]; then
      echo "";
      echo "Great job creating the Pod!";
      sleep 5s
      SUCCESS=true;
    else
      sleep 5s;
    fi
done
clear

echo "Get the status of the pod"
echo "    $KUBECTL_CMD get pod cpu-demo-2 --namespace=cpu-example"
echo ""; sleep 5s

echo "The output shows that the Pod status is Pending. This means the Pod has not been scheduled to run on any Node. We've made the cpu request so high that the Pod will remain Pending indefinitely."
echo ""; sleep 5s

echo "View detailed information about the Pod including events:"
echo "    $KUBECTL_CMD describe pod cpu-demo-2 --namespace=cpu-example"
echo ""; sleep 5s

echo "The output shows that the Container cannot be scheduled because of insufficient CPU resources on the Nodes:"
echo ""
echo "Events:"
echo "  Type     Reason            Age                 From               Message"
echo "  ----     ------            ----                ----               -------"
echo "  Warning  FailedScheduling  0s (x5 over 5m50s)  default-scheduler  0/1 nodes are available: 1 Insufficient cpu."
echo ""; sleep 5s

echo "View detailed information about your cluster's Nodes"
echo "    $KUBECTL_CMD describe nodes"
echo ""; sleep 5s

echo "Delete the pod 'cpu-demo-2' that you just created in the namespace 'cpu-example'."

SUCCESS=false;
while ! $SUCCESS; do
    if [[ -z "$($KUBECTL_CMD get pods --field-selector=metadata.name=cpu-demo-2 --namespace cpu-example -o custom-columns=NAME:.metadata.name --no-headers)" ]]; then
      echo "";
      echo "Great job deleting your pod";
      sleep 5s;
      SUCCESS=true;
    else
      sleep 5s;
    fi
done
clear

echo "If you do not specify a CPU limit:"
echo ""
echo "If you do not specify a CPU limit for a Container, one of the following situations apply:"
echo ""; sleep 5s
echo "* The Container has no upper bound on the CPU resources it can use. The Container could use all of the CPU resources available on the Node when it is running."
sleep 5s
echo "* The Container is running in a namespace that has a default CPU limit and the Container is automatically assigned the default limit. Cluster administrators can use a LimitRange to specify a default value for the CPU limit."
echo ""; sleep 5s

echo "Motivation for CPU requests and limits:"
echo ""; sleep 5s
echo "By configuring the CPU requests and limits of the Containers that run in your cluster, you can make efficient use of the CPU resources available on your cluster Nodes. By keeping a Pod CPU request low, you give the Pod a good chance of beingscheduled. By having a CPU limit that is greater than the CPU request, you accomplish two things:"
echo ""; sleep 5s
echo "* The Pod can have bursts of activity where it makes use of CPU resources that happen to be available."
sleep 5s
echo "* The amount of CPU resources a Pod can use during a burst is limited to some reasonable amount."
echo ""; sleep 5s

echo "Delete the namespace 'cpu-example'. This will delete all the pods that you created for this task"
SUCCESS=false;
while ! $SUCCESS; do
    if [[ -z "$($KUBECTL_CMD get namespaces --field-selector=metadata.name=cpu-example -o custom-columns=NAME:.metadata.name --no-headers)" ]]; then
      echo "";
      echo "Great job deleting your namespace";
      sleep 5s;
      SUCCESS=true;
    else
      sleep 5s;
    fi
done
clear

echo "Great work!"
echo ""
echo "You've completed the task: Assign CPU Resources to Containers and Pods  [https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/]"
echo ""
echo "What's next:"
echo ""
echo "App Developers:"
echo "- Assign Memory Resources to Containers and Pods"
echo "- Configure Quality of Service for Pods"
echo ""
echo "Cluster Administrators:"
echo "- Configure Default Memory Requests and Limits for a Namespace"
echo "- Configure Default CPU Requests and Limits for a Namespace"
echo "- Configure Minimum and Maximum Memory Constraints for a Namespace"
echo "- Configure Minimum and Maximum CPU Constraints for a Namespace"
echo "- Configure Memory and CPU Quotas for a Namespace"
echo "- Configure a Pod Quota for a Namespace"
echo "- Configure Quotas for API Objects"
echo ""
