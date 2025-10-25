# Firebase Deployment Guide - SIMONIK Mahardika

## 🎯 Overview

Aplikasi SIMONIK Mahardika sudah dikonfigurasi untuk deployment ke Firebase Hosting. File konfigurasi sudah disiapkan dan aplikasi siap untuk di-deploy.

## 📦 File Konfigurasi Firebase

✅ **File yang sudah disiapkan:**
- `firebase.json` - Konfigurasi Firebase Hosting
- `.firebaserc` - Project ID configuration
- `firestore.rules` - Firestore security rules
- `firestore.indexes.json` - Firestore indexes
- `firebase_options.dart` - Multi-platform Firebase configuration

## 🔐 Firebase Project Details

**Project ID**: `simonik-mahardika1-d83bb`  
**Project URL**: https://console.firebase.google.com/project/simonik-mahardika1-d83bb  
**Web API Key**: AIzaSyDu6s32nyrttI-AKGSexTW46XaPFo6llMg

## 🚀 Deployment Steps

### Option 1: Manual Deployment (Recommended)

#### Step 1: Login to Firebase
```bash
firebase login
```

#### Step 2: Deploy to Firebase Hosting
```bash
cd /home/user/flutter_app
firebase deploy --only hosting
```

#### Step 3: Deploy Firestore Rules & Indexes
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

#### Step 4: Deploy Everything
```bash
firebase deploy
```

### Option 2: Using CI Token (for automated deployment)

#### Step 1: Generate CI Token (one-time)
```bash
firebase login:ci
```
Copy the generated token and store it securely.

#### Step 2: Deploy using Token
```bash
firebase deploy --token "$FIREBASE_TOKEN"
```

### Option 3: GitHub Actions Deployment

Create `.github/workflows/firebase-deploy.yml`:

```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.4'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build web
        run: flutter build web --release
      
      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: simonik-mahardika1-d83bb
```

## 🌐 Expected Hosting URL

After successful deployment, your app will be available at:

**Primary URL**: https://simonik-mahardika1-d83bb.web.app  
**Alternative URL**: https://simonik-mahardika1-d83bb.firebaseapp.com

## 🔄 Post-Deployment Tasks

### 1. Update Firestore Security Rules
Go to Firebase Console → Firestore Database → Rules and verify the rules are applied.

### 2. Verify Firebase Authentication
Go to Firebase Console → Authentication → Sign-in method  
Enable required authentication methods:
- ✅ Email/Password
- ✅ Google Sign-In

### 3. Configure OAuth for Google Sign-In
1. Go to Google Cloud Console: https://console.cloud.google.com/
2. Select project: simonik-mahardika1-d83bb
3. Enable Google Sign-In API
4. Add authorized domains:
   - simonik-mahardika1-d83bb.web.app
   - simonik-mahardika1-d83bb.firebaseapp.com
   - localhost (for testing)

### 4. Test the Deployed Application
1. Visit the hosting URL
2. Test user authentication
3. Verify Firebase connections
4. Test all major features

## 🗄️ Database Setup

The database has been initialized with:
- ✅ 5 Indicator Categories (Akademik, Penelitian, Pengabdian, SDM, Sarana Prasarana)
- ✅ 8 Sample Indicators (3 IKU + 5 IKT)
- ✅ App Settings (Institution info, theme settings)

To view the database:
https://console.firebase.google.com/project/simonik-mahardika1-d83bb/firestore

## 🔒 Security Considerations

### Development Mode (Current)
- Firestore rules allow all authenticated users to read/write
- **⚠️ Not suitable for production**

### Production Mode (Recommended)
Update `firestore.rules` with role-based access control:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check user role
    function isAdmin() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['Admin', 'Ketua LPM'];
    }
    
    function hasPermission(permission) {
      return permission in get(/databases/$(database)/documents/users/$(request.auth.uid)).data.permissions;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId || isAdmin();
    }
    
    // Indicators collection
    match /indicators/{indicatorId} {
      allow read: if request.auth != null;
      allow write: if hasPermission('manage_indicators');
    }
    
    // Monev sessions
    match /monev_sessions/{sessionId} {
      allow read: if request.auth != null;
      allow create: if hasPermission('manage_monev');
      allow update, delete: if hasPermission('manage_monev') || 
                               resource.data.auditor_id == request.auth.uid;
    }
    
    // Settings
    match /settings/{settingId} {
      allow read: if request.auth != null;
      allow write: if hasPermission('manage_settings');
    }
  }
}
```

## 📊 Monitoring & Analytics

### Firebase Console Dashboards
- **Hosting**: https://console.firebase.google.com/project/simonik-mahardika1-d83bb/hosting
- **Firestore**: https://console.firebase.google.com/project/simonik-mahardika1-d83bb/firestore
- **Authentication**: https://console.firebase.google.com/project/simonik-mahardika1-d83bb/authentication
- **Analytics**: https://console.firebase.google.com/project/simonik-mahardika1-d83bb/analytics

### Useful Commands

```bash
# View hosting status
firebase hosting:sites:list

# View deployment history
firebase hosting:sites:get simonik-mahardika1-d83bb

# Rollback to previous version
firebase hosting:rollback

# View Firestore data
firebase firestore:export gs://simonik-mahardika1-d83bb.appspot.com/backup

# Test security rules locally
firebase emulators:start --only firestore
```

## 🛠️ Troubleshooting

### Issue: Deployment fails with authentication error
**Solution**: Run `firebase login` again

### Issue: "Permission denied" error in Firestore
**Solution**: Update Firestore security rules in Firebase Console

### Issue: Google Sign-In not working
**Solution**: Configure OAuth consent screen and add authorized domains

### Issue: App shows blank screen
**Solution**: Check browser console for errors, verify Firebase configuration

## 📝 Build Commands Reference

```bash
# Clean build
cd /home/user/flutter_app
rm -rf build/web .dart_tool/build_cache
flutter clean

# Install dependencies
flutter pub get

# Build for web
flutter build web --release

# Test locally
cd build/web
python3 -m http.server 5060

# Deploy to Firebase
firebase deploy --only hosting
```

## 🎉 Deployment Checklist

Before deploying to production:

- [ ] Firebase project created and configured
- [ ] Firestore Database created
- [ ] Authentication methods enabled
- [ ] Security rules updated for production
- [ ] OAuth credentials configured
- [ ] App tested locally
- [ ] Build successful (flutter build web --release)
- [ ] Firebase CLI authenticated
- [ ] Deployment successful (firebase deploy)
- [ ] Live URL accessible and functional
- [ ] All features working correctly
- [ ] Security rules tested
- [ ] Analytics configured
- [ ] Backup strategy in place

## 🌐 Current Status

✅ **Backend Setup**: Complete (Firestore database initialized with sample data)  
✅ **Firebase Configuration**: Complete (firebase.json, .firebaserc, firestore.rules)  
✅ **Web Build**: Complete (build/web directory ready)  
⏳ **Firebase Deployment**: Ready to deploy (requires `firebase deploy` command)  
✅ **Local Testing**: Running at http://localhost:5060

## 🚀 Quick Deploy Command

```bash
cd /home/user/flutter_app && firebase deploy
```

After deployment, your app will be live at:
**https://simonik-mahardika1-d83bb.web.app**

---

**Last Updated**: 2024-10-25  
**Project**: SIMONIK Mahardika  
**Institution**: Institut Teknologi dan Kesehatan Mahardika
