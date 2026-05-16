FROM node:22-slim

# Install bash (slim images come with minimal shells to ensure bash is present)
RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

RUN npm install -g @google/gemini-cli

WORKDIR /projects

CMD ["bash"]