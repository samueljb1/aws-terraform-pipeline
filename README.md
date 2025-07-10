# Proyecto DevOps - Infraestructura en AWS con Terraform y Docker

## Descripción general

Este proyecto fue desarrollado como parte de una evaluación técnica con los siguientes requerimientos:

- Crear un servicio de cómputo con SO Linux (EC2).
- Crear un servicio de base de datos (RDS PostgreSQL).
- Configurar reglas de seguridad (SSH y HTTP).
- Crear una imagen Docker personalizada.
- Montar dicha imagen en el servicio de cómputo.
- Documentar y justificar decisiones técnicas.
- Entregar mediante GitHub o en archivo comprimido.

## Arquitectura del Proyecto

```
Usuario → EC2 (Docker + Apache) ←→ RDS PostgreSQL
```

## Servicios implementados

- **EC2 (Amazon Linux)** como servicio de cómputo para alojar la imagen Docker.
- **Amazon RDS (PostgreSQL)** como base de datos relacional accesible desde la EC2.
- **Security Groups** para permitir únicamente acceso por SSH desde IP autorizada y tráfico HTTP al contenedor.
- **Docker** instalado en la instancia EC2 con una imagen personalizada basada en Ubuntu 22.04.

## Contenido de la imagen Docker personalizada

```Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget curl git unzip gnupg2 lsb-release software-properties-common \
    apache2 \
    postgresql \
    maven \
    openjdk-11-jre \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update && apt-get install -y dotnet-sdk-6.0

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

La imagen contiene todas las herramientas solicitadas:
- Git
- VS Code (CLI)
- Maven
- PostgreSQL
- Java JRE
- Apache (sirviendo un index.html)
- SDK de .NET Core 6.0

## Infraestructura como Código con Terraform

Se utilizaron scripts en Terraform para crear automáticamente los siguientes recursos:

- `aws_instance` para la EC2
- `aws_db_instance` para PostgreSQL RDS
- `aws_security_group` para definir reglas de ingreso y egreso
- `aws_key_pair` para acceso seguro por SSH

El archivo `main.tf` incluye la configuración completa y variables como tipo de instancia, credenciales de la DB y puerto de acceso.

## Despliegue automatizado con GitHub Actions

Se configuró un pipeline de CI/CD en GitHub Actions que realiza los siguientes pasos:

1. Ejecuta `terraform init` y `terraform apply -auto-approve` para crear toda la infraestructura.
2. Verifica que los recursos estén creados correctamente.
3. Muestra la IP pública de EC2 y el endpoint de RDS como *outputs*.
4. Accede a la instancia vía SSH con la clave `aws_pipeline_key` previamente generada y almacenada en GitHub Secrets.

## Justificación de las decisiones

- **EC2** fue elegido por su flexibilidad para instalar y correr contenedores Docker personalizados, ideal para entornos de pruebas.
- **RDS PostgreSQL** fue seleccionado por ser un servicio administrado y altamente disponible, eliminando la necesidad de mantenimiento del motor de base de datos.
- **Docker** permite portar el entorno sin conflictos de dependencias.
- **Terraform** asegura consistencia, reutilización y versionado de la infraestructura.
- **GitHub Actions** permite automatizar el ciclo de vida del despliegue, simplificando pruebas y actualizaciones.

## Gestión del estado (`terraform.tfstate`)

El archivo de estado se almacena localmente durante esta evaluación, ya que no fue solicitado backend remoto. Se recomienda usar un backend como S3 + DynamoDB para producción.

## Gestión del archivo `.lock.hcl`

Terraform utiliza el archivo `.terraform.lock.hcl` para fijar versiones exactas de los proveedores utilizados, asegurando que las ejecuciones futuras sean consistentes. Este archivo se debe versionar junto al resto del proyecto.

## Consideraciones

- El acceso a la EC2 fue restringido a una IP fija mediante el uso de variables.
- La clave SSH `aws_pipeline_key` fue generada localmente y fue añadida en AWS vía Terraform.
- El contenedor corre Apache exponiendo el contenido de `index.html` en el puerto 80.

## Requisitos para revisión

- Acceso a los archivos de Terraform (`main.tf`, `variables.tf`, `outputs.tf`).
- Acceso a la imagen Docker publicada (opcional, ya que fue construida directamente en EC2).
- Instrucciones claras para ejecutar el proyecto de manera manual o automática.

## Autor

Desarrollado por Samuel Blanco - julio 2025

---

**Nota:** Este proyecto fue probado utilizando una cuenta gratuita de AWS.
