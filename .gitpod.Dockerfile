# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-base/tags
FROM gitpod/workspace-base:latest

# Install custom tools, runtime, etc.
# base image only got `apt` as the package manager
# install-packages is a wrapper for `apt` that helps skip a few commands in the docker env.
# RUN sudo install-packages shellcheck tree llvm

# To install the Dart SDK 
USER root
RUN apt update && apt install apt-transport-https -y \
    && wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' \
    | tee /etc/apt/sources.list.d/dart_stable.list \
    && apt update \
    && apt install dart
    
# Insall flutter and dependencies
USER gitpod
RUN wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" -O - \
    | tar xpJ -C "$HOME" \
    && flutter precache && for _plat in web linux-desktop; do flutter config --enable-${_plat}; done \
    && flutter doctor
