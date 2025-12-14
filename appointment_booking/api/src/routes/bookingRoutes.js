const express = require("express");
const { bookSlot, getBookingsForUser } = require("../controllers/bookingController");
const { protect } = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/", protect, bookSlot);

router.get("/me", protect, getBookingsForUser);

module.exports = router;
