const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/User");
const BlacklistedToken = require("../models/BlacklistedToken");

const buildUserResponse = (user) => ({
  id: user._id,
  username: user.username,
  email: user.email,
  phone: user.phone,
  address: user.address,
});

const signToken = (userId) =>
  jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });

const signup = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ message: "Username, email, and password are required" });
    }

    const normalizedEmail = email.toLowerCase().trim();

    const existingUser = await User.findOne({ email: normalizedEmail });
    if (existingUser) {
      return res.status(400).json({ message: "Email already in use" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      username,
      email: normalizedEmail,
      password: hashedPassword,
    });

    const token = signToken(user._id);

    return res.status(201).json({
      token,
      user: buildUserResponse(user),
    });
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    const user = await User.findOne({ email: email.toLowerCase().trim() });
    if (!user) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    const token = signToken(user._id);

    return res.status(200).json({
      token,
      user: buildUserResponse(user),
    });
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

const logout = async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;

    if (!token) {
      return res.status(400).json({ message: "No token provided" });
    }

    const existingToken = await BlacklistedToken.findOne({ token });
    if (!existingToken) {
      await BlacklistedToken.create({ token });
    }

    return res.status(200).json({ message: "Logged out successfully" });
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
};

module.exports = {
  signup,
  login,
  logout,
};
