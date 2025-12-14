// src/models/Slot.js
const mongoose = require("mongoose");

const slotSchema = new mongoose.Schema(
  {
    date: {
      type: String, 
      required: [true, "Date is required"],
    },
    time: {
      type: String, 
      required: [true, "Time is required"],
    },
    booked: {
      type: Boolean,
      default: false, 
    },
  },
  { timestamps: true }
);

const Slot = mongoose.model("Slot", slotSchema);

module.exports = Slot;
