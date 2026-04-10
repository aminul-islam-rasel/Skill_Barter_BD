# Skill Barter BD - Deployment Guide

## Overview
Skill Barter BD is a credit-based skill exchange platform built with Flutter and Firebase. This guide covers deployment for Android.

## Prerequisites

### Required Tools
- Flutter SDK 3.x or later
- Firebase CLI
- Android Studio / VS Code
- Google Play Developer Account (for Play Store)

### System Requirements
- Node.js 18+
- Java JDK 17
- Android SDK 34+

## Backend Setup (Firebase)

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project: "skill-barter-bd"
3. Enable Firestore, Auth, Storage, and Messaging

### 2. Configure Authentication
- Enable Email/Password authentication
- Enable Google Sign-In
- Configure OAuth consent screen

### 3. Firestore Setup
```bash
firebase init firestore
# Select your project
# Use default rules file
```

Deploy security rules:
```bash
firebase deploy --only firestore:rules
```

### 4. Storage Setup
Deploy storage rules:
```bash
firebase deploy --only storage:rules
```

### 5. Get Configuration Files
Download `google-services.json` from Firebase Console → Project Settings → Your apps → Android

## Android Configuration

### 1. Add google-services.json
Place in: `android/app/google-services.json`

### 2. Configure AndroidManifest.xml
Add required permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 3. Configure build.gradle
Ensure correct minSdkVersion (21+ recommended)

## Flutter Build

### Development Build
```bash
flutter pub get
flutter build apk --debug
```

### Release Build
```bash
flutter build apk --release
```

### Key Configuration
- Bundle ID: `com.skillbarter.bd`
- Version: 1.0.0
- Build: 1

## Play Store Deployment

### 1. Prepare App
- Create app listing
- Add screenshots (1080x1920)
- Write privacy policy
- Set content rating

### 2. Generate Signed APK
```bash
flutter build apk --release --split-per-abi
```

### 3. App Signing
- Use Google Play App Signing
- Upload .aab or .apk file

## Architecture Overview

### Clean Architecture
```
lib/
├── core/              # Shared utilities
│   ├── constants/     # App constants
│   ├── error/         # Error handling
│   ├── local/         # Hive models
│   ├── network/       # Network utilities
│   ├── services/      # Core services
│   └── theme/         # App theme
├── config/            # Configuration
└── features/          # Feature modules
    ├── auth/          # Authentication
    ├── chat/          # Chat/Messaging
    ├── credit/        # Credit system
    ├── explore/       # Skill exploration
    ├── home/          # Home dashboard
    ├── profile/       # User profiles
    ├── rating/        # Ratings & trust
    ├── session/       # Session booking
    └── skill/         # Skill management
```

### State Management
- Riverpod for state management
- Provider pattern for dependency injection

### Backend Services
- Firebase Auth: User authentication
- Firestore: Database
- Firebase Storage: File storage
- Firebase Messaging: Push notifications

## Trust Score Formula

```
Trust Score = (rating * 0.4) + (completionRate * 0.3) + (experience * 0.1) + (verified * 0.2)
```

Where:
- rating: Average rating (0-5) → scaled to 0-40
- completionRate: Session completion percentage → 0-30
- experience: Sessions completed (max 100) → 0-10
- verified: Account verified badge → 0 or 20

## Credit System

### Session Flow
1. Learner books session → credits reserved
2. Session confirmed → credits held
3. Session completed → credits transferred to teacher
4. Session cancelled → credits released

### Transaction Rules
- All transactions via Firestore (server-side)
- Atomic operations for credit transfers
- Transaction history maintained

## Security Rules Summary

### User Data
- Profiles: Public read, owner write
- Skills: Public read, owner write
- Sessions: Participant read/write
- Transactions: Admin only write
- Ratings: Participant create, owner update

## Offline Support

### Caching Strategy
- User profiles cached in Hive
- Skills cached locally
- Pending actions stored for sync

### Sync Strategy
- Optimistic UI updates
- Queue pending actions
- Sync on connectivity restore
