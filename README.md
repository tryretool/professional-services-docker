# Docker for "Lights On/Sandbox" deployment

These instructions are focused on running Retool via Docker, with references to Infra steps (minimally explained).

Alternative: k8s: https://github.com/tryretool/retool-terraform/

### File Organization
* **docker.env** - Main place for edits, setting and toggling key values
* **Dockerfile** - A stub/shell. No hardcoded info or edits required. Managed by docker-compose.yml
* **docker-compose.yml** - An easily swappable file, to facilitate iterative deployment testing
  * [docker-compose-1-networking.yml](docker-compose-1-networking.yml) - Solve frontdoor networking access. Able to view Retool in your Browser.
  * [docker-compose-2-apps-w-remote-sql.yml](docker-compose-2-apps-w-remote-sql.yml) - Add a managed database as a reliable sql solution
  * [docker-compose-3-full-stack-w-workflows.yml](docker-compose-3-full-stack-w-workflows.yml) - Full-stack adding Retool Workflows, and Temporal
  * Swappable using the -f flag, to iteratively solve your deployment provisioning
    * Using `docker-compose -f $TARGET_COMPOSE`
  * Edits required if:
    * upgrading Retool version (single line edit)
    * switching to private imagerepository (single line edit)
    * scaling (adding profiles, using docker-swarm replicas)
