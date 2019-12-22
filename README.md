# Django application deployment in kubernetes

To get started with kubernetes in local environment use <a href="https://microk8s.io/docs/" target="__blank">Microk8s</a>. Go through the microk8s setup documentation and setup it.

## Adding alias to "microk8s.kubectl" to "k8s"
Open `~/.bashrc` and below line at the end of the file.
```bash
alias k8s="microk8s.kubectl"
```

## Now, clone this repo using below commands
```
git clone git@github.com:AnjaneyuluBatta505/kubernetes_django.git
```

## Let's start the deployment of the django application and other apps like redis, postgres, flower, etc.

### Setting up postgres service
In the postgres we have 4 `yaml` configuration files.
1. secrets.yaml      - Useful when using secret env vaibles in the apps
2. volume.yaml       - Persistent Volume for Postgres database   
3. volume_claim.yaml - This claim lets our deployment application store its data in an external location, so that if one of the application’s containers fails, it can be replaced with a new container and continue accessing its data stored externally, as though an outage never occurred. 
4. deployment.yaml   - Deployment to start the application containers
5. service.yaml      - Allows other apps to comminicate with it's related deployment(i.e pods/containers)

Now, create above objects in kubernetes using below commands
```
k8s apply -f kubernetes/postgres/secrets.yaml
k8s apply -f kubernetes/postgres/volume.yaml
k8s apply -f kubernetes/postgres/volume_claim.yaml
k8s apply -f kubernetes/postgres/deployment.yaml
k8s apply -f kubernetes/postgres/service.yaml
```
We have successfully created the postgres service in k8s(i.e kubernetes cluster).

### Setting up redis service
In the redis we have 2 `yaml` configuration files.
To setup the redis service in k8s execute the below commands
```
k8s apply -f kubernetes/redis/deployment.yaml
k8s apply -f kubernetes/redis/service.yaml
```

### Setting up django app
In django app we have 3 `yaml` configuration files.
To setup the django app in k8s execute the below commands
```
k8s apply -f kubernetes/django/job-migration.yaml
k8s apply -f kubernetes/django/deployment.yaml
k8s apply -f kubernetes/django/service.yaml
```

### Setting up celery app
In celery app we have 2 `yaml` configuration files.
To setup the django app in k8s execute the below commands
```
k8s apply -f kubernetes/celery/beat-deployment.yaml
k8s apply -f kubernetes/celery/worker-deployment.yaml
```

### Setting up flower app
In flower app we have 2 `yaml` configuration files.
To setup the django app in k8s execute the below commands
```
k8s apply -f kubernetes/flower/deployment.yaml
k8s apply -f kubernetes/flower/service.yaml
```
## How to debug the pods for errors if any failures occurs ?
```
$ k8s get po
NAME                             READY   STATUS      RESTARTS   AGE
celery-beat-75b5f954-m2pzj       1/1     Running     0          64m
celery-worker-56fc7b88f5-shd87   1/1     Running     0          61m
django-688f76f576-kt4h6          1/1     Error       0          60m
django-migrations-mhng7          0/1     Completed   0          59m
flower-77bf99c799-9drnp          1/1     Running     87         20h
postgres-76dc76ffbb-hzmdc        1/1     Running     2          23h
redis-76f6f4857b-srxlw           1/1     Running     1          20h
```
We can debug the pod failure using command `k8s logs <pod name>`.
Sometimes `k8s describe <name of k8s object>`

## To access the django app in our local browser
```
$ k8s get svc
NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
django-service     NodePort    10.152.183.146   <none>        8000:32693/TCP   21h
flower-service     NodePort    10.152.183.170   <none>        5555:30675/TCP   21h
kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP          25h
postgres-service   ClusterIP   10.152.183.151   <none>        5432/TCP         24h
redis-service      ClusterIP   10.152.183.89    <none>        6379/TCP         21h

```
Visit url "10.152.183.146:8000" (i.e `CLUSTER-IP:PORT`). It's just for testing.

## References:

1. https://microk8s.io/docs/
2. https://kubernetes.io/docs/home/
3. https://medium.com/edureka/what-is-kubernetes-container-orchestration-tool-d972741550f6 
