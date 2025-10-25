# 🔐 SIMONIK Mahardika - Login Credentials & Setup

## ✅ Deployment Status

**Status**: ✅ **FULLY DEPLOYED & READY TO USE**

**Live URLs**:
- **Primary**: https://simonik-mahardika1-d83bb.web.app
- **Alternative**: https://simonik-mahardika1-d83bb.firebaseapp.com
- **Local Preview**: https://5060-icki9acaef5kgbwa50sb6-2e1b9533.sandbox.novita.ai

**Last Deployed**: 2024-10-25 04:15 GMT

---

## 👥 User Accounts (Firebase Authentication)

### **Admin Account**
- **Email**: `admin.simonik@mahardika.ac.id`
- **Role**: Admin
- **Permissions**: Full Access (All Features)
  - ✅ Manage Users
  - ✅ Manage Indicators
  - ✅ Manage Monev
  - ✅ View All Reports
  - ✅ Conduct Monev
  - ✅ View Own Reports
  - ✅ Manage Settings
  - ✅ Export PDF

### **Ketua LPM Account**
- **Email**: `lpm@mahardika.ac.id`
- **Role**: Ketua LPM
- **Permissions**: Full Access (All Features)
  - ✅ Manage Users
  - ✅ Manage Indicators
  - ✅ Manage Monev
  - ✅ View All Reports
  - ✅ Conduct Monev
  - ✅ View Own Reports
  - ✅ Manage Settings
  - ✅ Export PDF

**Note**: Password sudah Anda set sendiri di Firebase Console.

---

## 🔥 Firebase Backend Status

### **Firestore Database**
✅ **Status**: Active & Populated

**Collections**:
1. **users** (2 documents)
   - admin.simonik@mahardika.ac.id (Admin)
   - lpm@mahardika.ac.id (Ketua LPM)

2. **indicator_categories** (5 documents)
   - Akademik
   - Penelitian
   - Pengabdian Masyarakat
   - Sumber Daya Manusia
   - Sarana Prasarana

3. **indicators** (8 documents)
   - 3 IKU (Indikator Kinerja Utama)
   - 5 IKT (Indikator Kinerja Tambahan)

4. **settings** (1 document)
   - Institution info
   - Theme settings

### **Authentication Methods**
✅ **Email/Password**: Enabled  
✅ **Google Sign-In**: Enabled

### **Security Rules**
Status: Development Mode (Authenticated users can read/write)

**Current Rules**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 🚀 How to Login

### **Method 1: Email/Password**
1. Open: https://simonik-mahardika1-d83bb.web.app
2. Enter email: `admin.simonik@mahardika.ac.id` or `lpm@mahardika.ac.id`
3. Enter password (yang Anda set)
4. Click "Masuk"

### **Method 2: Google Sign-In**
1. Open: https://simonik-mahardika1-d83bb.web.app
2. Click "Masuk dengan Google"
3. Select Google account: `lpm@mahardika.ac.id`
4. Authorize access

**Note**: Untuk Google Sign-In, pastikan OAuth consent screen sudah dikonfigurasi.

---

## 🎯 Testing Checklist

Setelah login, test fitur-fitur ini:

### **Dashboard**
- [ ] View statistics (Total User, Indikator, Monev)
- [ ] Quick actions accessible
- [ ] Navigation working

### **Admin Panel** (Admin & Ketua LPM only)
- [ ] Access admin dashboard
- [ ] View user management
- [ ] Add new user
- [ ] Edit user role/permissions

### **Indikator Kinerja**
- [ ] View IKU list (3 items)
- [ ] View IKT list (5 items)
- [ ] Add new indicator
- [ ] Edit indicator
- [ ] Delete indicator

### **Monitoring & Evaluasi**
- [ ] Create new Monev session
- [ ] Generate session code
- [ ] Fill evaluation form
- [ ] Select indicators (dropdown)
- [ ] Choose achievement level (Melampaui/Tercapai/Belum/Tidak)
- [ ] Add Google Drive evidence link
- [ ] Save temporarily
- [ ] Save permanently

### **Reports**
- [ ] View report dashboard
- [ ] See total score & average
- [ ] View bar chart (achievement)
- [ ] View category scores
- [ ] Export PDF

### **Settings**
- [ ] Upload logo
- [ ] Upload kop surat
- [ ] Change font
- [ ] Adjust font size
- [ ] Change theme color
- [ ] Edit institution info

---

## 🔧 Firebase Console Access

### **Quick Links**

**Project Overview**:
https://console.firebase.google.com/project/simonik-mahardika1-d83bb

**Authentication**:
https://console.firebase.google.com/project/simonik-mahardika1-d83bb/authentication/users

**Firestore Database**:
https://console.firebase.google.com/project/simonik-mahardika1-d83bb/firestore

**Hosting**:
https://console.firebase.google.com/project/simonik-mahardika1-d83bb/hosting

**Settings**:
https://console.firebase.google.com/project/simonik-mahardika1-d83bb/settings/general

---

## 👤 Adding More Users

### **Via Firebase Console**:
1. Go to: https://console.firebase.google.com/project/simonik-mahardika1-d83bb/authentication/users
2. Click "Add user"
3. Enter email and password
4. Click "Add user"

### **Via SIMONIK App** (After login as Admin/Ketua LPM):
1. Login to SIMONIK
2. Go to Admin Panel → User Management
3. Click "Tambah User"
4. Fill in: Name, Email, Role
5. Click "Simpan"

### **Sync Users to Firestore**:
After adding users in Firebase Console, run sync script:
```bash
python3 /home/user/flutter_app/scripts/sync_firebase_users.py
```

---

## 🔐 Security Recommendations

### **For Production**:

1. **Update Firestore Rules** (Role-Based Access Control):
   - Go to Firestore → Rules
   - Implement proper RBAC rules
   - Reference: `firestore.rules` file

2. **Enable App Check**:
   - Protect against abuse
   - Firebase Console → App Check

3. **Configure OAuth Consent Screen**:
   - Google Cloud Console
   - Add authorized domains
   - Set up privacy policy

4. **Enable 2FA for Admin Accounts**:
   - Firebase Console → Authentication
   - Require multi-factor authentication

5. **Review Security Rules Regularly**:
   - Audit Firestore rules
   - Check Authentication settings
   - Monitor suspicious activities

---

## 📊 Monitoring & Analytics

### **View Real-Time Users**:
Firebase Console → Analytics → Realtime

### **Track User Activity**:
Firebase Console → Analytics → Events

### **Monitor Performance**:
Firebase Console → Performance

### **View Crash Reports**:
Firebase Console → Crashlytics

---

## 🆘 Troubleshooting

### **Issue: Cannot Login**
**Solution**:
- Check email/password correct
- Verify user exists in Firebase Auth
- Check browser console for errors
- Clear browser cache

### **Issue: "Permission Denied" in Firestore**
**Solution**:
- User must be authenticated first
- Check Firestore security rules
- Verify user document exists in Firestore

### **Issue: Google Sign-In Not Working**
**Solution**:
- Enable Google Sign-In in Firebase Console
- Configure OAuth consent screen
- Add authorized domains

### **Issue: Cannot Access Admin Panel**
**Solution**:
- Only Admin and Ketua LPM can access
- Check user role in Firestore
- Verify permissions array

---

## 📝 User Roles & Permissions Matrix

| Feature | Admin | Ketua LPM | LPM | Rektor | Dekan | Kaprodi | Auditor | Auditee |
|---------|-------|-----------|-----|--------|-------|---------|---------|---------|
| Manage Users | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage Indicators | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Manage Monev | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View All Reports | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Conduct Monev | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View Own Reports | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Manage Settings | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Export PDF | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

---

## 🎉 Summary

**✅ Everything is READY!**

**Live Application**: https://simonik-mahardika1-d83bb.web.app

**Test Accounts**:
1. `admin.simonik@mahardika.ac.id` (Admin - Full Access)
2. `lpm@mahardika.ac.id` (Ketua LPM - Full Access)

**Firebase Backend**: Fully configured with sample data

**Authentication**: Email/Password & Google Sign-In enabled

**Next Steps**:
1. Login and test all features
2. Add more users as needed
3. Configure production security rules
4. Customize logo and kop surat
5. Start using for real monitoring & evaluation!

---

**Last Updated**: 2024-10-25  
**Project**: SIMONIK Mahardika  
**Institution**: Institut Teknologi dan Kesehatan Mahardika  
**Contact**: admin.simonik@mahardika.ac.id
