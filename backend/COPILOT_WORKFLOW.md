# VinylVault Backend — Copilot Workflow
*Follow each task in order. Do not skip or combine tasks.*

---

## TASK 1 — controllers/orderController.js

Create an Express controller for VinylVault orders.
Requirements:
- Import Order model, Cart model, Product model
- placeOrder function:
  - Get shippingAddress from req.body
  - Find cart by req.userId, populate productId with title, artist, images, price
  - If cart is empty or not found, return 400 with message "Cart is empty"
  - Build order items array by snapshotting each cart item:
    - productId, title, artist, imageUrl (first element of images array), price, quantity
  - Calculate subtotal (sum of price * quantity for all items)
  - Set shipping to 0
  - Calculate total (subtotal + shipping)
  - Generate orderNumber using this logic:
    - Get current year
    - Count existing orders in DB
    - Format as ORD-YYYY-XXX (zero padded to 3 digits, e.g. ORD-2025-001)
  - Save new order with userId from req.userId, snapshotted items, shippingAddress, subtotal, shipping, total, paymentMethod "Cash on Delivery"
  - After saving, clear the cart (set items to empty array and save)
  - Return 201 with saved order

- getOrders function:
  - Find all orders where userId matches req.userId
  - Sort by createdAt descending
  - Return 200 with array of orders

- getOrderById function:
  - Find order by req.params.id AND userId matches req.userId
  - If not found return 404 with message "Order not found"
  - Return 200 with order

- Export placeOrder, getOrders, getOrderById

---

## TASK 2 — routes/orderRoutes.js

Create Express order routes for VinylVault.
Requirements:
- Import express Router
- Import placeOrder, getOrders, getOrderById from ../controllers/orderController
- Import protect from ../middleware/authMiddleware
- Apply protect middleware to all routes
- POST / → placeOrder
- GET / → getOrders
- GET /:id → getOrderById
- Export router

---

## TASK 3 — controllers/userController.js

Create an Express controller for VinylVault user profile.
Requirements:
- Import User model
- getProfile function:
  - Find user by req.userId
  - Exclude password field from result
  - If not found return 404 with message "User not found"
  - Return 200 with user

- updateProfile function:
  - Get username, phone, address from req.body
  - Find user by req.userId and update only the provided fields
  - Use findByIdAndUpdate with new:true, exclude password from result
  - Return 200 with updated user

- Export getProfile, updateProfile

---

## TASK 4 — routes/userRoutes.js

Create Express user routes for VinylVault.
Requirements:
- Import express Router
- Import getProfile, updateProfile from ../controllers/userController
- Import protect from ../middleware/authMiddleware
- Apply protect middleware to all routes
- GET /profile → getProfile
- PUT /profile → updateProfile
- Export router

---

## TASK 5 — controllers/adminController.js

Create an Express controller for VinylVault admin operations.
Requirements:
- Import Product model and Order model
- createProduct function:
  - Get all product fields from req.body: title, artist, price, genre, decade, images, condition, rating, description
  - Save new product
  - Return 201 with saved product

- updateProduct function:
  - Get product id from req.params.id
  - Find product by id and update with req.body fields
  - Use findByIdAndUpdate with new:true
  - If not found return 404 with message "Product not found"
  - Return 200 with updated product

- deleteProduct function:
  - Get product id from req.params.id
  - Find and delete product by id
  - If not found return 404 with message "Product not found"
  - Return 200 with message "Product deleted"

- updateOrderStatus function:
  - Get order id from req.params.id
  - Get status from req.body
  - Find order by id and update status
  - Use findByIdAndUpdate with new:true
  - If not found return 404 with message "Order not found"
  - Return 200 with updated order

- Export createProduct, updateProduct, deleteProduct, updateOrderStatus

---

## TASK 6 — routes/adminRoutes.js

Create Express admin routes for VinylVault.
Requirements:
- Import express Router
- Import createProduct, updateProduct, deleteProduct, updateOrderStatus from ../controllers/adminController
- No authentication middleware on any route (localhost only)
- POST /products → createProduct
- PUT /products/:id → updateProduct
- DELETE /products/:id → deleteProduct
- PUT /orders/:id/status → updateOrderStatus
- Export router

---

## TASK 7 — admin-portal/index.html

Create a standalone HTML admin portal page for VinylVault.
Requirements:
- Single HTML file, no frameworks, no build step
- Dark theme matching these colors:
  - Background: #111111
  - Surface/cards: #1A1A1A
  - Accent: #4DB8B8
  - Text primary: #F5F0E8
  - Text secondary: #B8A898
  - Border: #2A2A2A
  - Input background: #222222
- Use Google Fonts — Jost for all UI text
- Page title: VinylVault Admin Portal
- Two sections:
  1. Upload Image section:
     - File input for image selection
     - Upload button
     - On click, POST image to Cloudinary using fetch:
       URL: https://api.cloudinary.com/v1_1/CLOUD_NAME/image/upload
       Replace CLOUD_NAME with a placeholder comment <!-- REPLACE WITH YOUR CLOUD NAME -->
       Body: FormData with file and upload_preset: "vinylvault_admin"
     - Show upload status message (Uploading... / Upload successful / Upload failed)
     - After success, auto-fill the Image URL field in the product form below
     - Show a small preview of the uploaded image

  2. Add Product form with these fields:
     - Title (text input)
     - Artist (text input)
     - Price (number input)
     - Genre (select: Rock, Jazz, Hip-Hop, Electronic, Classical, Pop)
     - Decade (select: 1960s, 1970s, 1980s, 1990s, 2000s)
     - Condition (select: Mint, Near Mint, Very Good, Good, Fair)
     - Rating (number input, 0-5, step 0.1)
     - Description (textarea)
     - Image URL (text input, auto-filled after Cloudinary upload)
     - Submit button labeled "Add Product"
     - On submit, POST to http://localhost:5000/api/admin/products with all field values
     - images field must be sent as array: [imageUrl]
     - Show success message with product title on success
     - Show error message on failure
     - Clear form after successful submission

---

## TASK 8 — seed.js (in project root)

Create a seed script for VinylVault to populate the products collection.
Requirements:
- Load dotenv, import mongoose, import Product model
- Connect to MongoDB using MONGODB_URI from process.env
- Delete all existing products before seeding
- Insert exactly 15 vinyl records with realistic data covering:
  - 4 Rock albums
  - 3 Jazz albums
  - 3 Hip-Hop albums
  - 2 Electronic albums
  - 2 Classical albums
  - 1 Pop album
- Each product must have:
  - title, artist, price (between 799 and 2499 INR), genre, decade, condition, rating (between 3.5 and 5.0)
  - images: array with one placeholder URL in this format: https://placehold.co/400x400?text=AlbumTitle (replace spaces with +)
  - description: 1-2 sentences about the album
- After inserting log "Seeded X products successfully"
- Disconnect from MongoDB after seeding
- Export nothing, this is a standalone script run with: node seed.js