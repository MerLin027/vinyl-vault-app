const express = require("express");

const {
  createProduct,
  updateProduct,
  deleteProduct,
  updateOrderStatus,
} = require("../controllers/adminController");

const router = express.Router();

router.post("/products", createProduct);
router.put("/products/:id", updateProduct);
router.delete("/products/:id", deleteProduct);
router.put("/orders/:id/status", updateOrderStatus);

module.exports = router;
