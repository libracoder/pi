### install metal LB
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -f values.yaml


k apply -f  /var/www/html/pi/test/metallb-config.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

### install nginx ingress
kubectl delete -f common/ns-and-sa.yaml
kubectl delete -f rbac/rbac.yaml
kubectl delete -f common/default-server-secret.yaml

#### config map
kubectl delete -f common/nginx-config.yaml
kubectl delete -f common/ingress-class.yaml

### TCP and UDP LB
kubectl delete -f common/crds/k8s.nginx.org_globalconfigurations.yaml

### delete Loadbalancer
kubectl delete -f service/loadbalancer.yaml
kubectl delete -f service/nginx-ingress.yaml

### Create ingress controller
kubectl get pods -o wide -n nginx-ingress


## install crds
kubectl delete -f common/crds/k8s.nginx.org_virtualservers.yaml
kubectl delete -f common/crds/k8s.nginx.org_virtualserverroutes.yaml
kubectl delete -f common/crds/k8s.nginx.org_transportservers.yaml
kubectl delete -f common/crds/k8s.nginx.org_policies.yaml



https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml