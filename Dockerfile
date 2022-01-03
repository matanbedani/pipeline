ARG TAG=latest
FROM nginx:${TAG}
COPY index.html /usr/share/nginx/html