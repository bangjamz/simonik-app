import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore, if not create
      if (userCredential.user != null) {
        await _createUserIfNotExists(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailPassword(
    String email,
    String password,
    String name,
    String role,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _createUserInFirestore(
          userCredential.user!.uid,
          email,
          name,
          role,
        );
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Create user if not exists (for Google Sign In)
  Future<void> _createUserIfNotExists(User user) async {
    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      await _createUserInFirestore(
        user.uid,
        user.email ?? '',
        user.displayName ?? '',
        UserRole.auditee, // Default role
      );
    }
  }

  // Create user in Firestore
  Future<void> _createUserInFirestore(
    String uid,
    String email,
    String name,
    String role,
  ) async {
    final permissions = Permissions.getPermissionsByRole(role);

    final userModel = UserModel(
      id: uid,
      email: email,
      name: name,
      role: role,
      permissions: permissions,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(uid).set(userModel.toMap());
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Check if user has permission
  Future<bool> hasPermission(String uid, String permission) async {
    final userData = await getUserData(uid);
    if (userData == null) return false;
    return userData.permissions.contains(permission);
  }

  // Check if user is admin or Ketua LPM
  Future<bool> isAdminOrKetuaLPM(String uid) async {
    final userData = await getUserData(uid);
    if (userData == null) return false;
    return userData.role == UserRole.admin ||
        userData.role == UserRole.ketuaLPM;
  }
}
