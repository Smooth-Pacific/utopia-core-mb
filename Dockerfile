# Creator:    VPR
# Created:    January 27th, 2022
# Updated:    February 9th, 2022

FROM ubuntu:20.04

# Set env to avoid user input interruption during installation
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install normal goodies
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends ssh \
                                               sudo \
                                               zsh \
                                               zsh-autosuggestions \
                                               ca-certificates \
                                               git \
                                               curl \
                                               wget \
                                               vim \
                                               tree \
                                               zip \
                                               unzip \
                                               pkg-config \
                                               m4 \
                                               libtool \
                                               automake \
                                               gnutls-bin \
                                               libmicrohttpd-dev \
                                               make \
                                               cmake \
                                               build-essential \
                                               clang \
                                               gdb \
                                               cscope \
                                               python3-dev \
                                               htop \
                                               iftop \
                                               iotop

# Change login shell to zsh
RUN chsh -s /bin/zsh $(whoami)

# Create CA-certificates
RUN update-ca-certificates

# Create utopia user && dir
ENV HOME=/home/utopia
RUN useradd -ms /bin/zsh utopia
USER utopia
WORKDIR /home/utopia

# Copy profile
COPY misc/.profile /root/.profile
COPY misc/.vimrc /root/.vimrc
COPY misc/.zshrc /root/.zshrc
