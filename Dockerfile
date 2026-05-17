FROM node:22-slim

# Install bash (slim images come with minimal shells to ensure bash is present)
RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

# Install the CLI globally as root so it's available system-wide
RUN npm install -g @google/gemini-cli

# Create the working directory and grant ownership to the 'node' user
RUN mkdir -p /projects && chown -R node:node /projects

WORKDIR /projects

# Switch from root to the non-root 'node' user
USER node

CMD ["bash"]