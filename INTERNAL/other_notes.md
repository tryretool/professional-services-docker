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


# Ammended for Professional Services use
### Forked from other public guides and documentation
This approach is forked from these public docs:

* https://github.com/tryretool/retool-onpremise
* https://docs.retool.com/education/labs/self-hosted/docker-compose/docker-compose-apps
* https://docs.retool.com/self-hosted/tutorials/azure-vm

### Strategy Highlights
* From Retool
  * Cloud provider deployment expected, ~like prod.
  * Restrict manual edits to 1 file (docker.env), as "inputing a setting". AKA: worry less about typos/mistakes. Do not have to remove psql.
  * Replaceable docker-compose file to allow more focused debugging/iterations
* If possible, by Customer
  * Simplify requirements where possible, and iterate. Get retool working, then get retool within your complex environment.
    * Public ip/dns, or public docker image, before migrating to private
    * 1 instance before scaling
    * Default service before airgapped

