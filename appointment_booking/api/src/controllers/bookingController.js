const Slot = require("../models/Slot");
const Booking = require("../models/Booking");


exports.bookSlot = async (req, res) => {
  try {
    const { slotId } = req.body;

    const userId = req.user?._id;

    if (!slotId) {
      return res.status(400).json({ message: "slotId is required" });
    }

    if (!userId) {
      return res.status(401).json({ message: "Not authorized" });
    }

    const slot = await Slot.findById(slotId);
    if (!slot) {
      return res.status(404).json({ message: "Slot not found" });
    }

    if (slot.booked) {
      return res.status(400).json({ message: "Slot already booked" });
    }

    const existingBooking = await Booking.findOne({ slot: slotId });
    if (existingBooking) {
      return res.status(400).json({ message: "Slot already booked" });
    }

    slot.booked = true;
    await slot.save();

    const booking = await Booking.create({
      user: userId,
      slot: slotId,
      date: slot.date,
      time: slot.time,
    });

    return res.status(201).json({
      message: "Slot booked successfully",
      booking,
    });
  } catch (err) {
    console.error("Error booking slot:", err);
    return res.status(500).json({ message: "Server error" });
  }
};

exports.getBookingsForUser = async (req, res) => {
  try {
    const userId = req.user?._id;

    const bookings = await Booking.find({ user: userId })
      .populate("slot")
      .sort({ createdAt: -1 });

    return res.json(bookings);
  } catch (err) {
    console.error("Error getting bookings:", err);
    return res.status(500).json({ message: "Server error" });
  }
};
