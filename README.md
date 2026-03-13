
# 🛤️ Jerney — Blog Platform
# 🛡️ Jerney — DevSecOps on GCP
 
-A Gen-Z vibe blog platform built with a 3-tier architecture — React frontend, Node.js backend, and PostgreSQL database.
+> **A modern 3-tier web application deployed on Google Kubernetes Engine (GKE) Autopilot using a complete DevSecOps pipeline.**
 
-![Tech Stack](https://img.shields.io/badge/React-18-61DAFB?style=flat-square&logo=react)
-![Tech Stack](https://img.shields.io/badge/Node.js-20-339933?style=flat-square&logo=node.js)
-![Tech Stack](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=flat-square&logo=postgresql)
+This project demonstrates how to build, secure, and deploy a containerized application using **Terraform**, **GitHub Actions**, **ArgoCD**, and **Google Cloud Platform**. It integrates security checks at every stage of the pipeline (Shift-Left Security).
 
----
+![Architecture](https://img.shields.io/badge/Architecture-3--Tier-blue?style=for-the-badge)
+![Cloud](https://img.shields.io/badge/Cloud-GCP-yellow?style=for-the-badge&logo=google-cloud)
+![Infrastructure](https://img.shields.io/badge/IaC-Terraform-purple?style=for-the-badge&logo=terraform)
+![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions%20%2B%20ArgoCD-green?style=for-the-badge)
 
-> [!IMPORTANT]
-> **Looking for the full DevSecOps implementation?**
-> Switch to the [`devsecops`](../../tree/devsecops) branch for Docker, Kubernetes (GKE Auto Mode), Terraform, CI/CD with GitHub Actions, container security scanning, and more.
->
-> ```bash
-> git checkout devsecops
-> ```
-
----
-
-## ✨ Features
-
-- 📝 Create blog posts with emoji vibes
-- ✏️ Edit your existing posts
-- 🗑️ Delete posts you're not feeling anymore
-- 💬 Comment on posts
-- 🎨 Gen-Z dark UI with glassmorphism and gradients
+---
 

## 🏗️ Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Frontend   │────▶│   Backend    │────▶│  PostgreSQL   │
│   (React +   │◀────│  (Node.js +  │◀────│              │
│    Nginx)    │     │   Express)   │     │              │
│   Port 80    │     │  Port 5000   │     │  Port 5432   │
└──────────────┘     └──────────────┘     └──────────────┘
```

## Sequence Diagram

![Sequence Diagram](images/sequence_diagram.svg)

 



-## 📁 Project Structure
+## 🔐 Security Features (DevSecOps)

-```
-Jerney/
-├── frontend/                # React (Vite) frontend
-│   ├── src/                 # React components & pages
-│   ├── nginx.conf           # Nginx config for serving the app
-│   └── package.json
-├── backend/                 # Node.js Express API
-│   ├── src/                 # Routes, DB connection
-│   └── package.json
-├── deploy/                  # EC2 deployment scripts
-│   ├── setup.sh             # (Legacy) Setup script
-│   └── jerney-nginx.conf    # (Legacy) Nginx config
-└── README.md
-```
+We implement **Shift-Left Security** by scanning code and config before they reach production.

----
+1.  **Software Composition Analysis (SCA)**:
+    -   **Tool**: `npm audit`
+    -   **Purpose**: Scans `package.json` dependencies for known vulnerabilities.
+2.  **Static Application Security Testing (SAST)**:
+    -   **Tool**: `ESLint`
+    -   **Purpose**: Checks code quality and potential logic errors.
+3.  **Container Security**:
+    -   **Tool**: `Trivy`
+    -   **Purpose**: Scans Docker images for OS-level vulnerabilities (CVEs) before pushing to registry.
+    -   **Tool**: `Hadolint`
+    -   **Purpose**: Lints Dockerfiles to ensure best practices (e.g., not running as root).
+4.  **Infrastructure as Code (IaC) Security**:
+    -   **Tool**: `Checkov`
+    -   **Purpose**: Scans Terraform and Kubernetes manifests for misconfigurations (e.g., missing limits, open ports).
+5.  **Network Security**:
+    -   **Kubernetes Network Policies**: Implements a "Zero Trust" model. Traffic is denied by default and explicitly allowed only between specific components (Frontend → Backend → DB).
+6.  **GitOps & Secret Management**:
+    -   **ArgoCD**: Automated deployment ensures the cluster state matches the Git repo (preventing config drift).
+    -   **GitHub Push Protection**: Prevents committing secrets/keys to the repository.


The `deploy/setup.sh` script installs everything and configures the app automatically:

```bash
cd ~/Jerney
chmod +x deploy/setup.sh
./deploy/setup.sh
```

This script will:
1. Update system packages
2. Install **Node.js 20.x**, **PostgreSQL 16**, **Nginx**, and **PM2**
3. Create the database and user
4. Install backend dependencies
5. Build the React frontend
6. Configure Nginx as a reverse proxy
7. Start the backend with PM2 (auto-restarts on crash/reboot)

### Step 4: Access the App

Open your browser and go to:

```
http://localhost>


### Useful Commands

```bash
pm2 status                          # Check backend status
pm2 logs                            # View backend logs
pm2 restart all                     # Restart backend
sudo systemctl restart nginx        # Restart Nginx
sudo -u postgres psql -d jerney_db  # Connect to database
```

---

## 🧑‍💻 Local Development (Without Docker)

### Prerequisites

- Node.js 20+
- PostgreSQL 16+

### Backend

```bash
cd backend
npm install

# Create a .env file (or export these variables)
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=jerney_user
export DB_PASSWORD=jerney_pass_2026
export DB_NAME=jerney_db
export PORT=5000

npm start
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

The Vite dev server starts on `http://localhost:3000` and proxies `/api` requests to the backend at `http://localhost:5000`.

---

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/posts` | Get all posts |
| GET | `/api/posts/:id` | Get single post with comments |
| POST | `/api/posts` | Create a new post |
| PUT | `/api/posts/:id` | Update a post |
| DELETE | `/api/posts/:id` | Delete a post |
| GET | `/api/comments/post/:postId` | Get comments for a post |
| POST | `/api/comments` | Create a comment |
| DELETE | `/api/comments/:id` | Delete a comment |


---

## 🌿 Branch Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Source code + EC2 bare-metal deployment |
| `devops` | Full DevSecOps — Docker, Kubernetes (EKS), Terraform, CI/CD pipeline, security scanning |

---```

+### Phase 2: CI Pipeline Setup (GitHub Actions)

-### Step 4: Access the App
+1.  **Create Service Account for CI**
+    We need a Service Account that GitHub Actions can use to push images and authentication.
+    ```bash
+    # Create SA
+    gcloud iam service-accounts create github-actions-sa --display-name="GitHub Actions"

-Open your browser and go to:
+    # Grant Permissions (Artifact Registry/Storage)
+    gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member="serviceAccount:github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.admin"
+    gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member="serviceAccount:github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" --role="roles/artifactregistry.repoAdmin"
+    ```

-```
-http://localhost>
-```
+2.  **Generate JSON Key**
+    ```bash
+    gcloud iam service-accounts keys create key.json --iam-account=github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com
+    ```

-### Useful Commands
+3.  **Add Secret to GitHub**
+    -   Go to your Repo Settings -> Secrets and variables -> Actions.
+    -   New Repository Secret: `GCP_CREDENTIALS`.
+    -   Paste the content of `key.json`.
+    -   *Important: Delete `key.json` from your local machine afterwards.*

-```bash
-pm2 status                          # Check backend status
-pm2 logs                            # View backend logs
-pm2 restart all                     # Restart backend
-sudo systemctl restart nginx        # Restart Nginx
-sudo -u postgres psql -d jerney_db  # Connect to database
-```
+4.  **Enable APIs**
+    Ensure Artifact Registry API is enabled:
+    ```bash
+    gcloud services enable artifactregistry.googleapis.com
+    ```

----
+5.  **Trigger Pipeline**
+    Push any change to the repository. GitHub Actions will run Linting, Security Scans, Build, and Push the images to Google Container Registry (GCR).

-## 🧑‍💻 Local Development (Without Docker)
+### Phase 3: CD Setup (ArgoCD & GitOps)

-### Prerequisites
+1.  **Install ArgoCD**
+    ```bash
+    kubectl create namespace argocd
+    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
+    ```

-- Node.js 20+
-- PostgreSQL 16+
+2.  **Apply Application Manifest**
+    This tells ArgoCD to watch the `K8s/` folder in your repo.
+    ```bash
+    kubectl apply -f argocd-app.yaml
+    ```

-### Backend
+3.  **Monitor Deployment**
+    ArgoCD will automatically sync the manifests and deploy the Frontend, Backend, and Database pods to your GKE cluster.

-```bash
-cd backend
-npm install
+4.  **Get External IP**
+    Wait a few minutes for the Load Balancer to provision.
+    ```bash
+    kubectl get svc jerney-frontend -n jerney
+    ```
+    Visit the `EXTERNAL-IP` in your browser to see the app live!

-# Create a .env file (or export these variables)
-export DB_HOST=localhost
-export DB_PORT=5432
-export DB_USER=jerney_user
-export DB_PASSWORD=jerney_pass_2026
-export DB_NAME=jerney_db
-export PORT=5000
+---

-npm start
-```
+## 📂 Project Structure

-### Frontend
-
-```bash
-cd frontend
-npm install
-npm run dev
-```
-
-The Vite dev server starts on `http://localhost:3000` and proxies `/api` requests to the backend at `http://localhost:5000`.
-
----
-
-## 📡 API Endpoints
-
-| Method | Endpoint | Description |
-|--------|----------|-------------|
-| GET | `/api/health` | Health check |
-| GET | `/api/posts` | Get all posts |
-| GET | `/api/posts/:id` | Get single post with comments |
-| POST | `/api/posts` | Create a new post |
-| PUT | `/api/posts/:id` | Update a post |
-| DELETE | `/api/posts/:id` | Delete a post |
-| GET | `/api/comments/post/:postId` | Get comments for a post |
-| POST | `/api/comments` | Create a comment |
-| DELETE | `/api/comments/:id` | Delete a comment |
-
----
-
-## 🌿 Branch Strategy
-
-| Branch | Purpose |
-|--------|---------|
-| `main` | Source code + EC2 bare-metal deployment |
-| `devsecops` | Full DevSecOps — Docker, Kubernetes (EKS), Terraform, CI/CD pipeline, security scanning |
-
----
-
-Built with 💜 by the Jerney team. No cap, this blog platform hits different. 🛤️
+```
+Jerney-devsecops/
+├── .github/workflows/   # CI/CD Pipeline definition (ci-cd.yml)
+├── K8s/                 # Kubernetes Manifests (Deployment, Service, NetworkPolicy)
+├── terraform/           # Infrastructure as Code (GKE, VPC, NAT)
+├── backend/             # Node.js Express API source code & Dockerfile
+├── frontend/            # React source code & Dockerfile
+├── argocd-app.yaml      # GitOps Application definition
+└── docker-compose.yaml  # Local development setup
+```
