# Setup Guide

### Create VM/instance
In your cloud provider, via web console, or Infra as Code as you are comfortable with.

* With Public IP, if possible initially (_~in a sandbox VPC_)
* With ingress (Access Route) for port 3000
* Get your SSH Key

* ssh to it.
* install docker / docker-compose


### Get Docker Files

```
curl https://github.com/tryretool/professional-services-docker/archive/refs/heads/main.zip
```

```
unzip professional-services-docker-main.zip
```

```
mkdir retool && mv professional-services-docker-main/* retool && cd retool
```

### Add key settings to `docker.env`

In `docker.env` set:

* **License Key**
* **Encryption Key**
  * _back up Encryption Key safely_
* **JWT** keys

Leaving the rest of settings defaulted as is, notably: http traffic, and local postgres.

## Docker Step 1: [docker-compose-1-networking.yml]

**Goal** Enable frontdoor networking access to a retool service, with https.

Often a challenge "around retool". While solving this, the first docker-compose file is the most minimal viable to run, to prevent distractions.

#### Set target Compose File

```
export TARGET_COMPOSE=docker-compose-1-networking.yml
```

### Run Minimal Retool

Then run your 'up' commands as follows:

```
docker-compose up -f $TARGET_COMPOSE --build -d
```

Confirm 3 services running (retool-api-1, retool-jobs-runner-1, postgres-1).

```
docker ps
```

Confirm logs look good - jobs runner started successfully

```
docker logs  retool-jobs-runner-1 | grep migrated
```

### Work through Networking Access
With cloud expert assistance if needed, if you have support.

* **Step 0: API service responds locally, from instance terminal**
  * `curl localhost:3000 | grep Retool-Client-Version` # confirm output shows retool version
 
* **Step 1: Browser Accessible - ingress allowed - unsafe HTTP**
  * Can you view Retool from your Browser, via IP, HTTP, and port 3000?
  * [http://IP_ADDRESS:3000]
 
* **Step 2: Domain/DNS, Port Forwarding - unsafe HTTP**
  * Custom domain/sub-domain, mapped to Load Balancer, mapping port 80 to 3000/api service
  * View `http://your-sub.domain.com`

* **Step 3: Enable SSL/HTTPS**
  * Can you view `https://your-sub.domain.com`
  * Guide here: [retool self hosted certificates](https://docs.retool.com/self-hosted/guides/certificates#modify-https-configuration)
 
## Step 2: [docker-compose-2-apps-w-remote-sql.yml]
Enable Retool service to work with a robust, external, postgres solution.

### Setup Postgres DB (cloud managed db)

#### Provision DB in Cloud
* Named
  * `retool-platform-db` - if instances of retool will run in separate cloud accounts
  * `retool-platform-db-{environment}` if multiple retool instances to run within one account 
* With public DNS access _(for ease of initial test install)_
* Creating an admin/**super-user**, recording the account username and password for use by Retool
* Recording the DNS/IP for access, and port

#### Update your **docker.env** POSTGRES settings

* Swap the `POSTGRES_HOST` setting to fill it with a real instance DNS url, instead of the localhost option from step 1.

* Provide the new `POSTGRES_USER` and `POSTGRES_PASSWORD` values.

#### Get new docker-compose.yml file (hotswap)
```
export TARGET_COMPOSE=docker-compose-2-apps-w-remote-sql.yml
```

#### Run Retool
In order to ensure it loads, has the right credentials for the DB, and networking access to the DB.

```
docker-compose up -f $TARGET_COMPOSE --build -d
```

Confirm DB is connected successfully.
```
docker logs  retool-jobs-runner-1 | grep migrated
```

* Reconfirm frontend access.
  * Go to `https://{yourdomain.com}/auth/signup` to create the first admin account

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

#### Run Retool

Rerun it.

```
docker-compose up -f $TARGET_COMPOSE --build -d
```

* Confirm 5 services running (new: workflows-backend, workflows-worker, code-executor).

```
docker ps
```

#### Enable and Execute Retool Workflows
* Login, go to Workflows, and enable them using "Retool Temporal", choosing your closest region.

* Test executing the first default workflow. Ensure you can run it, and see that it executes.
