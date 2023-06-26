import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:veo_eventos/firestore_service.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  late List<Map<String, dynamic>> events;

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

  void createEvent(Event newEvent) {
    FirestoreService.firestore.collection("events").add(newEvent.toJson()).then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  void getEvents() async {
    await FirestoreService.firestore.collection("events").get().then((event) {
      for (var doc in event.docs) {
        events.add(doc.data());
        print("${doc.id} => ${doc.data()}");
      }
    });
  }
}

class Event {
  late String name, group, description;
  late String position;
  late String startDate, termDate;
  late List<String> imagesURL;

  Event(this.name, this.group, this.description, this.position, this.startDate,
      this.termDate, this.imagesURL);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'group': group,
      'description': description,
      'position': position,
      'startDate': startDate,
      'termDate': termDate,
      'imagesURL': imagesURL,
    };
  }
}
