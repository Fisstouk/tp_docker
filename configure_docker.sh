#!/bin/bash

# Nom		: Installation de docker et d'un container
# Description	: Installe docker et Alpine avec Nginx grâce au Dockerfile
# Version	: 1.0
# Auteur	: Lyronn Levy
# Date		: 24/04/2022

clear

# Installation des paquets docker
echo "Installation de Docker..."
sudo apt install docker docker-compose docker.io -y

echo "Construction du conteneur"
sudo docker build . -t alpine_nginx

sudo docker images
echo "Entrez l'ID de l'image à lancer"
read IMAGE_ID 

if [ -z "$IMAGE_ID" ]
then
	echo "L'ID de l'image n'est pas renseignée"
else
	echo "Création d'un nouveau réseau puis lancement de l'image..."
fi

# Création d'un nouveau réseau où sera placé le container
echo "Création d'un nouveau réseau dans lequel l'image sera lancé..."
sudo docker network create --driver bridge \
	--subnet=192.168.1.0/24 \
       	--gateway=192.168.1.1 \
	network-nginx	

# Lancement du container
# -p : port de l'hôte 8000 vers port du conteneur 80
# Écrire -d à la place de -it pour détacher le conteneur et accéder au shell de l'hôte
echo "Lancement de l'image avec l'utilisateur nginx et un accès au shell..."
sudo docker run \
	--network=network-nginx \
	-p 8000:80 \
       	--ip 192.168.1.101 \
	-it $IMAGE_ID \
	/bin/sh 
