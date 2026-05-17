# AI Toolbox: Gemini CLI via Docker

An isolated, zero-dependency local development environment for running the Google Gemini CLI. This configuration allows you to interact with Gemini and process local project files without polluting your host machine with Node.js global packages or runtime dependencies.

---

## Prerequisites

Before getting started, ensure you have the following installed on your host machine:

* **Git** (Core version control)
* **Docker Desktop** or **Docker Engine** (20.10.0+)
* **Docker Compose** (V2 preferred)

---

## Folder Structure

Your toolbox setup should match the following arrangement:

```text
ai-toolbox-docker/
├── Dockerfile
├── docker-compose.yml
├── .env
└── .gitignore
```

---

## Setup & Configuration

### 1. Environment Configuration

The Gemini CLI requires an API key to authenticate requests with Google's LLM engines.

1. Navigate to [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account and click **Get API Key**.
3. Create a new key.
4. Create a `.env` file in the root of your `ai-toolbox-docker` directory and add your key:
   ```env
   GEMINI_API_KEY=AIzaSyYourActualKeyGoesHere...
   ```

> ⚠️ **Security Note:** The `.env` file must be listed in your `.gitignore` to prevent leaking your credentials.

### 2. Configure the Project Workspace

Open `docker-compose.yml` and locate the `volumes` block. Replace the placeholder path with the absolute path to your real project folder on your host machine. 

Depending on your Operating System, look at these standard target examples:

#### macOS Example
If your project is an API service named `billing-service` located in your developer folder:
```yaml
volumes:
  - "/Users/yourusername/Developer/billing-service:/projects"
```

#### Linux Example
If your project is a frontend app named `e-commerce-dashboard` in your home projects directory:
```yaml
volumes:
  - "/home/yourusername/projects/e-commerce-dashboard:/projects"
```

#### Windows Example
If your project is a Python tool named `data-processor` located in your user profile:
```yaml
volumes:
  - "C:/Users/yourusername/Workspace/data-processor:/projects"
```

This mapping allows the containerized Gemini CLI to read from and write directly to your actual source code files on your host machine.

---

## Usage & Execution

### Step 1: Start the Container Environment
Run the following command to boot up your isolated container environment and access its bash terminal shell:

#### For Linux Users
On native Linux, you must pass your system's exact User and Group IDs so that files created by the container are owned by your host user:

```bash
HOST_UID=$(id -u) HOST_GID=$(id -g) docker compose run --rm gemini-cli-toolbox
```

#### For macOS and Windows Users
Docker Desktop automatically translates file permissions via its virtual file system layer. You do not need to pass any host IDs; simply run the standard command:

```bash
docker compose run --rm gemini-cli-toolbox
```

#### Command Breakdown: Why these flags matter
* `docker compose run`: Instead of `up` (which boots services in the background), `run` spins up a specific service and immediately attaches your current terminal window to its environment.
* `--rm`: **Critical for hygiene.** This tells Docker to automatically delete the container instance the moment you exit. Without this, your disk space will slowly get consumed by dead, stopped containers every time you run a query.
* `stdin_open: true` & `tty: true` (configured in compose): These mimic a real terminal emulator inside the container, allowing you to type commands and receive real-time colorized terminal outputs.

### Step 2: Validate the Installation
Once inside the container's bash prompt (`root@container:/projects#`), verify that the binary is compiled and accessible:

```bash
gemini --version
```

### Step 3: Turn on/Launch the Gemini CLI
To activate and initialize the interactive Gemini CLI workspace session (the AI agent loop environment), execute:

```bash
gemini
```

> 💡 **Tip:** Once the interactive loop is live, you can type your prompts directly, run built-in slash commands, or toggle to the direct container environment shell by typing `!` inside the prompt.

---

## Exiting and Cleanup

### 1. Close the Gemini CLI & Exit the Container
To exit the interactive Gemini CLI prompt back to the container's standard bash shell, type `/exit` or press `Ctrl + C`.

To close the container shell completely and drop back down to your host machine terminal, run:

```bash
exit
```
*Because you used the `--rm` flag, the container gracefully destroys itself upon exit.*

### 2. Full System Cleanup
If you modify your `Dockerfile` (e.g., changing the base image) or simply want to purge cached layers to clear disk space, execute:

```bash
# Stops container remnants and removes networks created by Compose
docker compose down

# Purges the cached image to force a fresh rebuild next time
docker compose down --rmi all
```