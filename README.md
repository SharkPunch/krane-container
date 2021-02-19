# Krane container

This [container](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idcontainer) is intended to be used in GitHub Actions to deploy your code with [Smartly.io Krane deploy action](https://github.com/smartlyio/krane-deploy-action) to Kubernetes cluster.

# Prerequisites

You'll need
- an image published to some container registry (DockerHub, AWS ECR, anything)
- a running publicly accessible kubernetes cluster
- your deployment templates defined in the same repository you deploy from

# How to use this

Here is an example workflow.

``` yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    # Some test actinos
  publish:
    # Publish your image
    runs-on: ubuntu-latest
    steps:
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1
      -
        name: Login to DockerHub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      -
        name: Build and push
        id: docker_build
        uses: docker/build-push-action@v2
        with:
          push: true
          tags: user/app:latest

  deploy:
    name: Deploy with Krane
    needs: publish
    runs-on: ubuntu-latest
    container: ghcr.io/kblcuk/krane-container:1.0.0 # This is important line! We want to run this job in container
    steps:
      - uses: actions/checkout@v2
      # Running with renderOnly:true does not require login
      - name: Authenticate to kube cluster
        env:
          KUBERNETES_AUTH_TOKEN: ${{ secrets.KUBERNETES_AUTH_TOKEN }}
        uses: smartlyio/kubernetes-auth-action@v1
        with:
          kubernetesClusterDomain: <cluster-domain>
          kubernetesServer: https://<cluster-domain>
          kubernetesContext: <any-context-name>
          kubernetesNamespace: <namespace-we-want-to-deploy>

      - name: Deploy
        uses: smartlyio/krane-deploy-action@v4.1.1
        with:
          currentSha: ${{ github.sha }}
          dockerRegistry: <where-we-pushed-image-in-publish-step>
          kubernetesClusterDomain: <cluster-domain>
          kubernetesContext: <any-context-name>
          kubernetesNamespace: <namespace-we-want-to-deploy>
          kubernetesTemplateDir: ./kube/templates
          kraneSelector: 'krane-deployment/managed-by=krane'
          extraBindings: |
            {
              "user": "cluster-admin"
            }
```
