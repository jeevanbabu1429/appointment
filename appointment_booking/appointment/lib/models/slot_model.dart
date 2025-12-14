// lib/models/slot_model.dart

class SlotModel {
  final String id;
  final String date;
  final String time;
  final bool booked;

  SlotModel({
    required this.id,
    required this.date,
    required this.time,
    required this.booked,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['_id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      booked: json['booked'] as bool? ?? false,
    );
  }
}
