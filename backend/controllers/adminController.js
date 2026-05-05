const Product = require("../models/Product");
const Order = require("../models/Order");

const createProduct = async (req, res) => {
  try {
    const {
      title,
      artist,
      price,
      genre,
      decade,
      images,
      condition,
      rating,
      description,
    } = req.body;

    const product = await Product.create({
      title,
      artist,
      price,
      genre,
      decade,
      images,
      condition,
      rating,
      description,
    });

    return res.status(201).json(product);
  } catch (error) {
    if (error.name === "ValidationError") {
      return res.status(400).json({ message: error.message });
    }

    return res.status(500).json({ message: "Server error" });
  }
};

const updateProduct = async (req, res) => {
  try {
    const product = await Product.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    return res.status(200).json(product);
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(404).json({ message: "Product not found" });
    }

    if (error.name === "ValidationError") {
      return res.status(400).json({ message: error.message });
    }

    return res.status(500).json({ message: "Server error" });
  }
};

const deleteProduct = async (req, res) => {
  try {
    const product = await Product.findByIdAndDelete(req.params.id);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    return res.status(200).json({ message: "Product deleted" });
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(404).json({ message: "Product not found" });
    }

    return res.status(500).json({ message: "Server error" });
  }
};

const updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;

    const order = await Order.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true, runValidators: true }
    );

    if (!order) {
      return res.status(404).json({ message: "Order not found" });
    }

    return res.status(200).json(order);
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(404).json({ message: "Order not found" });
    }

    if (error.name === "ValidationError") {
      return res.status(400).json({ message: error.message });
    }

    return res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  createProduct,
  updateProduct,
  deleteProduct,
  updateOrderStatus,
};
