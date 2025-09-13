Ecommerce Kubernetes Project

Overview

This project demonstrates setting up and managing a Kubernetes-based
Ecommerce application with multiple microservices using Helm and Kind.

Components

-   Kind: Local Kubernetes cluster setup and management.
-   Helm: Package manager for Kubernetes, used to create and manage
    charts for the Ecommerce app.

Current Setup

1.  Created an umbrella Helm chart for the Ecommerce application.

    -   Includes subcharts for:
        -   frontend
        -   cartservice
        -   productcatalogueservice

2.  Git commit example after chart creation:

        git commit -m "add umbrella chart for ecommerce app with frontend, cartservice and productcatalogueservice"

Useful Commands

Kind

-   Create cluster:

        kind create cluster --name ecommerce

-   Delete cluster:

        kind delete cluster --name ecommerce

kubectl

-   View contexts:

        kubectl config get-contexts

-   Delete a context:

        kubectl config delete-context <context-name>

Helm

-   Create a new chart:

        helm create ecommerce

-   Install/upgrade release:

        helm upgrade --install ecommerce ./ecommerce

Notes

-   Contexts in Kubernetes represent cluster, user, and namespace
    combinations for access configuration.
-   Kind automatically generates a kubeconfig context when a cluster is
    created.
-   Services across namespaces can communicate unless restricted by
    Network Policies.
-   This project explores concepts like multi-tenancy, API consumption,
    and B2B vs B2C models.
