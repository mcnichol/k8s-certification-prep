echo "Question 1:"
echo ""
echo "Deploy a pod named 'nginx-pod' using the 'nginx:alpine' image."
echo ""; sleep 5s; clear

echo "Question 2:"
echo ""
echo "Deploy a 'messaging' pod using the 'redis:alpine' image with the labels set to 'tier=msg'."
echo ""; sleep 5s; clear

echo "Question 3:"
echo ""
echo "Create a namespace named 'apx-x9984574'"
echo ""; sleep 5s; clear

echo "Question 4:"
echo ""
echo "Get the list of nodes in JSON format and store it in a file './node-list.json'"
echo ""; sleep 5s; clear

echo "Question 5:"
echo ""
echo "Create a service 'messaging-service' to expose the 'messaging' application within the cluster on port '6379'."
echo ""; sleep 5s; clear

echo "Question 6:"
echo ""
echo "Create a deployment named 'hr-web-app' using the image 'kodekloud/webapp-color' with '2' replicas."
echo ""; sleep 5s; clear

echo "Question 7:"
echo ""
echo "Create a pod definition file in the manifests folder."
echo ""
echo "Use command:" 
echo ""
echo "kubectl run --restart=Never --image=busybox static-busybox --dry-run -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml"
echo ""; sleep 5s; clear
