
# Tutorial on Setting up ROS Noetic in Docker with GUI Support for RViz and Gazebo

This tutorial guides you through setting up ROS Noetic within a Docker container, enabling graphical user interface (GUI) support for tools like RViz and Gazebo. This setup uses [turludock](https://github.com/turlucode/ros-docker-gui), to simplify the process of running GUI applications for ROS docker containers .

## Pre-requisites:

- A Linux machine with sudo access.
- Docker installed and configured. You should be able to run Docker commands with `sudo` or be in the `docker` group.

## Steps:

### Step 1: Install turludock (python >= 3.9)

First, install `turludock`, a Python package that simplifies building Docker images for GUI applications.

```bash
pip install turludock
```

### Step 2: Build the Docker Image - takes 17 minutes(~6GB) size

Use `turludock` to build a Docker image pre-configured for ROS Noetic with Mesa drivers for GUI support.

```bash
turludock build -e noetic_mesa
```

This command will download and build the necessary Docker image. This might take some time.

### Step 3: Verify X Server is Running

Before running the Docker container, ensure your X server is running and accessible. Check the `$DISPLAY` environment variable:

```bash
echo $DISPLAY
```

If this command outputs something like `:0` or `:1`, your X server is likely configured correctly. If it's empty, you might need to set it manually. In most cases, `:0` is the correct value:

```bash
export DISPLAY=:0
```

### Step 4: Grant X11 Permissions on Host (If Needed)

For Docker containers to access your host's X server for GUI applications, you might need to grant X11 permissions.  **Use this command with caution as it loosens security.**  It's generally recommended for local development and testing.

```bash
xhost +local:
```

**Security Note:**  `xhost +local:` allows any local client to connect to your X server. For a more secure approach in production or shared environments, consider more specific `xhost` rules or alternative methods for X11 forwarding.

### Step 5: Get the Docker Image ID

After building the image, you need to find its ID to run a container from it. List your Docker images:

```bash
docker images
```

Look for the image you just built (likely named based on `turludock build` output) and copy its `IMAGE ID`.  You'll need this in the next step.

### Step 6: Run the Docker Container

Now, run a Docker container from the image you built. This command sets up the necessary environment variables and volume mounts for GUI support. **Replace `<docker_image_id>` with the actual Image ID you obtained in the previous step.**

```bash
docker run  --name ros_container -it \
    --env="DISPLAY=$DISPLAY" \
    --env="XDG_RUNTIME_DIR=/tmp/runtime-root" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --network=host \
    <docker_image_id>
```

**Explanation of Docker Run Options:**

-   `-it`: Runs the container in interactive mode and allocates a pseudo-TTY, allowing you to interact with the container's shell.
-   `--env="DISPLAY=$DISPLAY"`: Passes your host machine's `$DISPLAY` environment variable into the 
-   `--network=host`:  Uses the host machine's network namespace. This is often simpler for ROS setups but might have security implications in some scenarios.

### Step 7: Verify GUI - glxgears

Inside the running Docker container, verify that GUI is working by running `glxgears`.

```bash
glxgears
```

You should see a window with rotating gears if GUI support is correctly configured.

### Step 8: Verify RViz and gazebo

Now, let's verify RViz. 

Then, start `roscore` and `rviz`.

```bash
roscore & rviz
```

### step 9: Test Gazebo:

```bash
gazebo
```

RViz should launch, displaying its GUI window.

### Step 10: Install rospy inside the container

If you need to use Python ROS nodes (rospy), install `python3-rospy` inside the container:

```bash
apt update
apt install -y python3-rospy
```
### List of  useful Commands

#### **ROS Setup**
- `source /opt/ros/noetic/setup.bash`  
  *Ensure you source setup.bash in each new terminal or add it to `~/.bashrc`.*

#### [**Docker Commands**](https://docs.docker.com/get-started/docker_cheatsheet.pdf)
- `docker ps`  
  *List running containers.*
- `docker images`  
  *List all Docker images.*
- `docker rmi <image_name_or_id>`  
  *Delete a Docker image.*
- `docker exec -it <container_name> sh`  
  *Open a shell inside a running container*


Now you have a functional catkin workspace within your Docker container.

### BONUS : Developing inside docker container with VS-code : devcotainers


1.  **Install the Dev Containers extension in VS Code.**
2.  **Open your ROS project folder in VS Code.**
3.  **In VS Code, press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS) and type "Dev Containers: Reopen in Container".**

```