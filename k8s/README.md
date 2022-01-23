## Kubernetes
Orchestration system for automating software deployment, scaling, and management.

### Namespace
NameSpace "statsd-app" for all the resoueces to deploy to
`kubectl apply -f namespace.yaml`
### Service Account
ServiceAccount "statsd-admin" for app and graphite-statsd pods
`kubectl apply -f serviceAccount.yaml`

### PVC
GCP persistent disk for graphite-statsd deployment with dynamic provisioning 
`kubectl apply -f pvc.yaml`

### graphite-statsd Deployment/Service
- This deployment will create 1 pod for graphite-statsd image. 
- graphite-statsd pod use persistent storage.
- graphite-statsd ClusterIP service expose 8125 UDP and other non-web ports
- statsd-http LoadBalancer service expose 80 port
`kubectl apply -f graphite.yaml`

### App Deployment
Before deploy, update the image address and make sure the image is pushed to the repository. 1 pod will be deployed.
`kubectl apply -f app.yaml`

