FROM nginx:alpine

COPY ./company-business /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
