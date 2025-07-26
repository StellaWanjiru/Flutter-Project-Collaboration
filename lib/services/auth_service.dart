import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart'; // Required for ChangeNotifier
import 'package:vroom_app/models/user_model.dart'; // Import your new VroomUser model

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  // Get the current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream to listen for authentication state changes (e.g., user logs in/out)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notify listeners if any UI depends on auth state
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Re-throw the FirebaseAuthException to be caught by the UI
      rethrow;
    } catch (e) {
      // Re-throw other exceptions
      throw Exception('An unknown error occurred during sign-in: $e');
    }
  }

  // Register with email, password, and additional user details
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
    String fullName,
    String phoneNumber,
    List<UserType> userTypes, // New parameter for user roles (using UserType enum)
  ) async {
    try {
      // 1. Create user with Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Save additional user details to Firestore
      if (userCredential.user != null) {
        // Create an initial UserProfile (can be expanded later)
        final userProfileDetails = UserProfile(
          bio: null, // No bio on registration
          location: null, // No location on registration
          specializations: [],
          certifications: [],
          businessHours: null,
          serviceRadius: null,
          preferences: {},
        );

        final vroomUser = VroomUser(
          id: userCredential.user!.uid,
          name: fullName,
          email: email,
          phone: phoneNumber,
          userTypes: userTypes,
          profile: userProfileDetails, // Assign the created UserProfile
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
          isVerified: false, // Default to false on registration
          rating: 0.0,
          reviewCount: 0,
        );

        // Save the VroomUser object to the 'users' collection
        await _firestore.collection('users').doc(userCredential.user!.uid).set(vroomUser.toFirestore());
      }

      notifyListeners(); // Notify listeners
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('An unknown error occurred during registration: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners(); // Notify listeners
  }
}