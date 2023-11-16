FROM ubuntu:jammy-20220531

RUN apt update && \
        apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev libgmp3-dev tar clang bsdmainutils ncdu unzip llvm libudev-dev make protobuf-compiler -y && \
        apt clean && \
        rm -rf /var/lib/apt/lists/*

EXPOSE 30334 30344 9955

WORKDIR node

RUN wget -O tangle https://github.com/webb-tools/tangle/releases/download/v5.0.0/tangle-standalone-linux-amd64 && mv tangle /usr/local/bin/tangle && chmod +x /usr/local/bin/tangle

COPY docker/docker_entrypoint.sh /node/docker_entrypoint.sh
RUN chmod +x /node/docker_entrypoint.sh

ENTRYPOINT ["./docker_entrypoint.sh"]

