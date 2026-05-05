# Vinyl Vault Server

A clean and focused backend for a vinyl record store experience.
Built with Node.js, Express, and MongoDB.

---

## Why This Project

Vinyl Vault Server powers the core e-commerce backend flows:
- user authentication
- profile management
- product browsing
- cart operations
- order placement
- basic admin product and order controls

It is designed as a straightforward API-first backend that can be paired with any frontend.

---

## Stack

- Node.js
- Express
- MongoDB + Mongoose
- JWT authentication
- bcrypt password hashing
- Cloudinary support (config present)

---

## Project Structure

```text
config/         DB and service config
controllers/    Route handlers
middleware/     Auth middleware
models/         Mongoose schemas
routes/         API routes
admin-portal/   Frontend admin static assets
seed.js         Product seed script
server.js       App entry point
```

---

## Quick Start

1. Install dependencies

```bash
npm install
```

2. Add environment variables in `.env`

```env
PORT=5000
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_super_secret_key
JWT_EXPIRES_IN=7d
```

3. Seed products (optional)

```bash
node seed.js
```

4. Start server

```bash
npm start
```

Server runs on:
- http://localhost:5000

---

## Scripts

```json
{
  "start": "node server.js"
}
```

---

## API Overview

Base URL: `/api`

### Auth
- POST `/auth/signup`
- POST `/auth/login`
- POST `/auth/logout` (protected)

### Products
- GET `/products`
- GET `/products/:id`

### Users (protected)
- GET `/users/profile`
- PUT `/users/profile`

### Cart (protected)
- GET `/cart`
- POST `/cart`
- PUT `/cart/:productId`
- DELETE `/cart/:productId`
- DELETE `/cart`

### Orders (protected)
- POST `/orders`
- GET `/orders`
- GET `/orders/:id`

### Admin
- POST `/admin/products`
- PUT `/admin/products/:id`
- DELETE `/admin/products/:id`
- PUT `/admin/orders/:id/status`

---

## Security Notes

- Passwords are stored using bcrypt hashes.
- JWT is used for authentication.
- Logged out tokens are blacklisted.

---

## Status

This repo is an active backend foundation for Vinyl Vault and is ready for continued iteration.
