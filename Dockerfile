# ---------- Stage 1: Build the Vite React application ----------
FROM node:20-alpine AS builder

# Accept build argument for API URL
ARG VITE_API_URL=http://localhost:3001

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci && npm cache clean --force

# Copy source files and build
COPY . .
ENV VITE_API_URL=${VITE_API_URL}
RUN npm run build

# ---------- Stage 2: Production runtime with Nginx ----------
FROM nginx:alpine AS runner

# Copy built application
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
