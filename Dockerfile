FROM nginx:alpine

# RUN apk update && apk add --no-cache stress-ng

RUN apk add --no-cache stress-ng

# increase cpu usage to 100% in 120s
# docker exec -it [container_name] stress-ng --cpu 0 --timeout 120s

COPY company-business /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
