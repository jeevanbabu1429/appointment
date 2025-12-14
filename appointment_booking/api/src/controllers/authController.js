const User = require("../models/User");


exports.register = async (req, res) => {
  try {
    const { name, mobile, password, email } = req.body;

    if (!name || !mobile || !password) {
      return res
        .status(400)
        .json({ message: "name, mobile and password are required" });
    }

    const existing = await User.findOne({ mobile });
    if (existing) {
      return res.status(409).json({ message: "Mobile number already registered" });
    }

    // NOTE: in real life, hash the password before saving
    const user = await User.create({ name, mobile, password, email });

    return res.status(201).json({
      message: "User registered successfully",
      user: {
        _id: user._id,
        name: user.name,
        mobile: user.mobile,
        email: user.email,
      },
    });
  } catch (err) {
    console.error("Error in register:", err);
    return res.status(500).json({ message: "Server error" });
  }
};


exports.login = async (req, res) => {
  try {
    const { mobile, password } = req.body;

    if (!mobile || !password) {
      return res
        .status(400)
        .json({ message: "mobile and password are required" });
    }

    const user = await User.findOne({ mobile });

    if (!user) {
      return res.status(401).json({ message: "Invalid mobile or password" });
    }

    if (user.password !== password) {
      return res.status(401).json({ message: "Invalid mobile or password" });
    }

    const dummyToken = `dummy-auth-token-${user._id}`;

    return res.json({
      message: "Login successful",
      token: dummyToken,
      user: {
        _id: user._id,
        name: user.name,
        mobile: user.mobile,
        email: user.email,
      },
    });
  } catch (err) {
    console.error("Error in login:", err);
    return res.status(500).json({ message: "Server error" });
  }
};

