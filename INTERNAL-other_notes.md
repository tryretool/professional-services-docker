# Additional Info

Other notes of interest.

### Scaling
Warning: Jobs-Runner service must be a singleton.

Options:
* docker swarm
  * specifying `replica: #` on services
 

* running multiple instances
  * Limit "jobs-runner" to be a singleton
    * running a 'primary host' vs secondary hosts
  * TODO:
    * What would the GLOBAL settings for workflows host urls be then? LBs? Or separate API from workflows across hosts?

```
# Example use of profiles for jobs-runner, could be used for workflows

# Set this ENV only on your primary host
COMPOSE_PROFILES=primary_host

# add to docker-compose.yml
  jobs-runner:
    profiles: [primary_host] # will not run by default
```

### Secrets
https://docs.docker.com/engine/swarm/secrets/
