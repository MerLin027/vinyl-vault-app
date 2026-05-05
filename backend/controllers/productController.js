const Product = require("../models/Product");

const getProducts = async (req, res) => {
  try {
    const { genre, decade, condition, search } = req.query;
    const filter = {};

    if (genre) {
      filter.genre = genre;
    }

    if (decade) {
      filter.decade = decade;
    }

    if (condition) {
      filter.condition = condition;
    }

    if (search) {
      filter.$text = { $search: search };
    }

    const products = await Product.find(filter);
    return res.status(200).json(products);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    return res.status(200).json(product);
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(404).json({ message: "Product not found" });
    }

    return res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  getProducts,
  getProductById,
};
