# Stage 1: Build the React app
FROM node:latest AS build

# Set the working directory inside the container
RUN wget https://github.com/VENET-TECHNOLOGIES/element-web/archive/refs/tags/v0.1.0.tar.gz
RUN tar xvf v0.1.0.tar.gz
RUN mv element-web-0.1.0 app

WORKDIR /app

RUN yarn install
RUN yarn build

COPY config.json /app/webapp/
# # Copy the rest of the application files

# # # Stage 2: Serve the React app with Nginx
FROM nginx:alpine

# # # Copy the built React app from the previous stage to the Nginx HTML directory
COPY --from=build /app/webapp /usr/share/nginx/html

# # # Copy custom Nginx configuration file, if needed (optional)
# # # COPY nginx.conf /etc/nginx/nginx.conf

# # # Expose port 80 to the outside world
EXPOSE 80

# # # Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
