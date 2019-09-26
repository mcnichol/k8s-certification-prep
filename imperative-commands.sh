FG_CYAN="\e[36m"
FG_BLUE="\e[34m"
FG_RED="\e[31m"
FG_LT_GREEN="\e[92m"

RESET_ALL="\e[0m"
bold () {
    echo "\e[1m$1$RESET_ALL" 
}

colorize () {
    echo "$1$2$RESET_ALL" 
}

TIPS=()

TIPS+=("
\n\n\t$(colorize "$FG_CYAN" "--dry-run")

\t$(bold "Explanation:")
\tThe $(colorize "$FG_CYAN" "--dry-run") option will $(bold "not create the resource"). It will tell you if the $(bold "command is correct") and the resource can be created.
")

TIPS+=("
\n\n\t$(colorize "$FG_CYAN" "-o yaml | json | wide | name | custom-columns{,-file} | go-template{,-file} | jsonpath{,-file}")

\tOutput the resource in a supported format of your choice. 

\tFor more documentation on templates/files see below:
\t    custom-columns - ($(colorize "$FG_LT_GREEN" "http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns"))
\t    go-template]   - ($(colorize "$FG_LT_GREEN" "http://golang.org/pkg/text/template/#pkg-overview"))
\t    jsonpath       - ($(colorize "$FG_LT_GREEN" "http://kubernetes.io/docs/user-guide/jsonpath"))
")

TIPS+=(" 
\n\n\t$(colorize "$FG_CYAN" "kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml > pod-definition.yaml")

\tUse the flags $(colorize "$FG_CYAN" "--dry-run") and $(colorize "$FG_CYAN" "-o yaml") in combination with a $(colorize "$FG_CYAN" "--generator") to output a resource definition file quickly. 
")


TIPS+=(" 
\n\n\t$(colorize "$FG_CYAN" "kubectl run --generator=run-pod/v1 nginx --image=nginx")


\tCreate an nginx pod using a generator
")

TIPS+=(" 
\n\n\t$(colorize "$FG_CYAN" "kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml")

\tCreate an nginx pod using a generator but do not create it ($(colorize "$FG_CYAN" "--dry-run")) and output as yaml ($(colorize "$FG_CYAN" "-o yaml"))
")

TIPS+=("
Recommended:
kubectl create deployment --image=nginx nginx

Deprecated:
kubectl run --generator=deployment/v1beta1 nginx --image=nginx

Explanation:
Generate a deployment using nginx image
")

TIPS+=("
Generate a deployment file without creating it and output in yaml

Deprecated:
kubectl run --generator=deployment/v1beta1 nginx --image=nginx --dry-run -o yaml

Recommended:
kubectl create deployment --image=nginx nginx --dry-run -o yaml
")

TIPS+=(" 
$(colorize "$FG_CYAN" "kubectl run --generator=deployment/v1beta1 nginx --image=nginx --replicas=4 --dry-run -o yaml")

Generate a deployment with 4 replicas without creating it and output in yaml

Note:
kubectl create deployment does not have a --replicas option. You could alternatively create it and kubectl scale. 
")

TIPS+=("
$(colorize "$FG_CYAN" "kubectl expose pod redis --port=6379 --name redis-service --dry-run -o yaml")

Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379. 

This will automatically use the pod's labels as selectors
")

TIPS+=("
$(colorize "$FG_CYAN" "kubectl create service clusterip redis --tcp=6379:6379 --dry-run -o yaml")

This will not use the pods labels as selectors, instead it will assume selectors as app=redis. You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service
")

TIPS+=("
$(colorize "$FG_CYAN" "kubectl expose pod nginx --port=80 --name nginx-service --dry-run -o yaml")

Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:

This will automatically use the pod's labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.

")

TIPS+=("
$(colorize "$FG_CYAN" "kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run -o yaml")

(This will not use the pods labels as selectors)

Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the kubectl expose command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.
")

for tip in "${TIPS[@]}"; do
    clear
    echo -e "$tip"
    sleep 5
    clear
done 
