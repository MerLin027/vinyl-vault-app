const Order = require("../models/Order");
const Cart = require("../models/Cart");

const getNextOrderSequenceForYear = async (year) => {
  const prefix = `ORD-${year}-`;
  const latestOrder = await Order.findOne({
    orderNumber: { $regex: `^${prefix}` },
  })
    .sort({ orderNumber: -1 })
    .select("orderNumber")
    .lean();

  if (!latestOrder) {
    return 1;
  }

  const suffix = latestOrder.orderNumber.split("-").pop();
  const parsed = Number.parseInt(suffix, 10);

  return Number.isNaN(parsed) ? 1 : parsed + 1;
};

const placeOrder = async (req, res) => {
  try {
    const { shippingAddress } = req.body;

    if (!shippingAddress) {
      return res.status(400).json({ message: "Shipping address is required" });
    }

    const cart = await Cart.findOne({ userId: req.userId }).populate({
      path: "items.productId",
      select: "title artist images price",
    });

    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ message: "Cart is empty" });
    }

    const validItems = cart.items.filter((item) => item.productId);
    if (validItems.length === 0) {
      return res.status(400).json({ message: "Cart is empty" });
    }

    const items = validItems.map((item) => ({
      productId: item.productId._id,
      title: item.productId.title,
      artist: item.productId.artist,
      imageUrl:
        item.productId.images && item.productId.images.length > 0
          ? item.productId.images[0]
          : "",
      price: item.productId.price,
      quantity: item.quantity,
    }));

    const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    const shipping = 0;
    const total = subtotal + shipping;

    const currentYear = new Date().getFullYear();
    let nextSequence = await getNextOrderSequenceForYear(currentYear);

    let order;
    for (let attempt = 0; attempt < 10; attempt += 1) {
      const orderNumber = `ORD-${currentYear}-${String(nextSequence).padStart(3, "0")}`;

      try {
        order = await Order.create({
          userId: req.userId,
          orderNumber,
          items,
          shippingAddress,
          subtotal,
          shipping,
          total,
          paymentMethod: "Cash on Delivery",
        });
        break;
      } catch (error) {
        if (error.code !== 11000) {
          throw error;
        }
        nextSequence += 1;
      }
    }

    if (!order) {
      return res.status(500).json({ message: "Unable to place order" });
    }

    cart.items = [];
    await cart.save();

    return res.status(201).json(order);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const getOrders = async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.userId }).sort({ createdAt: -1 });
    return res.status(200).json(orders);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const getOrderById = async (req, res) => {
  try {
    const order = await Order.findOne({ _id: req.params.id, userId: req.userId });

    if (!order) {
      return res.status(404).json({ message: "Order not found" });
    }

    return res.status(200).json(order);
  } catch (error) {
    if (error.name === "CastError") {
      return res.status(404).json({ message: "Order not found" });
    }

    return res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  placeOrder,
  getOrders,
  getOrderById,
};
