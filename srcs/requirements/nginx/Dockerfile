FROM debian:bookworm

# Met à jour, installe nginx et openssl
RUN apt update && apt install nginx -y && apt install openssl -y

# Crée un dossier ou stocker le certificat et la clef pour la connexion sécurisé
RUN mkdir -p /etc/nginx/ssl

# Creation du certificat(openssl req) autosigné(-x509) sans mot de passe demandé(nodes)
# Validité de 365 jours(-days 365), on crée un clé avec l'algo rsa qui aura une taille de 2048 bit
# Out = destination de la certification | Keyout = destination de la clé privé
# On donne toutes les infos necessaires à la certif (sans ca un prompt s'afficherais à chaque lancement)
RUN openssl req -x509 \
	-nodes \
	-days 365 \
	-newkey rsa:2048 \
	-out /etc/ssl/certs/inception.crt \
	-keyout /etc/ssl/private/inception.key \
	-subj /C=FR/ST=RH/L=Lyon/O=42/OU=42/CN=jpiquet.42.fr

# On copy la conf qu'on a fait pour remplacer celle de nginx de base.
# COPY conf/nginx.conf /etc/nginx.conf
