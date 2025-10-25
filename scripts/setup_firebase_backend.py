#!/usr/bin/env python3
"""
Setup Firebase Backend for SIMONIK Mahardika
Creates initial database structure with sample data
"""

import sys
import os

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    import firebase_admin
    from firebase_admin import credentials, firestore
    print("✅ firebase-admin imported successfully")
except ImportError as e:
    print(f"❌ Failed to import firebase-admin: {e}")
    print("📦 INSTALLATION REQUIRED:")
    print("pip install firebase-admin==7.1.0")
    sys.exit(1)

def initialize_firebase():
    """Initialize Firebase Admin SDK"""
    try:
        admin_sdk_path = "/opt/flutter/firebase-admin-sdk.json"
        if not os.path.exists(admin_sdk_path):
            print(f"❌ Firebase Admin SDK key not found at {admin_sdk_path}")
            return None
        
        if not firebase_admin._apps:
            cred = credentials.Certificate(admin_sdk_path)
            firebase_admin.initialize_app(cred)
            print("✅ Firebase Admin SDK initialized successfully")
        
        return firestore.client()
    except Exception as e:
        print(f"❌ Failed to initialize Firebase: {e}")
        return None

def create_indicator_categories(db):
    """Create indicator categories"""
    print("\n📂 Creating Indicator Categories...")
    
    categories = [
        {
            'name': 'Akademik',
            'parent_id': None,
            'order': 1,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Penelitian',
            'parent_id': None,
            'order': 2,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Pengabdian Masyarakat',
            'parent_id': None,
            'order': 3,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Sumber Daya Manusia',
            'parent_id': None,
            'order': 4,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Sarana Prasarana',
            'parent_id': None,
            'order': 5,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
    ]
    
    for category in categories:
        doc_ref = db.collection('indicator_categories').add(category)
        print(f"  ✅ Created category: {category['name']}")
    
    print("✅ Indicator categories created successfully")

def create_indicators(db):
    """Create sample indicators"""
    print("\n📊 Creating Sample Indicators...")
    
    # Get first category ID for reference
    categories = list(db.collection('indicator_categories').limit(5).stream())
    if not categories:
        print("⚠️ No categories found, creating indicators without category reference")
        category_ids = [None] * 5
    else:
        category_ids = [cat.id for cat in categories]
    
    indicators = [
        # IKU - Indikator Kinerja Utama
        {
            'name': 'Kualitas Pembelajaran',
            'description': 'Penilaian kualitas proses pembelajaran oleh mahasiswa',
            'type': 'IKU',
            'category_id': category_ids[0] if len(category_ids) > 0 else None,
            'sub_category_id': None,
            'order': 1,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Kepuasan Mahasiswa',
            'description': 'Tingkat kepuasan mahasiswa terhadap layanan institusi',
            'type': 'IKU',
            'category_id': category_ids[0] if len(category_ids) > 0 else None,
            'sub_category_id': None,
            'order': 2,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Rasio Kelulusan Tepat Waktu',
            'description': 'Persentase mahasiswa lulus tepat waktu',
            'type': 'IKU',
            'category_id': category_ids[0] if len(category_ids) > 0 else None,
            'sub_category_id': None,
            'order': 3,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        # IKT - Indikator Kinerja Tambahan
        {
            'name': 'Publikasi Ilmiah Dosen',
            'description': 'Jumlah publikasi ilmiah dosen di jurnal terakreditasi',
            'type': 'IKT',
            'category_id': category_ids[1] if len(category_ids) > 1 else None,
            'sub_category_id': None,
            'order': 1,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Pengabdian kepada Masyarakat',
            'description': 'Kegiatan pengabdian masyarakat oleh dosen dan mahasiswa',
            'type': 'IKT',
            'category_id': category_ids[2] if len(category_ids) > 2 else None,
            'sub_category_id': None,
            'order': 2,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Kerjasama Industri',
            'description': 'Jumlah kerjasama dengan industri dan instansi',
            'type': 'IKT',
            'category_id': category_ids[1] if len(category_ids) > 1 else None,
            'sub_category_id': None,
            'order': 3,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Kompetensi Dosen',
            'description': 'Tingkat kompetensi dan kualifikasi dosen',
            'type': 'IKT',
            'category_id': category_ids[3] if len(category_ids) > 3 else None,
            'sub_category_id': None,
            'order': 4,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
        {
            'name': 'Kelengkapan Sarana Praktikum',
            'description': 'Kelengkapan dan kondisi sarana praktikum',
            'type': 'IKT',
            'category_id': category_ids[4] if len(category_ids) > 4 else None,
            'sub_category_id': None,
            'order': 5,
            'is_active': True,
            'created_at': firestore.SERVER_TIMESTAMP,
        },
    ]
    
    for indicator in indicators:
        doc_ref = db.collection('indicators').add(indicator)
        print(f"  ✅ Created indicator ({indicator['type']}): {indicator['name']}")
    
    print("✅ Sample indicators created successfully")

def create_app_settings(db):
    """Create initial app settings"""
    print("\n⚙️ Creating App Settings...")
    
    settings = {
        'institution_name': 'Institut Teknologi dan Kesehatan Mahardika',
        'institution_address': 'Cirebon, Jawa Barat',
        'logo_url': None,
        'kop_url': None,
        'font_family': 'Roboto',
        'font_size': 14.0,
        'primary_color': '#1976D2',
        'secondary_color': '#FF9800',
        'updated_at': firestore.SERVER_TIMESTAMP,
    }
    
    db.collection('settings').document('app_settings').set(settings)
    print("✅ App settings created successfully")

def setup_firestore_security_rules():
    """Print Firestore security rules setup instructions"""
    print("\n🔒 Firestore Security Rules Setup")
    print("=" * 60)
    print("Please set up the following security rules in Firebase Console:")
    print("1. Go to: https://console.firebase.google.com/")
    print("2. Select project: simonik-mahardika1-d83bb")
    print("3. Navigate: Firestore Database → Rules")
    print("4. Replace with the following rules:")
    print()
    print("rules_version = '2';")
    print("service cloud.firestore {")
    print("  match /databases/{database}/documents {")
    print("    // Allow read/write access to all authenticated users (for development)")
    print("    match /{document=**} {")
    print("      allow read, write: if request.auth != null;")
    print("    }")
    print("  }")
    print("}")
    print()
    print("⚠️ Note: These are permissive rules for development.")
    print("   For production, implement proper role-based security rules.")
    print("=" * 60)

def main():
    """Main function"""
    print("🚀 SIMONIK Mahardika - Firebase Backend Setup")
    print("=" * 60)
    
    # Initialize Firebase
    db = initialize_firebase()
    if not db:
        print("❌ Failed to initialize Firebase")
        return False
    
    try:
        # Create database structure
        create_indicator_categories(db)
        create_indicators(db)
        create_app_settings(db)
        
        # Print security rules instructions
        setup_firestore_security_rules()
        
        print("\n" + "=" * 60)
        print("✅ Firebase backend setup completed successfully!")
        print("=" * 60)
        print("\n📋 Summary:")
        print("  ✅ Indicator categories created")
        print("  ✅ Sample indicators created (IKU & IKT)")
        print("  ✅ App settings initialized")
        print("\n🔄 Next Steps:")
        print("  1. Set up Firestore security rules (see instructions above)")
        print("  2. Test the application")
        print("  3. Add more data as needed")
        print("\n🌐 Access your Firebase Console:")
        print("  https://console.firebase.google.com/project/simonik-mahardika1-d83bb")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error during setup: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
