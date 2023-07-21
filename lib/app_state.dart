import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:veo_eventos/firestore_service.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  late List<Event> events = [];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void createEvent(name, group, description, position, startDate, termDate) {
    Event newEvent =
        Event(name, group, description, position, startDate, termDate);
    FirestoreService.firestore.collection("events").add(newEvent.toJson()).then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  void getEvents() async {
    await FirestoreService.firestore.collection("events").get().then((event) {
      events = [];
      for (var doc in event.docs) {
        Event eventObj = Event(
          doc.data()['name'],
          doc.data()['group'],
          doc.data()['description'],
          doc.data()['position'],
          doc.data()['startDate'],
          doc.data()['termDate'],
        );
        events.add(eventObj);
      }
    });
  }
}

class Event {
  late String name, group, description;
  late String position;
  late String startDate, termDate;

  Event(this.name, this.group, this.description, this.position, this.startDate,
      this.termDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'group': group,
      'description': description,
      'position': position,
      'startDate': startDate,
      'termDate': termDate,
    };
  }
}
