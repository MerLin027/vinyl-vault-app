const jwt = require("jsonwebtoken");
const BlacklistedToken = require("../models/BlacklistedToken");

const protect = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.startsWith("Bearer ")
    ? authHeader.slice(7)
    : null;

  if (!token) {
    return res.status(401).json({ message: "No token provided" });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const isBlacklisted = await BlacklistedToken.findOne({ token });
    if (isBlacklisted) {
      return res.status(401).json({ message: "Token invalidated. Please log in again." });
    }

    req.userId = decoded.id;
    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid token" });
  }
};

module.exports = protect;
