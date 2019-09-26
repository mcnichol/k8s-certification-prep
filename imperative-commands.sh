bold () {
    echo "\e[1m$1\e[0m" 
}

cyan () {
    echo "\e[36m$1\e[0m" 
}

blue () {
    echo "\e[34m$1\e[0m" 
}

red () {
    echo "\e[31m$1\e[0m" 
}

TIPS=()

TIPS+=("
$(cyan "--dry-run")

The $(cyan "--dry-run") option will $(bold "not create the resource"). It will tell you if the $(bold "command is correct") and the resource can be created.
")

TIPS+=( "-o yaml | json | wide | name | custom-columns{,-file} | go-template{,-file} | jsonpath{,-file}

Output the resource in a supported format of your choice. 

For more documentation on templates/files see below:
    
[custom-columns](http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns)
[go-template](http://golang.org/pkg/text/template/#pkg-overview)
[jsonpath](http://kubernetes.io/docs/user-guide/jsonpath)
")

TIPS+=( $'
kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml > pod-definition.yaml

Use the flags --dry-run and -o yaml in combination with a generator to output a resource definition file quickly. 
' )


TIPS+=( $'
kubectl run --generator=run-pod/v1 nginx --image=nginx

Easily create an nginx pod using a generator
' )

TIPS+=( $'
kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml

Generate POD Manifest YAML files (-o yaml) and don\'t create it(--dry-run)
' )

TIPS+=( $'
Recommended:
kubectl create deployment --image=nginx nginx

Deprecated:
kubectl run --generator=deployment/v1beta1 nginx --image=nginx

Explanation:
Generate a deployment using nginx image
' )

TIPS+=( $'
Generate a deployment file without creating it and output in yaml

Deprecated:
kubectl run --generator=deployment/v1beta1 nginx --image=nginx --dry-run -o yaml

Recommended:
kubectl create deployment --image=nginx nginx --dry-run -o yaml
' )

TIPS+=( $'
Generate a deployment with 4 replicas without creating it and output in yaml

Deprecated:
kubectl run --generator=deployment/v1beta1 nginx --image=nginx --replicas=4 --dry-run -o yaml

Note:
kubectl create deployment does not have a --replicas option. You could first create it and then scale it using the kubectl scale command. 
' )

#Service
#
#Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379
#
#kubectl expose pod redis --port=6379 --name redis-service --dry-run -o yaml
#
#(This will automatically use the pod's labels as selectors)
#
#Or
#
#kubectl create service clusterip redis --tcp=6379:6379 --dry-run -o yaml  (This will not use the pods labels as selectors, instead it will assume selectors as app=redis. You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)
#
#
#Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:
#
#kubectl expose pod nginx --port=80 --name nginx-service --dry-run -o yaml
#
#(This will automatically use the pod's labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.)
#
#Or
#
#kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run -o yaml
#
#(This will not use the pods labels as selectors)
#
#Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the kubectl expose command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.
#"""

for tip in "${TIPS[@]}"; do
    clear
    echo -e "$tip"
    sleep 5
    clear
done 
