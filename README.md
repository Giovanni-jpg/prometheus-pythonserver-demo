# Prometheus Playground with Docker

Setting up a small monitoring environment using **Prometheus** and **Node Exporter** containers, along with a simple **Python server** exposing metrics via `prometheus_flask_exporter`. Built that project overnight to understand the basics of prometheus setup and use.

You’ll be able to:
- Run multiple `node-exporter` containers.
- Run a `prometheus` container scraping those exporters.
- Run a Python Flask server container exposing metrics on a separate job.
- View all health statuses and query metrics via Prometheus UI at [http://localhost:9090](http://localhost:9090).

---

## Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed and running.
- [Git](https://git-scm.com/) installed.

---

## Setup

### 1. Install required docker images
```bash
docker pull bitnami/node-exporter:latest
docker pull bitnami/prometheus:latest
````

### 2. Create a Docker network

```bash
docker network create prometheus-net
```

### 3. Run Node Exporter containers

```bash
docker run -d --name node-exporter1 --network prometheus-net \
  -p 9101:9100 bitnami/node-exporter:latest

docker run -d --name node-exporter2 --network prometheus-net \
  -p 9102:9100 bitnami/node-exporter:latest

docker run -d --name node-exporter3 --network prometheus-net \
  -p 9103:9100 bitnami/node-exporter:latest
```

### 4. Run Prometheus

Prometheus is configured via `prometheus.yml` located in this repo. Mount it when starting the container:

```bash
docker run -d --name prometheus --network prometheus-net \
  -p 9090:9090 \
  -v $(pwd)/prometheus.yml:/opt/bitnami/prometheus/conf/prometheus.yml \
  bitnami/prometheus:latest
```

### 5. Build and run the Python Flask server

Python server is containerized, built from the image created by the `Dockerfile` located in this repo.

```bash
docker build -t pythonserver .
docker run -d --name pythonserver --network prometheus-net \
  -p 8081:8080 pythonserver
```

---

## Usage

* Visit Prometheus UI: [http://localhost:9090](http://localhost:9090)
* Check **Targets** at: [http://localhost:9090/targets](http://localhost:9090/targets)
  You should see:

  * 3 `node-exporter` instances under the same job.
  * 1 `flask-server` under its own job.

* Try playing around stopping containers and see health status updating by refreshing prometheus dashboard

---

## Stopping Everything

```bash
docker stop prometheus pythonserver node-exporter1 node-exporter2 node-exporter3
docker rm prometheus pythonserver node-exporter1 node-exporter2 node-exporter3
docker network rm prometheus-net
```

---

## Documentation

Find below the documentation links that were used to build this repo:

* [Bitnami Prometheus container image](https://github.com/bitnami/containers/tree/main/bitnami/prometheus#how-to-use-this-image)
* [Docker doc](https://docs.docker.com/reference/cli/docker/container/restart/)
* [Understand docker network](https://www.youtube.com/watch?v=zJD7QYQtiKc)
