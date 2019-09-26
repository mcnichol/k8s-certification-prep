## 5% - Scheduling
### Use labelselectors to schedule Pods
    #### To Know:
    #### Commands:

### Understand the role of DaemonSets
    #### To Know:
    DaemonSets do not use a Scheduler to deploy on each container.
    DaemonSets ignore taints on a Node
    DaemonSets can be created to run on specific Nodes using the nodeSelector as part of the `spec.template.spec.nodeSelector`
    #### Commands:

### Understand how to run multiple shedulers and how to configure Pods to use them
    #### To Know:
    In determining which node to schedule your Pod, there are several steps K8s will go through to decide.
    1. Check if necessary resources exist
    2. Check if resources are available
    3. Does the pod request a specific Node
    4. Does the Node have a matching label in Pod spec
    5. Does the Pod request a specific port. If so, is that port available.
    6. If the Pod requests a mount, can that be mounted (are other pods using it?)
    7. Does the Pod tolerate the Taints of the Node
    8. Does the Pod specify Node Affinity or Pod Affinity rules?
    After checks are done, scheduler may have multiple nodes that can be available.  It will then prioritize the nodes and choose the Node with the highest priority.  If there are multiple Nodes with equal priority then they will be round-robin distributed to Nodes
    When no Scheduler is defined K8s will use the Default Scheduler
    Under the Pod > Spec > SchedulerName you can specify which Scheduler will be used
    #### Commands:
    #### Links:
    [Packaging your own scheduler](https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers)

### Manually schedule a pod without a scheduler
    #### To Know:
    You can set a Pod to a Node without a scheduler through leveraging DaemonSets
    #### Commands:
    
### Display scheduler events
    #### To Know:
    #### Commands:
    `kubectl get events -n kube-system -w`
    `kubectl logs $KUBE_SCHEDULER_POD -n kube-system`
### Know how to configure the Kubernetes scheduler
    #### To Know:
    #### Commands:

## 5% - Logging/Monitoring
### Understand how to monitor all cluster components
    #### To Know:
    #### Commands:
### Understand how to monitor applications
    #### To Know:
    #### Commands:
### Manage cluster component logs
    #### To Know:
    #### Commands:
### Manage application logs
    #### To Know:
    #### Commands:

## 8% - Application Lifecycle Management
### Understand Deployments and how to perform rolling updates and rollbacks
    #### To Know:
    #### Commands:
### Know various ways to configure applications
    #### To Know:
    #### Commands:
### Know how to scale applications
    #### To Know:
    #### Commands:
### Understand the primitives necessary to create a self-healing application
    #### To Know:
    #### Commands:

## 11% - Cluster
### Understand Kubernetes cluster upgrade process
    #### To Know:
    #### Commands:
### Facilitate operating system upgrades
    #### To Know:
    #### Commands:
### Implement backup and restore methodologies
    #### To Know:
    #### Commands:

## 12% - Security
### Know how to configure authentication and authorization
    #### To Know:
    #### Commands:
### Understand Kubernetes security primitives
    #### To Know:
    #### Commands:
### Know to configure network policies
    #### To Know:
    #### Commands:
### Create and manage TLS certificates for cluster components
    #### To Know:
    #### Commands:
### Work with images securely
    #### To Know:
    #### Commands:
### Define security contexts
    #### To Know:
    #### Commands:
### Secure persistent key value store
    #### To Know:
    #### Commands:

## 7% - Storage
### Understand persistent volumes and know how to create them
    #### To Know:
    #### Commands:
### Understand access modes for volumes
    #### To Know:
    #### Commands:
### Understand persistent volume claims primitive
    #### To Know:
    #### Commands:
### Understand Kubernetes storage objects
    #### To Know:
    #### Commands:
### Know how to configure applications with persistent storage
    #### To Know:
    #### Commands:

## 10% - Troubleshooting
### Troubleshoot application failure
    #### To Know:
    #### Commands:
### Troubleshoot control plane failure
    #### To Know:
    #### Commands:
### Troubleshoot worker node failure
    #### To Know:
    #### Commands:
### Troubleshoot networking
    #### To Know:
    #### Commands:

## 19% - Core Concepts
### Understand the Kubernetes API primitives
    #### To Know:
    #### Commands:
### Understand the Kubernetes cluster architecture
    #### To Know:
    #### Commands:
### Understand services and other network primitives
    #### To Know:
    #### Commands:

## 11% - Networking
### Understand the networking configuration on the cluster nodes
    #### To Know:
    #### Commands:
### Understand Pod networking concepts
    #### To Know:
    #### Commands:

### Understand service networking
    #### To Know:
    - Services are logical groupings of ip:port pairs. 
    - When service is created, service communicates with kube-proxy
    - kube-proxy is a controller that trackes service endpoints and updates iptables with these changes
    - Load Balancers are not POD aware. To become aware of pods in a cluster K8s uses iptables. In cases where PODs are unbalanced across nodes but even distribution is desired, this can cause increased latency. The LoadBalancer would route requests to a node which checks against iptables that is POD aware and get routed in a more evenly distributed fashion. You can remove this extra hop by adding the annotation `externalTrafficPolicy=Local` which will reduce latency at the tradeoff of a (possibly) less even LoadBalanced distribution
    - Ingress is similar to a LoadBalancer although you can access multiple Services via a single Ingress/IP address (LoadBalancer has a single IP for all its Services)
      - Ingress operates at the application layer
    #### Commands:
    - `kubectl expose deployment $DEPLOYMENT_NAME --port $EXTERNAL_PORT --type $SERVICE_TYPE`
    - `sudo iptables-save | grep KUBE | grep nginx`
    - `kubectl expose deployment $DEPLOYMENT_NAME --port $EXTERNAL_PORT --target-port $APP_PORT`
    - `kubectl get service $SERVICE_NAME -o yaml > service.yml # Declarative file from existing service`
    - `kubectl exec -ti busybox -- nslookup $POD_IP.default.pod.cluster.local #Run nslookup on busybox container`

### Deploy and configure network load balancer
    #### To Know:
    #### Commands:
### Know how to use ingress rules
    #### To Know:
    #### Commands:
### Know how to configure and use the cluster DNS
    #### To Know:
    #### Commands:
### Understand CNI
    #### To Know:
    #### Commands:

## 12% - Installation, Configuration, and Validation
### Design a Kubernetes cluter
    #### To Know:
    #### Commands:
### Install Kubernetes master and nodes
    #### To Know:
    #### Commands:
### Configure secure cluster communications
    #### To Know:
    #### Commands:
### Configure a Highly-Available Kubernetes cluster
    #### To Know:
    #### Commands:
### Know where to get the Kubernetes release binaries
    #### To Know:
    #### Commands:
### Provision underlying infrastructure to deploy a Kubernetes cluter
    #### To Know:
    #### Commands:
### Choose a network solution
    #### To Know:
    #### Commands:
### Choose your Kubernetes infrastructure configuration
    #### To Know:
    #### Commands:
### Run end-to-end tests on your cluster
    #### To Know:
    #### Commands:
### Analyse end-to-end tests results
    #### To Know:
    #### Commands:
### Run Node end-to-end tests
    #### To Know:
    #### Commands:
### Install and use kubeadm to install, configure, and manage Kubernetes clusters.
    #### To Know:
    #### Commands:
