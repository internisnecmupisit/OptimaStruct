# Use an official Node.js runtime as a parent image
FROM node:slim

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to /app
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to /app
COPY . .

# Expose port 5000 for the server to listen on
EXPOSE 5000

# Start the server
CMD ["npm", "start"]