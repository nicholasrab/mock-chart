# mock-chart

This repository contains a **Helm chart** designed to demonstrate the following concepts:

- **Blue/Green deployments** for seamless application updates
- **Active service switching** between blue and green environments
- **Ingress configuration** for easy routing of traffic
- **Horizontal Pod Autoscaling (HPA)** for automatic scaling based on traffic
- **Cost tracking** integration (with tools like Kubecost) to manage Kubernetes expenses

## Features

- **Blue/Green Deployment**: Switch between blue and green versions of your app with ease.
- **Ingress**: Easy to set up routing for the application with custom domain support.
- **Autoscaling**: Automatically scale your application based on traffic (using HPA).
- **Cost Tracking**: Integration with **Kubecost** for monitoring Kubernetes costs.
- **Simple Setup**: Use the `make` command to set up the entire environment easily.

## Quick Start

### Prerequisites

- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Installation

Clone the repository and run the `make install` command to set up the application.