FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualización e instalación de paquetes básicos
RUN apt-get update && apt-get install -y \
    wget curl git unzip gnupg2 lsb-release software-properties-common \
    apache2 \
    postgresql \
    maven \
    openjdk-11-jre \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# .NET SDK
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update && apt-get install -y dotnet-sdk-6.0

# Visual Studio Code (opcional en contenedor, no GUI)
RUN curl -L https://update.code.visualstudio.com/latest/linux-deb-x64/stable -o vscode.deb \
    && apt install -y ./vscode.deb || true \
    && rm vscode.deb

# Copiar index.html al Apache
COPY index.html /var/www/html/index.html

# Exponer puerto Apache
EXPOSE 80

# Iniciar Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
