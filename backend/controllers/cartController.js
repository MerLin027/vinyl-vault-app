const Cart = require("../models/Cart");
const Product = require("../models/Product");

const getCart = async (req, res) => {
  try {
    const cart = await Cart.findOne({ userId: req.userId }).populate({
      path: "items.productId",
      select: "title artist images price",
    });

    if (!cart) {
      return res.status(200).json({ items: [] });
    }

    return res.status(200).json(cart);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const addToCart = async (req, res) => {
  try {
    const { productId } = req.body;
    const quantity = Number(req.body.quantity);

    if (!productId || !Number.isInteger(quantity) || quantity < 1) {
      return res.status(400).json({ message: "Invalid productId or quantity" });
    }

    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    const cart = await Cart.findOneAndUpdate(
      { userId: req.userId },
      { $setOnInsert: { userId: req.userId, items: [] } },
      { returnDocument: "after", upsert: true }
    );

    const existingItem = cart.items.find((item) => item.productId.toString() === productId);

    if (existingItem) {
      existingItem.quantity = quantity;
    } else {
      cart.items.push({ productId, quantity });
    }

    await cart.save();

    return res.status(200).json(cart);
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(404).json({ message: "Product not found" });
    }

    return res.status(500).json({ message: "Server error" });
  }
};

const updateCartItem = async (req, res) => {
  try {
    const { productId } = req.params;
    const quantity = Number(req.body.quantity);

    if (!Number.isInteger(quantity) || quantity < 1) {
      return res.status(400).json({ message: "Invalid quantity" });
    }

    const cart = await Cart.findOne({ userId: req.userId });
    if (!cart) {
      return res.status(404).json({ message: "Item not found in cart" });
    }

    const item = cart.items.find((cartItem) => cartItem.productId.toString() === productId);
    if (!item) {
      return res.status(404).json({ message: "Item not found in cart" });
    }

    item.quantity = quantity;
    await cart.save();

    return res.status(200).json(cart);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const removeCartItem = async (req, res) => {
  try {
    const { productId } = req.params;

    const cart = await Cart.findOne({ userId: req.userId });
    if (!cart) {
      return res.status(200).json({ items: [] });
    }

    cart.items.pull({ productId });
    await cart.save();

    return res.status(200).json(cart);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const clearCart = async (req, res) => {
  try {
    const cart = await Cart.findOne({ userId: req.userId });

    if (cart) {
      cart.items = [];
      await cart.save();
    }

    return res.status(200).json({ message: "Cart cleared" });
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  getCart,
  addToCart,
  updateCartItem,
  removeCartItem,
  clearCart,
};
