# Terraform for GKE Cluster Deployment with GCR Access

This Terraform configuration is designed to deploy a Google Kubernetes Engine (GKE) cluster and set up appropriate policies for students at **Enigma School** who are learning **DevOps**. The setup also includes a **Google Container Registry (GCR)** to facilitate container image building and deployment. Additionally, it creates a **Service Account and a key for GitHub Actions**, allowing students to build and push their images using GitHub Actions.

## Features

- Provision a **GKE cluster** on Google Cloud.
- Set up appropriate IAM policies to grant students access.
- Create a **Google Container Registry (GCR)** for students to push and manage container images.
- Configure the environment for seamless authentication to GCR.
- **Create a Service Account and generate a key for GitHub Actions** to enable CI/CD workflows for building and pushing images.

## Prerequisites

Before running the Terraform script, ensure you have the following:

- **Google Cloud Account** with required permissions.
- **Terraform** installed on your local machine.
- **Google Cloud SDK** installed and authenticated.
- **Docker** installed for container builds.

## Setup & Deployment

### 1. Authenticate with Google Cloud

Run the following command to authenticate your Google Cloud SDK:

```sh
 gcloud auth login
```

### 2. Initialize Terraform

```sh
 terraform init
```

This initializes the Terraform working directory and downloads necessary providers.

### 3. Review and Apply the Terraform Configuration

> Run the apply command in `gke-provisionning` and then in `gke-permissions`.

```sh
 terraform apply
```

This command deploys the GKE cluster, GCR setup, and the service account for GitHub Actions.

### 4. Retrieve Cluster Credentials

After the Terraform execution is completed, authenticate with the newly created cluster:

```sh
 gcloud container clusters get-credentials <CLUSTER_NAME> --region <REGION> --project <PROJECT_ID>
```

## Using Google Container Registry (GCR)

Once the Terraform configuration is applied, students can use GCR to build and push images to deploy applications.

### Authenticate to GCR

Run the following command to configure Docker authentication for GCR:

```sh
 gcloud auth configure-docker
```

### Build & Push a Docker Image to GCR

To build and push an image to GCR, run the following commands:

```sh
 docker build -t gcr.io/<PROJECT_ID>/my-image:latest .
 docker push gcr.io/<PROJECT_ID>/my-image:latest
```

Replace `<PROJECT_ID>` with your actual Google Cloud project ID.

## Setting up GitHub Actions for Image Building & Deployment

The Terraform configuration creates a **Service Account** with a key that can be used in GitHub Actions to authenticate and push images to GCR. To use it:

1. Retrieve the generated service account key from Terraform outputs or Google Cloud Console.
2. Add the key as a **GitHub Secret** (`GCP_SA_KEY`) in your GitHub repository.
3. Update your GitHub Actions workflow file (`.github/workflows/build.yml`) with the following steps:

```yaml
name: Build & Push Docker Image to GCR

on:
  push:
    branches:
      - main

jobs:
  build-and-push:
    name: Build and Push Docker Image
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Google Cloud authentication
        uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GCP_SERVICE_KEY }}

      - name: Configure Docker to use gcloud as a credential helper
        run: |
          gcloud auth configure-docker

      - name: Build Docker image
        run: |
          IMAGE_NAME=gcr.io/${{ secrets.GCP_PROJECT_ID }}/my-app:${{ github.sha }}
          docker build -t $IMAGE_NAME .
          echo "IMAGE_NAME=$IMAGE_NAME" >> $GITHUB_ENV

      - name: Push Docker image to GCR
        run: |
          docker push $IMAGE_NAME

      - name: Output pushed image name
        run: echo "Pushed Docker image: ${{ env.IMAGE_NAME }}"
```

## Deploying an Application to GKE

After pushing an image to GCR, you can deploy your application to the GKE cluster using a Kubernetes deployment:

1. Create a Kubernetes deployment manifest (`deployment.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: gcr.io/<PROJECT_ID>/my-image:latest
          ports:
            - containerPort: 80
```

2. Apply the deployment:

```sh
 kubectl apply -f deployment.yaml
```

3. Expose the application:

```sh
 kubectl expose deployment my-app --type=LoadBalancer --port=80
```

## Cleanup

To delete the created resources when you're done, run:

```sh
 terraform destroy -auto-approve
```

## Conclusion

This Terraform configuration simplifies the process of setting up a GKE cluster, GCR, and GitHub Actions for students at Enigma School. With this setup, students can learn how to build, push, and deploy containerized applications in a Kubernetes environment using an automated CI/CD pipeline.
