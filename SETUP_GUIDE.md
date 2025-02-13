# Setup Guide

### Create VM/instance
In your cloud provider, via web console, or Infra as Code as you are comfortable with.

* With Public IP, if possible initially (_~in a sandbox VPC_)
* With ingress (Access Route) for port 3000
* Get your SSH Key

* ssh to it.
* install docker-compose


### Get Docker Files

```
curl https://github.com/tryretool/professional-services-docker/archive/refs/heads/main.zip
```

```
unzip professional-services-docker-main.zip
```
```
mkdir retool && mv professional-services-docker-main/* retool
```

### Enable `docker.env` with key settings

In `docker.env` set:

* **License Key**
* **Encryption Key**
  * _back up Encryption Key safely_
* **JWT** keys

Leaving the rest of settings defaulted as is, notably: http traffic, and local postgres.

## Docker Step 1: [docker-compose-1-networking.yml]
Enable frontdoor networking access to a retool service.

#### Get new docker-compose.yml file (hotswap)

```
export TARGET_COMPOSE=docker-compose-1-networking.yml
```

```
docker-compose up -f $TARGET_COMPOSE --build
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
