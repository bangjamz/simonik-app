# 🚀 Deploy SIMONIK via Firebase Console (Drag & Drop)

## 📦 File yang Sudah Disiapkan

✅ **File Build**: `/home/user/flutter_app/simonik-web-build.zip` (11 MB)  
✅ **Berisi**: Seluruh aplikasi web yang siap di-deploy

---

## 🎯 Langkah-langkah Deploy

### **Step 1: Download File Build**

Download file zip yang sudah dibuat:
- **Location**: `/home/user/flutter_app/simonik-web-build.zip`
- **Size**: 11 MB
- **Contents**: Folder `build/web` dengan semua file aplikasi

### **Step 2: Buka Firebase Console**

1. Buka browser dan kunjungi:
   ```
   https://console.firebase.google.com/project/simonik-mahardika1-d83bb/hosting
   ```

2. Atau navigasi manual:
   - Buka: https://console.firebase.google.com/
   - Pilih project: **simonik-mahardika1-d83bb**
   - Klik menu **Hosting** di sidebar kiri

### **Step 3: Deploy via Drag & Drop**

Ada **2 cara** di Firebase Console:

#### **Cara A: Get Started (Jika Belum Ada Site)**

1. Klik tombol **"Get started"**
2. Ikuti wizard setup:
   - Install Firebase CLI? → **Skip** (kita pakai drag & drop)
   - Deploy your site → Klik **"Continue to console"**
3. Klik tombol **"Add another site"** atau **"Deploy"**

#### **Cara B: Deploy to Existing Site**

1. Di halaman Hosting, klik tab **"Releases"**
2. Klik tombol **"Create new release"** atau **"Deploy to existing site"**
3. Pilih site: **simonik-mahardika1-d83bb**

### **Step 4: Upload Files**

Anda akan melihat area upload dengan 2 opsi:

#### **Option A: Upload Folder** (Recommended)
1. **Extract** file `simonik-web-build.zip` di komputer Anda
2. Buka folder hasil extract → masuk ke folder **`build/web`**
3. **Drag & drop** seluruh isi folder `build/web` ke area upload Firebase Console
   - ⚠️ **PENTING**: Upload ISI folder `build/web`, BUKAN folder `build/web` itu sendiri
   - Harus upload: `index.html`, `main.dart.js`, folder `assets/`, dll

#### **Option B: Upload Zip** (Alternative)
1. Jika Firebase Console support zip upload:
2. Drag & drop file **`simonik-web-build.zip`** langsung
3. Firebase akan extract otomatis

### **Step 5: Review & Deploy**

1. Tunggu proses upload selesai (progress bar)
2. Firebase akan show preview file yang akan di-deploy
3. Verify bahwa file `index.html` ada di root
4. Klik tombol **"Deploy"** atau **"Publish"**
5. Tunggu proses deployment (biasanya 1-2 menit)

### **Step 6: Akses Aplikasi**

Setelah deployment selesai, aplikasi akan available di:

**Primary URL**: https://simonik-mahardika1-d83bb.web.app  
**Alternative URL**: https://simonik-mahardika1-d83bb.firebaseapp.com

🎉 **Selesai!** Aplikasi SIMONIK Mahardika sudah live di internet!

---

## 🗂️ Struktur File yang Harus Di-Upload

Pastikan struktur file di Firebase Hosting seperti ini:

```
/ (root)
├── index.html              ← Main HTML file
├── main.dart.js            ← Compiled Dart code
├── flutter.js              ← Flutter runtime
├── flutter_bootstrap.js    ← Bootstrap script
├── flutter_service_worker.js
├── manifest.json
├── version.json
├── favicon.png
├── assets/                 ← Assets folder
│   ├── assets/
│   │   └── images/
│   ├── fonts/
│   ├── packages/
│   └── AssetManifest.json
├── canvaskit/              ← Canvas rendering
│   ├── canvaskit.js
│   └── canvaskit.wasm
└── icons/                  ← App icons
    ├── Icon-192.png
    └── Icon-512.png
```

⚠️ **CRITICAL**: File `index.html` **HARUS** berada di root (level paling atas), bukan di dalam subfolder!

---

## ❌ Common Errors & Solutions

### **Error: "Invalid hosting configuration"**
**Cause**: Upload folder `build` atau `build/web` sebagai folder, bukan isinya  
**Solution**: Upload **ISI** dari `build/web`, bukan foldernya

### **Error: "index.html not found"**
**Cause**: Structure tidak benar  
**Solution**: Pastikan `index.html` ada di root level

### **Error: "Blank page after deployment"**
**Cause**: Firebase configuration issue  
**Solution**: Check browser console for errors, verify Firebase config

---

## 🔄 Update/Redeploy Aplikasi

Jika ingin update aplikasi nanti:

1. Build ulang aplikasi:
   ```bash
   cd /home/user/flutter_app
   flutter build web --release
   zip -r simonik-web-build-v2.zip build/web
   ```

2. Download file zip baru
3. Kembali ke Firebase Console → Hosting
4. Klik **"Deploy"** atau **"Create new release"**
5. Upload file baru
6. Deploy!

---

## 📊 Monitoring & Rollback

### **View Deployment History**
- Firebase Console → Hosting → Releases tab
- Anda bisa lihat semua deployment history

### **Rollback ke Version Sebelumnya**
- Klik icon **⋮** (three dots) di release yang lama
- Pilih **"Roll back"**
- Confirm rollback

### **View Traffic & Analytics**
- Firebase Console → Hosting → Usage tab
- Lihat visitor count, bandwidth usage, dll

---

## 🎯 Alternative: Firebase CLI (Advanced)

Jika Anda familiar dengan command line, bisa juga pakai Firebase CLI:

```bash
# Install Firebase CLI (if not installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Deploy
cd /home/user/flutter_app
firebase deploy --only hosting
```

---

## 📝 Post-Deployment Checklist

Setelah deploy berhasil:

- [ ] Buka URL aplikasi dan verify loading
- [ ] Test login functionality
- [ ] Test Firebase connection (check browser console)
- [ ] Test create/read data from Firestore
- [ ] Verify all pages accessible
- [ ] Test on mobile devices
- [ ] Configure custom domain (optional)

---

## 🌐 Custom Domain (Optional)

Jika ingin menggunakan domain sendiri (misal: simonik.mahardika.ac.id):

1. Firebase Console → Hosting → "Add custom domain"
2. Enter your domain name
3. Follow DNS verification steps
4. Add A/CNAME records to your DNS provider
5. Wait for SSL certificate provisioning (24-48 hours)

---

## 💡 Tips & Best Practices

✅ **Always test locally first** before deploying  
✅ **Use release builds** for production (`flutter build web --release`)  
✅ **Monitor deployment logs** for errors  
✅ **Keep deployment history** for rollback capability  
✅ **Enable Analytics** to track usage  
✅ **Set up custom domain** for professional look  
✅ **Configure caching** for better performance  

---

## 🆘 Need Help?

**Firebase Documentation**:  
https://firebase.google.com/docs/hosting

**Firebase Console**:  
https://console.firebase.google.com/project/simonik-mahardika1-d83bb

**Project Support**:  
Check README.md for detailed app documentation

---

**Last Updated**: 2024-10-25  
**File**: simonik-web-build.zip (11 MB)  
**Project**: SIMONIK Mahardika  
**Institution**: Institut Teknologi dan Kesehatan Mahardika
