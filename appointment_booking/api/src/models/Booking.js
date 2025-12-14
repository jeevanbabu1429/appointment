const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    slot: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Slot",
      required: true,
    },
    date: {
      type: String, 
      required: true,
    },
    time: {
      type: String, 
      required: true,
    },
  },
  { timestamps: true }
);

const Booking = mongoose.model("Booking", bookingSchema);

module.exports = Booking;
