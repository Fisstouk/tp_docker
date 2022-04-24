# ---------- D�finition de l'OS ----------
FROM alpine:3.15

LABEL title="Alpine-nginx" \
    maintainer="Lyronn Levy" \
    version="1.0" \
    description="Cr�ation d'une image Docker avec Alpine, Nginx et capabilities" \
    build="24-04-2022"

# ---------- D�finition du Shell ----------
SHELL ["/bin/sh", "-c"]

# ---------- D�claration des arguments ----------
ARG USER=nginx
ARG HOME=/home/$USER


# ---------- Mise � jour ----------
RUN apk update && \
    apk add sudo

# ---------- Cr�ation du groupe et de l'utilisateur nginx ----------
RUN addgroup $USER && \ 
    adduser \
    --home $HOME \
    --ingroup $USER \
    --disabled-password \
    $USER 

RUN echo "$USER ALL=(ALL) ALL" > /etc/sudoers.d/$USER

RUN chmod 0440 /etc/sudoers.d/$USER

# ---------- Installation des programmes de base et de nginx ----------
RUN apk add nginx curl vim openrc

# ---------- D�finition du r�pertoire de travail ----------
WORKDIR $HOME
USER $USER

# ---------- Ajout d'une page HTML ----------
COPY index.html /etc/nginx/html/

# ---------- Commande par d�faut au d�marrage de Docker ----------
CMD [ "/bin/sh", "-c", "echo $HOME" ]
