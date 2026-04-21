# ===============================
# STAGE 1 : BUILD (Node 20 + Angular CLI)
# ===============================
FROM node:20-alpine AS builder

WORKDIR /app

# 
COPY package.json package-lock.json ./

#
RUN npm ci --cache .npm --prefer-offline

#
COPY . .

# Build en mode production
RUN npm run build -- --configuration production

# ===============================
# STAGE 2 : SERVE (Nginx 1.27)
# ===============================
FROM nginx:1.27-alpine

# 
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# 
COPY --from=builder /app/dist/olympic-games-starter/browser /app

EXPOSE 80