
import 'package:cloud_firestore/cloud_firestore.dart';

// Enum to define different user types/roles
enum UserType {
  buyer,    // Can rent/buy vehicles
  seller,   // Can list/sell vehicles
  mechanic, // Can provide vehicle services
  renter,   // Explicitly for renting (can overlap with buyer)
  owner,    // Explicitly for owning (can overlap with seller)
}

// Main User Profile Class
class VroomUser {
  final String id; // Firebase User ID (uid)
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl; // Optional profile image URL
  final List<UserType> userTypes; // List of roles the user has
  final UserProfile profile; // Nested detailed profile
  final DateTime createdAt;
  final DateTime lastActive;
  final bool isVerified;
  final double rating;
  final int reviewCount;

  VroomUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.userTypes,
    required this.profile,
    required this.createdAt,
    required this.lastActive,
    this.isVerified = false,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  // Factory constructor to create a VroomUser object from a Firestore document
  factory VroomUser.fromFirestore(Map<String, dynamic> data, String id) {
    // Convert list of strings from Firestore back to List<UserType>
    final List<String> roleStrings = List<String>.from(data['userTypes'] ?? []);
    final List<UserType> parsedUserTypes = roleStrings.map((e) {
      // Safely parse enum, default to buyer if not found or invalid
      return UserType.values.firstWhere(
        (type) => type.name == e,
        orElse: () => UserType.buyer,
      );
    }).toList();

    return VroomUser(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      userTypes: parsedUserTypes.isEmpty ? [UserType.buyer] : parsedUserTypes, // Ensure at least buyer if none selected
      profile: UserProfile.fromMap(data['profile'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
    );
  }

  // Method to convert a VroomUser object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    // Convert List<UserType> to List<String> for Firestore storage
    final List<String> userTypeStrings = userTypes.map((e) => e.name).toList();

    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'userTypes': userTypeStrings,
      'profile': profile.toMap(), // Convert nested UserProfile to map
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'isVerified': isVerified,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}

// Nested UserProfile for more detailed user information
class UserProfile {
  final String? bio;
  final String? location;
  final List<String> specializations; // For mechanics
  final List<String> certifications; // For mechanics
  final BusinessHours? businessHours; // For mechanics
  final double? serviceRadius; // For mobile mechanics
  final Map<String, dynamic> preferences; // General user preferences

  UserProfile({
    this.bio,
    this.location,
    this.specializations = const [],
    this.certifications = const [],
    this.businessHours,
    this.serviceRadius,
    this.preferences = const {},
  });

  // Factory constructor to create UserProfile from a Map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      bio: map['bio'],
      location: map['location'],
      specializations: List<String>.from(map['specializations'] ?? []),
      certifications: List<String>.from(map['certifications'] ?? []),
      businessHours: map['businessHours'] != null
          ? BusinessHours.fromMap(map['businessHours'])
          : null,
      serviceRadius: (map['serviceRadius'] as num?)?.toDouble(),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
    );
  }

  // Method to convert UserProfile to a Map
  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'location': location,
      'specializations': specializations,
      'certifications': certifications,
      'businessHours': businessHours?.toMap(),
      'serviceRadius': serviceRadius,
      'preferences': preferences,
    };
  }
}

// Nested class for Business Hours (e.g., for mechanics)
class BusinessHours {
  final Map<String, DayHours> schedule; // Map of day name to DayHours

  BusinessHours({required this.schedule});

  // Factory constructor to create BusinessHours from a Map
  factory BusinessHours.fromMap(Map<String, dynamic> map) {
    final schedule = <String, DayHours>{};
    map.forEach((key, value) {
      schedule[key] = DayHours.fromMap(value);
    });
    return BusinessHours(schedule: schedule);
  }

  // Method to convert BusinessHours to a Map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    schedule.forEach((key, value) {
      map[key] = value.toMap();
    });
    return map;
  }
}

// Nested class for hours on a specific day
class DayHours {
  final bool isOpen;
  final String? openTime; // e.g., "09:00"
  final String? closeTime; // e.g., "17:00"

  DayHours({
    required this.isOpen,
    this.openTime,
    this.closeTime,
  });

  // Factory constructor to create DayHours from a Map
  factory DayHours.fromMap(Map<String, dynamic> map) {
    return DayHours(
      isOpen: map['isOpen'] ?? false,
      openTime: map['openTime'],
      closeTime: map['closeTime'],
    );
  }

  // Method to convert DayHours to a Map
  Map<String, dynamic> toMap() {
    return {
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}