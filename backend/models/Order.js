const mongoose = require("mongoose");

const orderItemSchema = new mongoose.Schema(
  {
    productId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
    },
    title: {
      type: String,
      required: true,
    },
    artist: {
      type: String,
      required: true,
    },
    imageUrl: String,
    price: {
      type: Number,
      required: true,
    },
    quantity: {
      type: Number,
      required: true,
    },
  },
  { _id: false }
);

const orderSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    orderNumber: {
      type: String,
      required: true,
      unique: true,
    },
    items: [orderItemSchema],
    shippingAddress: {
      type: String,
      required: true,
    },
    subtotal: {
      type: Number,
      required: true,
    },
    shipping: {
      type: Number,
      default: 0,
    },
    total: {
      type: Number,
      required: true,
    },
    status: {
      type: String,
      enum: ["Ordered", "Processing", "Shipped", "Delivered"],
      default: "Ordered",
    },
    paymentMethod: {
      type: String,
      default: "Cash on Delivery",
    },
  },
  { timestamps: true }
);

orderSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model("Order", orderSchema);
