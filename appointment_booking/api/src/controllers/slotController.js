const Slot = require("../models/Slot");


exports.createSlot = async (req, res) => {
  try {
    const { date, time, booked } = req.body;

    if (!date || !time) {
      return res
        .status(400)
        .json({ message: "date and time are required" });
    }

    const slot = await Slot.create({
      date,                  
      time,                
      booked: booked ?? false,
    });

    return res.status(201).json({
      message: "Slot created successfully",
      slot,
    });
  } catch (err) {
    console.error("Error creating slot:", err);
    return res.status(500).json({ message: "Server error" });
  }
};


exports.getSlots = async (req, res) => {
  try {
    const { date } = req.query;

    const filter = {  };

    if (date) {
      filter.date = date; 
    }

    const slots = await Slot.find(filter).sort({ time: 1 });

    return res.json(slots);
  } catch (err) {
    console.error("Error getting slots:", err);
    return res.status(500).json({ message: "Server error" });
  }
};
