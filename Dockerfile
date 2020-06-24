# # stage1 as builder
# FROM node:10-alpine as builder

# # copy the package.json to install dependencies
# COPY package.json package-lock.json ./

# # Install the dependencies and make the folder
# RUN npm install && mkdir app-ui && mv ./node_modules ./app-ui

# WORKDIR /app-ui

# COPY . .

# # Build the project and copy the files
# RUN npm run ng build -- --deploy-url=/angualr-app/ --prod

# FROM nginx:alpine
# #!/bin/sh

# COPY ./nginx.conf /etc/nginx/nginx.conf


# ## Remove default nginx index page
# RUN rm -rf /usr/share/nginx/html/*

# # Copy from the stage 1
# COPY --from=builder /app-ui/dist /usr/share/nginx/html

# EXPOSE 4200 80

# ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

FROM node:alpine as build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine as prod
COPY --from=build /app/dist/angular-app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]