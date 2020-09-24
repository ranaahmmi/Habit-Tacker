import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel extends DatabaseItem {
  final String id;
  final String title;
  final String repeat;
  final String perday;
  final String dones;
  final DateTime eventDate;

  EventModel(
      {this.id,
      this.title,
      this.repeat,
      this.perday,
      this.eventDate,
      this.dones})
      : super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      repeat: data['repeat'],
      perday: data['timeInDay'],
      eventDate: data['event_date'],
      dones: data['dones'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      repeat: data['repeat'],
      perday: data['timeInDay'],
      eventDate: data['event_date'].toDate(),
      dones: data['dones'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "repeat": repeat,
      "timeInDay": perday,
      "event_date": eventDate,
      'dones': dones,
      "id": id,
    };
  }
}
