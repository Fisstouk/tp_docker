#!/bin/bash

# Nom		: Installation de Harbor et de Trivy 
# Description	: Installe Harbor 2.5.0 et Trivy pour détecter les failles des conteneurs 
# Version	: 0.1
# Auteur	: Lyronn Levy
# Date		: 21/04/2022

clear

# À commenter pour installer Harbor dans un autre répertoire
echo "Installation de Harbor dans /home/$USER"
cd /home/$USER

# Installation en ligne
wget https://github.com/goharbor/harbor/releases/download/v2.5.0/harbor-online-installer-v2.5.0.tgz

# Signature gpg
wget https://github.com/goharbor/harbor/releases/download/v2.5.0/harbor-online-installer-v2.5.0.tgz.asc

# Téléchargement du Hash
wget https://github.com/goharbor/harbor/releases/download/v2.5.0/md5sum

# Installation de gpg
sudo apt install gpg -y

# Récupération des clés gpg
sudo gpg --keyserver hkps://keyserver.ubuntu.com --receive-keys 644FF454C0B4115C

# Vérification de la signature
gpg -v --keyserver hkps://keyserver.ubuntu.com --verify harbor-online-installer-v2.5.0.tgz.asc

# Vérification du hash
md5sum -c md5sum

# Décompression du fichier d'installation
tar xzvf harbor-online-installer-v2.5.0.tgz

# Suppression des fichiers
rm harbor-online-installer-v2.5.0.tgz
rm harbor-online-installer-v2.5.0.tgz.asc
rm md5sum

cd harbor/
cp harbor.yml.tmpl harbor.yml

# Modifie le nom de l'hôte
sed -i "s/reg.mydomain.com/$USER.harbor.local/" harbor.yml

# Empêche la connexion en https
sed -i 's/https/##https/' harbor.yml
sed -i 's/port: 443/##port: 443/' harbor.yml
sed -i 's/certificate:/##certificate/' harbor.yml
sed -i 's/private_key:/##private_key:/' harbor.yml

sudo ./install.sh --with-trivy
