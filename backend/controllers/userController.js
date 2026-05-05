const User = require("../models/User");

const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password");

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    return res.status(200).json(user);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const updateProfile = async (req, res) => {
  try {
    const { username, phone, address } = req.body;
    const updates = {};

    if (username !== undefined) {
      updates.username = username;
    }

    if (phone !== undefined) {
      updates.phone = phone;
    }

    if (address !== undefined) {
      updates.address = address;
    }

    const user = await User.findByIdAndUpdate(req.userId, updates, {
      new: true,
    }).select("-password");

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    return res.status(200).json(user);
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  getProfile,
  updateProfile,
};
