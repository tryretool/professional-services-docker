# Docker for "Lights On/Sandbox" deployment

These instructions are focused on running Retool via Docker, with references to Infra steps (minimally explained). Expecation is that each customer has different cloud environmentments and requirements, and should have some representative (or Retool help) for the infra around Retool.

This is divergent from other Retool Docker guides to minimize manual edits by the deployer, typically only requiring "input a setting".

Alternative: k8s: https://github.com/tryretool/retool-terraform/

### Setup

See [Setup Guide](SETUP_GUIDE.md) for instructions

### Docker File Organization
5 key docker files + a SETUP_GUIDE.

* **docker.env**
  * Main place for edits. Adding or toggling key settings.
* **Dockerfile**
  * A stub/shell. No hardcoded info or edits required. Details provided by docker-compose\*.yml
* **docker-compose-{#{-{purpose}.yml**
  * Swappable files: to facilitate iterative deployment building and testing.
    * Using `docker-compose up -f $TARGET_COMPOSE`
  * **Step 1** [docker-compose-1-networking.yml](docker-compose-1-networking.yml)
    * Solve frontdoor networking access, dns/https. Able to view Retool in your Browser safely.
  * **Step 2** [docker-compose-2-apps-w-remote-sql.yml](docker-compose-2-apps-w-remote-sql.yml)
    * Provision a managed database and connect it to your instance
  * **Step 3** [docker-compose-3-full-stack-w-workflows.yml](docker-compose-3-full-stack-w-workflows.yml)
    * Add Retool Workflows w/ Temporal configured
