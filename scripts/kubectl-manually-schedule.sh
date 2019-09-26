# This manually triggers a Binding action against the scheduler in a K8s Cluster when a Pods exists but nameNode not bound
SERVER="$(kubectl config view -o json | jq .clusters[].cluster.server -r)"
SECRET="$(kubectl get secrets | jq .items[].metadata.name -r)"
TOKEN="$(kubectl get secret $SECRET -o json | jq .data.token -r | base64 -d)"
POD_NAME=[INSERT_POD_NAME]

curl -H "Content-Type:application/json" -H "Authorization: Bearer $TOKEN" -X POST --data '{"kind":"Binding", "apiVersion": "v1", "metadata":{"name":"$POD_NAME","creationTimestamp": null}, "target":{"kind":"Node","name":"node01","apiVersion":"v1"}}' $SERVER/api/v1/namespaces/default/pods/$POD_NAME/binding/ -k
