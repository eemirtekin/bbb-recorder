FROM docker.io/library/node:14-bullseye

RUN apt-get -y update \
    && apt-get upgrade -y \
    && apt-get install -y \
    ffmpeg \
    wget \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/*

# Install Chrome 87 (Puppeteer 2.1.1 compatible)
RUN wget -q https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_87.0.4280.88-1_amd64.deb \
    && apt-get update \
    && apt-get install -y ./google-chrome-stable_87.0.4280.88-1_amd64.deb \
    && rm google-chrome-stable_87.0.4280.88-1_amd64.deb \
    && google-chrome --version

RUN node --version && npm --version

RUN echo 'kernel.shmmax = 134217728' >> /etc/sysctl.conf \
    && echo 'kernel.shmall = 32768' >> /etc/sysctl.conf

WORKDIR /app
VOLUME /output
RUN echo "copyToPath=/output" > .env

COPY package.json ./
RUN npm install --ignore-scripts
COPY . ./