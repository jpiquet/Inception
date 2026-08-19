FROM debian:bookworm

# Met à jour, installe nginx et openssl
RUN apt update && apt install nginx -y && apt install openssl -y

# Crée un dossier ou stocker le certificat et la clef pour la connexion sécurisé
RUN mkdir -p /etc/ssl

# On copy la conf qu'on a fait pour remplacer celle de nginx de base.
COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]