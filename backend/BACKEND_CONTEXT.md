# VinylVault Backend - Definitive Reference Guide

## 1. Architecture & Core Patterns

**Framework & Architecture**
- **Framework**: Node.js with Express.js (`express@^5.2.1`).
- **Pattern**: Layered MVC (Model-View-Controller) architecture (excluding views as this is an API).
- **Core Separation**:
  - `routes/`: Defines API endpoints and maps them to controllers.
  - `controllers/`: Contains the core business logic (handling requests/responses).
  - `models/`: Defines data schema using Mongoose for MongoDB.
  - `middleware/`: Contains custom Express middleware for request processing (e.g., authentication).
  - `config/`: Contains connection logic and environmental setup (e.g., MongoDB connection).

## 2. Tech Stack & Dependencies

- **Node.js / Express**: Fast, unopinionated web framework for the API server.
- **Mongoose (`^9.3.3`)**: Object Data Modeling (ODM) library for MongoDB. Used to define schemas and interact with the database.
- **JWT (`jsonwebtoken@^9.0.3`)**: Used for secure authentication via JSON Web Tokens.
- **Bcrypt.js (`^3.0.3`)**: Used for hashing user passwords securely before storing them in the database.
- **Cloudinary (`^2.9.0`)**: Used for cloud-based image management (likely for storing product/album cover images).
- **Cors (`^2.8.6`)**: Middleware to enable Cross-Origin Resource Sharing, allowing the frontend to communicate with the backend.
- **Dotenv (`^17.3.1`)**: Loads environment variables from a `.env` file into `process.env`.
- **Express Validator (`^7.3.1`)**: Used for validating incoming request payloads (e.g., user signup data).

## 3. Directory Structure & Flow

```
d:\vinyl-vault-server\
├── .env                  # Environment variables
├── package.json          # Project metadata and dependencies
├── server.js             # Application entry point & Express setup
├── config/
│   └── db.js             # MongoDB connection setup
├── controllers/          # Core Business Logic
│   ├── adminController.js
│   ├── authController.js
│   ├── cartController.js
│   ├── orderController.js
│   ├── productController.js
│   └── userController.js
├── middleware/           # Request Interceptors
│   └── authMiddleware.js # Protects routes using JWT
├── models/               # Database Schemas (Mongoose)
│   ├── BlacklistedToken.js
│   ├── Cart.js
│   ├── Order.js
│   ├── Product.js
│   └── User.js
└── routes/               # API Endpoint Definitions
    ├── adminRoutes.js
    ├── authRoutes.js
    ├── cartRoutes.js
    ├── orderRoutes.js
    ├── productRoutes.js
    └── userRoutes.js
```

**Flow of a Request**:
1. Request hits `server.js`.
2. Passed to the appropriate router in `routes/` (e.g., `routes/cartRoutes.js`).
3. If the route is protected, it passes through `middleware/authMiddleware.js`.
4. Handled by the relevant controller in `controllers/` (e.g., `cartController.js`).
5. The controller interacts with MongoDB via `models/` (e.g., `models/Cart.js`).
6. Response is sent back to the client.

## 4. Data Models & Integration Points

### Database Schemas (Models)
Located in `models/`:
- **User**: Stores user details (authentication, profile).
- **Product**: Represents a vinyl record (title, artist, price, image, etc.).
- **Cart**: Stores the current user's shopping cart state.
- **Order**: Represents a completed purchase/transaction.
- **BlacklistedToken**: Used to invalidate JWTs upon logout.

### Exposed API Endpoints
*Note: Routes are prefixed in `server.js`*

**Auth (`/api/auth`)** - `routes/authRoutes.js`
- `POST /signup`: Register a new user. (Public)
- `POST /login`: Authenticate and receive a JWT. (Public)
- `POST /logout`: Logout and invalidate token. (Protected via `authMiddleware.js`)

**Products (`/api/products`)** - `routes/productRoutes.js`
- `GET /`: Retrieve all products. (Public)
- `GET /:id`: Retrieve a specific product by ID. (Public)

**Cart (`/api/cart`)** - `routes/cartRoutes.js` *(All Protected)*
- `GET /`: Retrieve user's cart.
- `POST /`: Add item to cart.
- `PUT /:productId`: Update cart item quantity.
- `DELETE /:productId`: Remove item from cart.
- `DELETE /`: Clear the entire cart.

**Orders (`/api/orders`)** - `routes/orderRoutes.js` *(All Protected)*
- `POST /`: Place a new order from cart.
- `GET /`: Retrieve user's order history.
- `GET /:id`: Retrieve specific order details.

**Users (`/api/users`)** - `routes/userRoutes.js` *(All Protected)*
- `GET /profile`: Get user profile information.
- `PUT /profile`: Update user profile.

**Admin (`/api/admin`)** - `routes/adminRoutes.js` *(Assuming Admin Protected based on context)*
- `POST /products`: Create a new product.
- `PUT /products/:id`: Update a product.
- `DELETE /products/:id`: Delete a product.
- `PUT /orders/:id/status`: Update an order's status.

## 5. Development Workflow

### Running Locally
1. Ensure Node.js and MongoDB are installed (or you have a MongoDB Atlas URI).
2. Navigate to the backend directory: `cd d:\vinyl-vault-server`
3. Install dependencies: `npm install`
4. Start the server: `npm start` (Runs `node server.js` as defined in `package.json`)
5. The server will start on the port specified in `.env` (default is `5000`).
6. (Optional) You can run `node seed.js` to populate the database with initial dummy data.

### Required Environment Variables (`.env`)
To run this repository correctly, you need the following keys in your `.env` file (found in `d:\vinyl-vault-server\.env`):
- `PORT`: The port the server runs on (e.g., `5000`).
- `MONGODB_URI`: The connection string for your MongoDB instance.
- `JWT_SECRET`: Secret key for signing JSON Web Tokens.
- `JWT_EXPIRES_IN`: Duration for token validity (e.g., `7d`).
- `CLOUDINARY_CLOUD_NAME`: Your Cloudinary account cloud name.
- `CLOUDINARY_API_KEY`: Your Cloudinary API key.
- `CLOUDINARY_API_SECRET`: Your Cloudinary API secret.
