class AppConstants {
  // App Info
  static const String appName = 'Skill Barter BD';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String skillsCollection = 'skills';
  static const String sessionsCollection = 'sessions';
  static const String transactionsCollection = 'transactions';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String ratingsCollection = 'ratings';

  // Credit System
  static const int defaultCreditBalance = 50; // Starting credits for new users
  static const int minSessionCredits = 1;
  static const int maxSessionCredits = 100;
  static const int sessionDurationMinutes = 60;

  // Trust Score Calculation
  static const double trustScoreWeight = 0.4;
  static const double ratingWeight = 0.4;
  static const double completionRateWeight = 0.2;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Cache Keys
  static const String userCacheKey = 'cached_user';
  static const String skillsCacheKey = 'cached_skills';
  static const String sessionsCacheKey = 'cached_sessions';

  // Session Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Skill Levels
  static const String levelBeginner = 'Beginner';
  static const String levelIntermediate = 'Intermediate';
  static const String levelExpert = 'Expert';

  // Skill Categories (Popular in Bangladesh)
  static const List<String> skillCategories = [
    'Technology & Programming',
    'Language Learning',
    'Music & Arts',
    'Cooking & Culinary',
    'Fitness & Sports',
    'Business & Finance',
    'Design & Creative',
    'Academic Tutoring',
    'Crafts & Hobbies',
    'Other',
  ];

  // Bangladesh Locations
  static const List<String> bangladeshDistricts = [
    'Dhaka',
    'Chittagong',
    'Sylhet',
    'Rajshahi',
    'Khulna',
    'Barisal',
    'Rangpur',
    'Mymensingh',
    'Gazipur',
    'Narayanganj',
    'Other',
  ];

  // Time Slots
  static const List<String> timeSlots = [
    '06:00 AM - 07:00 AM',
    '07:00 AM - 08:00 AM',
    '08:00 AM - 09:00 AM',
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '01:00 PM - 02:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
    '07:00 PM - 08:00 PM',
    '08:00 PM - 09:00 PM',
    '09:00 PM - 10:00 PM',
  ];
}
