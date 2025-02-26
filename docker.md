# **Docker Setup on Ubuntu**


---

## **1. Install Docker Engine**
Docker provides an official installation guide for Ubuntu. Follow the steps here:

**[Official Docker Installation Guide](https://docs.docker.com/engine/install/ubuntu/)**

---

## **2. Post-Installation Setup: Running Docker Without `sudo`**
By default, Docker requires **root** privileges. To allow your user to run Docker without `sudo`:

1. **Create the `docker` group if it doesn’t exist**:
   ```bash
   sudo groupadd docker
   ```
2. **Add your user to the `docker` group**:
   ```bash
   sudo usermod -aG docker $USER
   ```
3. **Apply group changes** (log out and log back in, or run):
   ```bash
   newgrp docker
   ```
4. **Test by running Docker without `sudo`**:
   ```bash
   docker run hello-world
   ```

 More details: [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)

---

## **3. Common Docker Commands**
Here are some essential Docker commands to get started:

### ** Basic Commands**
| Command | Description |
|---------|-------------|
| `docker --version` | Check installed Docker version. |
| `docker ps` | List running containers. |
| `docker ps -a` | List all containers (running & stopped). |
| `docker images` | List all Docker images. |
| `docker rmi <image_name_or_id>` | Remove a Docker image. |
| `docker rm <container_id>` | Remove a container. |

### ** Container Management**
| Command | Description |
|---------|-------------|
| `docker run -d --name my_container <image>` | Run a container in detached mode (background). |
| `docker run -it <image> bash` | Run a container interactively with Bash. |
| `docker exec -it <container_name> sh` | Open a shell inside a running container. |
| `docker stop <container_name>` | Stop a running container. |
| `docker start <container_name>` | Start a stopped container. |
| `docker restart <container_name>` | Restart a container. |

### ** Docker Image Management**
| Command | Description |
|---------|-------------|
| `docker pull <image>` | Download an image from Docker Hub. |
| `docker build -t my_image .` | Build a Docker image from a `Dockerfile`. |
| `docker tag my_image myrepo/my_image:v1` | Tag an image for pushing to a repository. |
| `docker push myrepo/my_image:v1` | Push an image to a repository (e.g., Docker Hub). |

### ** Cleaning Up**
| Command | Description |
|---------|-------------|
| `docker system prune -a` | Remove unused containers, networks, and images. |
| `docker volume prune` | Remove unused volumes. |

**More commands:** [Docker Cheat Sheet (PDF)](https://docs.docker.com/get-started/docker_cheatsheet.pdf)

---

## **4. Using Docker Compose**
Docker Compose allows you to define and run multi-container Docker applications.

1. Install Docker Compose (if not installed):
   ```bash
   sudo apt install docker-compose-plugin
   ```

2. Create a `docker-compose.yml` file:
   ```yaml
   version: '3'
   services:
     web:
       image: nginx
       ports:
         - "8080:80"
   ```

3. Start the services:
   ```bash
   docker compose up -d
   ```

4. Stop the services:
   ```bash
   docker compose down
   ```

More details: [Docker Compose Docs](https://docs.docker.com/compose/)

---

## **5. Troubleshooting & Logs**
If you encounter issues with Docker, use these commands to debug:

- **Check running services:**
  ```bash
  systemctl status docker
  ```
- **Restart Docker:**
  ```bash
  sudo systemctl restart docker
  ```
- **View Docker logs:**
  ```bash
  docker logs <container_name>
  ```
- **Debug networking issues:**
  ```bash
  docker network ls
  docker network inspect <network_name>
  ```

---

## **6. Uninstall Docker (If Needed)**
If you need to remove Docker from your system, run:
```bash
sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker /var/lib/containerd
```

---

