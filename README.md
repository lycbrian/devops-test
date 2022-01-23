![Oozou](https://cdn.oozou.com/assets/logo-29352bd92fe47c629c5ff5f3885ed9fea425a4cf4db8ccc8ba253ad2fe2d373d.png)


## Introduction

This is a technical test for the role of **DevOps Engineer**.

## Objectives

This test helps us to understand
- how do you approach infrastructure design
- how do you manage microservices communication
- how do you consider security implications

## Project Setup

Project root has [`index.js`](/index.js) file. It simulates a simple app that runs infinitely & sends metrics to a [`statsd`](https://github.com/statsd/statsd) server.

## Exercices

  1. Add a `Dockerfile` to containerize the app, with support for multiple environments (test, development & production)
  2. Add a `docker-compose.yml` file to setup Node app, `statsd` & the backend. Applicants can use any backends for `statsd` (eg: `Graphite`).
  3. Use any IAC tools (Cloudformation, Terraform etc.) to prepare the infrastructure
  4. (Optional) Deploy on any cloud computing platforms

## Submitting Your Code

Email us your Github repo. We expect meaningful git commits, ideally one commit per exercise with commit messages clearly communicating the intent.

In case you deploy it to any cloud platforms, please send us instructions & relevant IAM user credentials.
  

## Work
- Docker/Docker-compose
- Terraform -> Setup GKE environment
- kubernetes -> Deploy app in GKE

## Docker
### Build Image
`docker build . -t app-test:1.0 `

### Docker-compose - Dev Env
docker-compose.yml compose two components:
- app -> built from Dockerfile-dev
- graphite -> graphite-statsd:1.1.8-5 (enable debug for dev env)

`docker-compose up -d`

## Terraform 
[README](https://github.com/lycbrian/devops-test/blob/main/terraform/README.md)

## Kubernetes
[README](https://github.com/lycbrian/devops-test/blob/main/k8s/README.md)
