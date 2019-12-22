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
In django app we have 2 `yaml` configuration files.
To setup the django app in k8s execute the below commands
```
k8s apply -f kubernetes/celery/beat-deployment.yaml
k8s apply -f kubernetes/celery/worker-deployment.yaml
```

### Setting up flower app
In django app we have 2 `yaml` configuration files.
To setup the django app in k8s execute the below commands
```
k8s apply -f kubernetes/flower/deployment.yaml
k8s apply -f kubernetes/flower/service.yaml
```
