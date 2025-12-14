const User = require("../models/User");

exports.protect = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization || req.headers.Authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Not authorized, no token" });
    }

    const token = authHeader.split(" ")[1]; 
    const prefix = "dummy-auth-token-";
    if (!token.startsWith(prefix)) {
      return res.status(401).json({ message: "Not authorized, invalid token" });
    }

    const userId = token.substring(prefix.length);

    const user = await User.findById(userId).select("-password");
    if (!user) {
      return res.status(401).json({ message: "Not authorized, user not found" });
    }

    
    req.user = user;
    next();
  } catch (err) {
    console.error("Auth error:", err);
    return res.status(401).json({ message: "Not authorized" });
  }
};
