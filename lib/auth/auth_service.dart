import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

 class AuthService {
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
       //for login
   Future<UserCredential> signInWithEmailPass(String email, password) async {
     try {
       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
           email: email, password: password);
       _firestore.collection('Users').doc(userCredential.user!.uid).set({
         'uid': userCredential.user!.uid,
         'email': email
       });
       return userCredential;
     }
     on FirebaseAuthException catch (e) {
       throw Exception(e.code);
     }
   }
   // for new account
   Future<UserCredential> register(String email, password) async {
     try {
       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       _firestore.collection('Users').doc(userCredential.user!.uid).set({
         'uid': userCredential.user!.uid,
         'email': email
       });
       return userCredential;
     }
     on FirebaseAuthException catch (e) {
       throw Exception(e.code);
     }
   }
 }