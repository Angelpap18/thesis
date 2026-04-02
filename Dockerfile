FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl ca-certificates git openssh-client sudo bash jq iputils-ping \
  && rm -rf /var/lib/apt/lists/*

# non-root user
RUN useradd -m -s /bin/bash op \
  && echo "op ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/op \
  && chmod 0440 /etc/sudoers.d/op

USER op
WORKDIR /home/op
ENV HOME=/home/op

# Install OpenCode
RUN curl -fsSL https://opencode.ai/install | bash
ENV PATH=/home/op/.opencode/bin:$PATH

# Copy entrypoint
COPY --chown=op:op entrypoint.sh /home/op/entrypoint.sh
RUN chmod +x /home/op/entrypoint.sh

ENTRYPOINT ["/home/op/entrypoint.sh"]
