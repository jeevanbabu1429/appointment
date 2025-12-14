const express = require("express");
const { createSlot, getSlots } = require("../controllers/slotController");

const router = express.Router();

router.post("/", createSlot);
router.get("/", getSlots); 

module.exports = router;
