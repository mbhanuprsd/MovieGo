import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreManager {
  /// MOVIE BOOKMARK METHODS
  static String fsMovieBookmarkDoc = "MovieBookmarks";

  static Future<List<int>> fetchMovieBookmarks() async {
    List<int> bookMarks = new List();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs = await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentSnapshot bookmarkSnap = qs?.documents?.first;
      if (bookmarkSnap != null) {
        Map<String, dynamic> data = bookmarkSnap.data;
        if (data.containsKey(fsMovieBookmarkDoc) && data[fsMovieBookmarkDoc].toString().length > 0) {
          List<String> strings = data[fsMovieBookmarkDoc].toString().split(',').toList();
          if (strings != null && strings.length > 0) {
            bookMarks = strings.map((id) => int.parse(id)).toList();
          }
        }
      }
    }
    return bookMarks;
  }

  static Future<void> toggleMovieBookMark(int movieId) async {
    List<int> bookMarks = await fetchMovieBookmarks();

    if (bookMarks.contains(movieId)) {
      bookMarks.remove(movieId);
    } else {
      bookMarks.add(movieId);
    }

    Map<String, dynamic> bookmarkMap = new Map();
    bookmarkMap[fsMovieBookmarkDoc] = bookMarks.join(',');

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs = await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentReference bookmarkRef = qs.documents?.first?.reference;
      bookmarkRef.updateData(bookmarkMap);
    } else {
      Firestore.instance.collection(user.uid).add(bookmarkMap);
    }
  }

  static Future<bool> isMovieBookMarked(int movieId) async {
    List<int> bookMarks = await fetchMovieBookmarks();
    return bookMarks.contains(movieId);
  }

  /// PERSON BOOKMARK METHODS
  static String fsPersonBookmarkDoc = "PersonBookmarks";

  static Future<List<int>> fetchPersonBookmarks() async {
    List<int> bookMarks = new List();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs = await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentSnapshot bookmarkSnap = qs?.documents?.first;
      if (bookmarkSnap != null) {
        Map<String, dynamic> data = bookmarkSnap.data;
        if (data.containsKey(fsPersonBookmarkDoc) && data[fsPersonBookmarkDoc].toString().length > 0) {
          List<String> strings = data[fsPersonBookmarkDoc].toString().split(',').toList();
          if (strings != null && strings.length > 0) {
            bookMarks = strings.map((id) => int.parse(id)).toList();
          }
        }
      }
    }
    return bookMarks;
  }

  static Future<void> togglePersonBookMark(int personId) async {
    List<int> bookMarks = await fetchPersonBookmarks();

    if (bookMarks.contains(personId)) {
      bookMarks.remove(personId);
    } else {
      bookMarks.add(personId);
    }

    Map<String, dynamic> bookmarkMap = new Map();
    bookmarkMap[fsPersonBookmarkDoc] = bookMarks.join(',');

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs = await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentReference bookmarkRef = qs.documents?.first?.reference;
      bookmarkRef.updateData(bookmarkMap);
    } else {
      Firestore.instance.collection(user.uid).add(bookmarkMap);
    }
  }

  static Future<bool> isPersonBookMarked(int personId) async {
    List<int> bookMarks = await fetchPersonBookmarks();
    return bookMarks.contains(personId);
  }

  /// TV BOOKMARK METHODS
  static String fsTVBookmarkDoc = "TVBookmarks";

  static Future<List<int>> fetchTVBookmarks() async {
    List<int> bookMarks = new List();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs = await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentSnapshot bookmarkSnap = qs?.documents?.first;
      if (bookmarkSnap != null) {
        Map<String, dynamic> data = bookmarkSnap.data;
        if (data.containsKey(fsTVBookmarkDoc) && data[fsTVBookmarkDoc].toString().length > 0) {
          List<String> strings = data[fsTVBookmarkDoc].toString().split(',').toList();
          if (strings != null && strings.length > 0) {
            bookMarks = strings.map((id) => int.parse(id)).toList();
          }
        }
      }
    }
    return bookMarks;
  }

  static Future<void> toggleTVBookMark(int tvId) async {
    List<int> bookMarks = await fetchTVBookmarks();

    if (bookMarks.contains(tvId)) {
      bookMarks.remove(tvId);
    } else {
      bookMarks.add(tvId);
    }

    Map<String, dynamic> bookmarkMap = new Map();
    bookmarkMap[fsTVBookmarkDoc] = bookMarks.join(',');

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs = await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentReference bookmarkRef = qs.documents?.first?.reference;
      bookmarkRef.updateData(bookmarkMap);
    } else {
      Firestore.instance.collection(user.uid).add(bookmarkMap);
    }
  }

  static Future<bool> isTVBookMarked(int tvId) async {
    List<int> bookMarks = await fetchTVBookmarks();
    return bookMarks.contains(tvId);
  }
}
