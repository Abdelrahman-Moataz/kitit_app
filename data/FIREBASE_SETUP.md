# Firebase Backend Setup Guide

This guide will help you set up Firebase for the Kitit app.

## 🔥 Firebase Setup Steps

### Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `kitit-app` (or your preferred name)
4. Disable Google Analytics (optional)
5. Click "Create project"

### Step 2: Register Your Apps

#### For Android:
1. In Firebase Console, click "Add app" → Android icon
2. Android package name: `com.yourcompany.kitit_app`
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`

#### For iOS:
1. Click "Add app" → iOS icon
2. iOS bundle ID: `com.yourcompany.kititApp`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/GoogleService-Info.plist`

#### For Web:
1. Click "Add app" → Web icon
2. Register app nickname: `kitit-web`
3. Copy the Firebase configuration
4. Create `web/firebase-config.js` (see below)

### Step 3: Enable Firebase Services

#### 1. Authentication
1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password**
3. (Optional) Enable **Google** sign-in
4. (Optional) Enable **Apple** sign-in

#### 2. Cloud Firestore
1. Go to **Firestore Database** → **Create database**
2. Start in **Test mode** (we'll add security rules later)
3. Choose location (pick closest to your users)
4. Click **Enable**

#### 3. Storage (for images)
1. Go to **Storage** → **Get started**
2. Start in **Test mode**
3. Click **Done**

### Step 4: Configure Android

1. Add Google Services plugin to `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

2. Apply plugin in `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

3. Update minimum SDK version in `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Changed from flutter.minSdkVersion
    }
}
```

### Step 5: Configure iOS

1. Open `ios/Runner.xcworkspace` in Xcode
2. Drag `GoogleService-Info.plist` into Runner folder
3. Make sure "Copy items if needed" is checked

### Step 6: Configure Web

Create `web/firebase-config.js`:

```javascript
// Replace with your Firebase config from console
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
```

Add to `web/index.html` before `</body>`:

```html
<!-- Firebase SDKs -->
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-auth-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-firestore-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-storage-compat.js"></script>
<script src="firebase-config.js"></script>
```

## 📊 Firestore Database Structure

### Collections & Documents

```
users/
  {userId}/
    - id: string
    - name: string
    - email: string
    - phone: string
    - avatarUrl: string (optional)
    - address: string (optional)
    - savedPlaces: array of restaurant IDs
    
    savedPlaces/ (subcollection)
      {restaurantId}/
        - restaurantId: string
        - savedAt: timestamp

restaurants/
  {restaurantId}/
    - id: string
    - name: string
    - cuisine: string
    - imageUrl: string
    - rating: number
    - reviewCount: number
    - priceRange: string
    - address: string
    - description: string
    - imageGallery: array
    - openingHours: map
    - amenities: array
    - isPopular: boolean
    - isTrending: boolean
    - distance: string
    
    reviews/ (subcollection)
      {reviewId}/
        - id: string
        - userName: string
        - userAvatar: string
        - rating: number
        - comment: string
        - date: timestamp
        - images: array

reservations/
  {reservationId}/
    - id: string
    - userId: string
    - restaurantId: string
    - restaurantName: string
    - restaurantImage: string
    - date: timestamp
    - time: string
    - numberOfGuests: number
    - userName: string
    - userEmail: string
    - userPhone: string
    - status: string (pending, confirmed, completed, cancelled)
    - specialRequests: string (optional)
    - totalAmount: number (optional)
```

## 🔒 Security Rules

### Firestore Rules

Go to **Firestore Database** → **Rules** and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User documents
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == userId;
      allow update: if request.auth.uid == userId;
      
      // Saved places subcollection
      match /savedPlaces/{restaurantId} {
        allow read, write: if request.auth.uid == userId;
      }
    }
    
    // Restaurant documents
    match /restaurants/{restaurantId} {
      allow read: if true;  // Public read
      allow write: if false;  // Only admins (via Firebase console or backend)
      
      // Reviews subcollection
      match /reviews/{reviewId} {
        allow read: if true;  // Public read
        allow create: if request.auth != null;
        allow update, delete: if request.auth.uid == resource.data.userId;
      }
    }
    
    // Reservation documents
    match /reservations/{reservationId} {
      allow read: if request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
      allow update: if request.auth.uid == resource.data.userId;
      allow delete: if false;  // Don't allow deletion
    }
  }
}
```

### Storage Rules

Go to **Storage** → **Rules** and paste:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Profile pictures
    match /profile_pictures/{userId}/{allPaths=**} {
      allow read: if true;  // Public read
      allow write: if request.auth.uid == userId;
    }
    
    // Restaurant images (only admins)
    match /restaurant_images/{allPaths=**} {
      allow read: if true;  // Public read
      allow write: if false;  // Only via backend
    }
  }
}
```

## 📝 Initialize Sample Data

Use Firebase Console to add sample restaurants:

### Sample Restaurant Document

```json
{
  "name": "Lumina Bistro",
  "cuisine": "Italian",
  "imageUrl": "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800",
  "rating": 4.5,
  "reviewCount": 128,
  "priceRange": "$$$",
  "address": "123 Main St, City",
  "description": "An intimate space bringing modern twists to classic Italian dishes.",
  "imageGallery": [
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800"
  ],
  "openingHours": {
    "monday": "11:00 AM - 10:00 PM",
    "tuesday": "11:00 AM - 10:00 PM",
    "wednesday": "11:00 AM - 10:00 PM",
    "thursday": "11:00 AM - 10:00 PM",
    "friday": "11:00 AM - 11:00 PM",
    "saturday": "10:00 AM - 11:00 PM",
    "sunday": "10:00 AM - 9:00 PM"
  },
  "amenities": ["Wi-Fi", "Outdoor Seating", "Parking"],
  "isPopular": true,
  "isTrending": true,
  "distance": "2.3 km"
}
```

Add 5-10 restaurants to test the app properly.

## 🚀 Run the App

```bash
# Install dependencies
flutter pub get

# Run on Android
flutter run

# Run on iOS
flutter run -d ios

# Run on Web
flutter run -d chrome
```

## ✅ Testing Firebase Integration

### Test Authentication:
1. Sign up with a new email/password
2. Check Firebase Console → Authentication → Users
3. You should see the new user

### Test Restaurant Listing:
1. Add restaurants via Firebase Console
2. Open the app
3. Restaurants should appear on home screen

### Test Saved Places:
1. Tap bookmark icon on a restaurant
2. Check Firebase Console → Firestore → users/{userId}/savedPlaces
3. Should see the saved restaurant

### Test Reservations:
1. Book a table
2. Check Firebase Console → Firestore → reservations
3. Should see the new reservation

## 🐛 Troubleshooting

**Error: "No Firebase App '[DEFAULT]' has been created"**
- Make sure `Firebase.initializeApp()` is called in `main.dart`
- Check that config files are in the correct locations

**Error: "Missing google-services.json"**
- Download from Firebase Console
- Place in `android/app/` directory

**Error: "Permission denied" in Firestore**
- Check your security rules
- Make sure user is authenticated

**Error: "Minimum SDK version"**
- Update `android/app/build.gradle` to use `minSdkVersion 21`

## 📚 Additional Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)

## 🔐 Production Checklist

Before deploying to production:

- [ ] Update security rules to production-ready rules
- [ ] Enable App Check
- [ ] Set up proper indexes for queries
- [ ] Configure Firebase billing
- [ ] Set up monitoring and alerts
- [ ] Enable Firebase Crashlytics
- [ ] Add proper error logging
- [ ] Test on multiple devices
- [ ] Set up CI/CD pipeline

---

**Your Firebase backend is ready! 🎉**
