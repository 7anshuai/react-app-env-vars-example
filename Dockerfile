FROM node:14-alpine AS builder
ENV NODE_ENV production
# Add a work directory
WORKDIR /app
# Cache and Install dependencies
COPY package.json .
COPY package-lock.json .
RUN npm install --production
# Copy app files
COPY . .
# Build the app
RUN npm run build

# Bundle static assets with nginx
FROM nginx:alpine as production
# Install bash
RUN apk add --no-cache bash
ENV NODE_ENV production
# Copy built assets from builder
COPY --from=builder /app/build /usr/share/nginx/html
# Add your nginx.conf template
COPY default.conf.template /etc/nginx/templates/default.conf.template
# Expose port
EXPOSE 80
# Start nginx
CMD ["nginx-debug", "-g", "daemon off;"]
