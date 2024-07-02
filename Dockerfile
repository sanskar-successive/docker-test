# Stage 1: Build the frontend
FROM node:20 AS frontend

WORKDIR /app/frontend

# Copy frontend code
RUN npm config set registry https://registry.npmjs.org/ && npm config get registry


COPY frontend/package*.json ./
RUN npm install --loglevel=verbose

COPY frontend/ ./
RUN npm run build

# Stage 2: Build the backend
FROM node:20 AS backend

WORKDIR /app/backend

# Set the npm registry
RUN npm config set registry https://registry.npmjs.org/ && npm config get registry


# Copy backend code
COPY backend/package*.json ./

# Install backend dependencies
RUN npm install --loglevel=verbose

# Copy the built frontend to the backend's public directory
COPY --from=frontend /app/frontend/build /app/backend/public

COPY backend/ ./

EXPOSE 5000

CMD ["npm", "start"]
