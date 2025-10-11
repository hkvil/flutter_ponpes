# Use nginx to serve the Flutter web app
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build to nginx html directory
COPY build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 5123
EXPOSE 5123

# Start nginx
CMD ["nginx", "-g", "daemon off;"]