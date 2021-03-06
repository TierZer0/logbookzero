import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  String currentUser;
  String currentUserName;

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    FirebaseUser user = await _auth.signInWithCredential(credential);

    updateUserData(user);

    loading.add(false);

    //print("signed in " + user.displayName);
    this.currentUserName = user.displayName;
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'name': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
  }

}

final AuthService authService = AuthService();