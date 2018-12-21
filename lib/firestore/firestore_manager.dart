import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreManager {
  static String FS_DOC_BOOKMARK = "Bookmarks";

  static Future<List<int>> fetchBookmarks() async {
    List<int> bookMarks = new List();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs =
        await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentSnapshot bookmarkSnap = qs?.documents?.first;
      if (bookmarkSnap != null) {
        Map<String, dynamic> data = bookmarkSnap.data;
        if (data.containsKey(FS_DOC_BOOKMARK) &&
            data[FS_DOC_BOOKMARK].toString().length > 0) {
          List<String> strings =
              data[FS_DOC_BOOKMARK].toString().split(',').toList();
          if (strings != null && strings.length > 0) {
            bookMarks = strings.map((id) => int.parse(id)).toList();
          }
        }
      }
    }
    return bookMarks;
  }

  static Future<void> toggleBookMark(int movieId) async {
    List<int> bookMarks = await fetchBookmarks();

    if (bookMarks.contains(movieId)) {
      bookMarks.remove(movieId);
    } else {
      bookMarks.add(movieId);
    }

    Map<String, dynamic> bookmarkMap = new Map();
    bookmarkMap[FS_DOC_BOOKMARK] = bookMarks.join(',');

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs =
        await Firestore.instance.collection(user.uid).getDocuments();
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentReference bookmarkRef = qs.documents?.first?.reference;
      bookmarkRef.updateData(bookmarkMap);
    } else {
      Firestore.instance.collection(user.uid).add(bookmarkMap);
    }
  }

  static Future<bool> isMovieBookMarked(int movieId) async {
    List<int> bookMarks = await fetchBookmarks();
    return bookMarks.contains(movieId);
  }
}
