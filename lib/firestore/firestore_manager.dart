import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreManager {
  static String FS_DOC_BOOKMARK = "Bookmarks";

  static Future<List<int>> fetchBookmarks() async {
    List<int> bookMarks = new List();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot qs =
        await Firestore.instance.collection(user.uid).getDocuments();
    DocumentSnapshot bookmarkSnap = qs.documents.first;
    Map<String, dynamic> data = bookmarkSnap.data;
    if (data.containsKey(FS_DOC_BOOKMARK)) {
      bookMarks = data[FS_DOC_BOOKMARK]
          .toString()
          .split(',')
          .toList()
          .map((id) => int.parse(id))
          .toList();
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
    DocumentReference bookmarkRef = qs.documents?.first?.reference;
    if (bookmarkRef == null) {
      Firestore.instance.collection(user.uid).add(bookmarkMap);
    } else {
      bookmarkRef.updateData(bookmarkMap);
    }
  }

  static Future<bool> isMovieBookMarked(int movieId) async {
    List<int> bookMarks = await fetchBookmarks();
    return bookMarks.contains(movieId);
  }
}
