# Docker for "Lights On/Sandbox" deployment

### Usage Note
* Share with Customer: See [share_w_customer.md](INTERNAL/share_w_customer.md)
* Alternative: k8s: https://github.com/tryretool/retool-terraform/

# Ammended for Professional Services use
### Forked
This approach is forked from these public docs:

* https://github.com/tryretool/retool-onpremise
* https://docs.retool.com/education/labs/self-hosted/docker-compose/docker-compose-apps
* https://docs.retool.com/self-hosted/tutorials/azure-vm

### Strategy Highlights
* From Retool
  * Cloud provider deployment expected, ~like prod.
  * Restrict manual edits to 1 file (docker.env), and simpler changes to make. AKA: worry less about typos/mistakes.
  * Replaceable docker-compose file to allow more focused debugging/iterations
* If possible, by Customer
  * Simplify requirements where possible, and iterate. Get retool working, then get retool within your complex environment.
    * Public ip/dns, or public docker image, before migrating to private
    * 1 instance before scaling
    * Default service before airgapped

### File Organization
* **docker.env** - Main place for edits, setting and toggling key values
* **Dockerfile** - A stub/shell. No hardcoded info or edits required. Managed by docker-compose.yml
* **docker-compose.yml** - An easily swappable file, to facilitate iterative deployment testing
  * [docker-compose-1-networking.yml](docker-compose-1-networking.yml) - Solve frontdoor networking access. Able to view Retool in your Browser.
  * [docker-compose-2-apps-w-remote-sql.yml](docker-compose-2-apps-w-remote-sql.yml) - Add a managed database as a reliable sql solution
  * [docker-compose-3-full-stack-w-workflows.yml](docker-compose-3-full-stack-w-workflows.yml) - Full-stack adding Retool Workflows, and Temporal
  * Swappable, by either:
    * Overwrite the default file as you go, manually copy/pasting, or `cp {target-#-file}.yml docker-compose.yml`
      * _Manual copy/paste is assumed in the commands shown below_
    * Using `docker-compose -f $TARGET_COMPOSE` flag if all files are present
  * Edits required if:
    * upgrading Retool version (single line edit)
    * switching to private imagerepository (single line edit)
    * scaling (adding profiles, using docker-swarm replicas)

# Setup Steps

### Create VM/instance
In your cloud provider, via web console, or Infra as Code as you are comfortable with.

* With Public IP, if possible initially (_~in a sandbox VPC_)
* With ingress (Access Route) for port 3000

And ssh to it.

### Get Docker Files
Get these docker files to your instance.

*Warning: if you already have files that you are replacing, make sure you protect/backup your prior files*

Create a `retool` directory.
```
mkdir ~/retool
cd ~/retool
```

You have multiple options.
* Manually copy and paste the file contents into your server
  * Copy Paste the following two files to start
    - `Dockerfile`
    - `docker.env`
  * Then the `docker-compose-#*` files as needed
* Get the zip file and unzip it
  * `unzip ~/retool-docker-ps.zip`


### Enable `docker.env` with key settings

In `docker.env` set:

* **License Key**
* **Encryption Key**
  * _back up Encryption Key safely_
* **JWT** keys

Leaving the rest of settings defaulted as is, notably: http traffic, and local postgres.

## Step 1: [docker-compose-1-networking.yml]
Enable frontdoor networking access to a retool service.

#### Get new docker-compose.yml file (hotswap)

```
export TARGET_COMPOSE=docker-compose-1-networking.yml
```

Copy the contents of `docker-compose-1-networking.yml` to `docker-compose.yml`.
```
cp $TARGET_COMPOSE docker-compose.yml
```

Or use -f in your commands

```
docker-compose .... -f $TARGET_COMPOSE
```

#### Run Retool

* Run Retool.  
```
docker-compose up --build -d
```

* Confirm 3 services running (api, jobs-runner, postgres).

```
docker ps
```

* Confirm logs look good.
```
docker logs  retool-jobs-runner-1 | grep migrated
```

#### Work through Networking Access
With cloud expert assistance if needed, if you have support.

* **Step 0: API service responds locally, from instance terminal**
  * `curl localhost:3000 | grep Retool-Client-Version` # confirm output shows retool version
 
* **Step 1: Browser Accessible - ingress allowed**
  * Can you view Retool from your Browser, via IP, HTTP, and port 3000?
  * [http://IP_ADDRESS:3000]
 
* **Step 2: Domain/DNS, Port Forwarding**
  * Custom domain/sub-domain, mapped to Load Balancer, mapping port 80 to 3000/api service
  * View `http://your-sub.domain.com`

* **Step 3: Enable SSL/HTTPS**
  * Can you view `https://your-sub.domain.com`
  * Guide here: [retool self hosted certificates](https://docs.retool.com/self-hosted/guides/certificates#modify-https-configuration)
 
## Step 2: [docker-compose-2-apps-w-remote-sql.yml]
Enable Retool service to work with a robust, external, postgres solution.

#### Create Postgres DB (cloud managed db)

* Named
  * `retool-platform-db` - if instances of retool will run in separate cloud accounts
  * `retool-platform-db-{environment}` if multiple retool instances to run within one account 
* With public DNS access _(for ease of initial test install)_
* Creating an admin/**super-user**, recording the account username and password for use by Retool
* Recording the DNS/IP for access, and port

#### Update your **docker.env** POSTGRES settings
Swap the POSTGRES_HOST setting to fill it with a real instance DNS url, instead of the localhost option from step 1.

Additionally provide the new USER and PASSWORD values.

#### Get new docker-compose.yml file (hotswap)
```
export TARGET_COMPOSE=docker-compose-2-apps-w-remote-sql.yml
```

Copy the contents of `docker-compose-2-apps-w-remote-sql.yml` to `docker-compose.yml`.
```
cp $TARGET_COMPOSE docker-compose.yml
```

Or use -f in your commands

```
docker-compose .... -f $TARGET_COMPOSE
```

#### Run Retool

Ensure networking and access is setup correctly between your Retool instances, and your managed databases.

* Rerun Retool
```
docker-compose down
docker-compose up --build -d # refresh the images

docker logs  retool-jobs-runner-1 | grep migrated
```

* Reconfirm frontend access. Go to `/auth/signup` to create the first admin account

##### Debugging Notes

* DB not found
  * Create POSTGRES_DB (hammerhead_production) manually via psql or web-console
* db cant connect or run migrations
   * "no encryption"
     * remove the requirement on the DB to have SSL - trusting to network security
     * add the cert to your docker configuration
    
## Step 3: [docker-compose-3-full-stack-w-workflows.yml]

_Full Stack, adding Retool Workflows + Temporal._


#### Get new docker-compose.yml file (hotswap)
```
export TARGET_COMPOSE=docker-compose-2-apps-w-remote-sql.yml
```

Copy the contents of `docker-compose-2-apps-w-remote-sql.yml` to `docker-compose.yml`.
```
cp $TARGET_COMPOSE docker-compose.yml
```

Or use -f in your commands

```
docker-compose .... -f $TARGET_COMPOSE
```

#### Run Retool

* Rerun the build.
```
docker-compose down
docker-compose up --build -d # refresh the images
```

* Confirm 5 services running (workflows-backend, workflows-worker, code-executor).

```
docker ps
```

* Login, go to Workflows, and enable them using "Retool Temporal", choosing your closest region.

* Test executing the first default workflow. Ensure you can run it, and see that it executes.
