#!/usr/bin/env python3
"""
Sync Firebase Auth Users to Firestore
Creates user documents in Firestore for existing Firebase Auth users
"""

import sys
import os

try:
    import firebase_admin
    from firebase_admin import credentials, auth, firestore
    print("✅ firebase-admin imported successfully")
except ImportError as e:
    print(f"❌ Failed to import firebase-admin: {e}")
    sys.exit(1)

def initialize_firebase():
    """Initialize Firebase Admin SDK"""
    try:
        admin_sdk_path = "/opt/flutter/firebase-admin-sdk.json"
        if not os.path.exists(admin_sdk_path):
            print(f"❌ Firebase Admin SDK key not found")
            return None, None
        
        if not firebase_admin._apps:
            cred = credentials.Certificate(admin_sdk_path)
            firebase_admin.initialize_app(cred)
            print("✅ Firebase Admin SDK initialized")
        
        return auth, firestore.client()
    except Exception as e:
        print(f"❌ Failed to initialize Firebase: {e}")
        return None, None

def get_auth_users(auth_client):
    """Get all users from Firebase Authentication"""
    try:
        print("\n📋 Fetching users from Firebase Authentication...")
        users = []
        page = auth_client.list_users()
        
        while page:
            for user in page.users:
                users.append({
                    'uid': user.uid,
                    'email': user.email,
                    'display_name': user.display_name or user.email.split('@')[0],
                    'provider': 'google' if any(p.provider_id == 'google.com' for p in user.provider_data) else 'password',
                    'created_at': user.user_metadata.creation_timestamp / 1000 if user.user_metadata.creation_timestamp else None,
                })
                print(f"  ✅ Found user: {user.email}")
            
            page = page.get_next_page()
        
        print(f"\n✅ Total users found: {len(users)}")
        return users
    except Exception as e:
        print(f"❌ Error fetching users: {e}")
        return []

def assign_user_role(email):
    """Assign role based on email"""
    email_lower = email.lower()
    
    if 'admin' in email_lower:
        return 'Admin', [
            'manage_users',
            'manage_indicators',
            'manage_monev',
            'view_all_reports',
            'conduct_monev',
            'view_own_reports',
            'manage_settings',
            'export_pdf',
        ]
    elif 'lpm' in email_lower:
        return 'Ketua LPM', [
            'manage_users',
            'manage_indicators',
            'manage_monev',
            'view_all_reports',
            'conduct_monev',
            'view_own_reports',
            'manage_settings',
            'export_pdf',
        ]
    elif 'rektor' in email_lower:
        return 'Rektor', [
            'conduct_monev',
            'view_all_reports',
            'view_own_reports',
            'export_pdf',
        ]
    elif 'dekan' in email_lower:
        return 'Dekan', [
            'conduct_monev',
            'view_own_reports',
            'export_pdf',
        ]
    elif 'kaprodi' in email_lower:
        return 'Kaprodi', [
            'conduct_monev',
            'view_own_reports',
            'export_pdf',
        ]
    else:
        return 'Auditee', ['view_own_reports']

def sync_users_to_firestore(db, users):
    """Create/update user documents in Firestore"""
    try:
        print("\n📝 Syncing users to Firestore...")
        
        for user in users:
            role, permissions = assign_user_role(user['email'])
            
            user_doc = {
                'email': user['email'],
                'name': user['display_name'],
                'role': role,
                'permissions': permissions,
                'is_active': True,
                'created_at': firestore.SERVER_TIMESTAMP,
            }
            
            # Check if user document already exists
            doc_ref = db.collection('users').document(user['uid'])
            existing_doc = doc_ref.get()
            
            if existing_doc.exists:
                print(f"  ℹ️  User exists, updating: {user['email']} (Role: {role})")
                # Update only if needed
                doc_ref.update({
                    'name': user_doc['name'],
                    'role': role,
                    'permissions': permissions,
                    'is_active': True,
                })
            else:
                print(f"  ✅ Creating user: {user['email']} (Role: {role})")
                doc_ref.set(user_doc)
        
        print(f"\n✅ Successfully synced {len(users)} users to Firestore")
        return True
    except Exception as e:
        print(f"❌ Error syncing users: {e}")
        import traceback
        traceback.print_exc()
        return False

def display_users_summary(db):
    """Display summary of users in Firestore"""
    try:
        print("\n" + "="*60)
        print("📊 FIRESTORE USERS SUMMARY")
        print("="*60)
        
        users = db.collection('users').stream()
        user_list = []
        
        for user in users:
            user_data = user.to_dict()
            user_list.append({
                'id': user.id,
                'email': user_data.get('email', 'N/A'),
                'name': user_data.get('name', 'N/A'),
                'role': user_data.get('role', 'N/A'),
            })
        
        if not user_list:
            print("\n⚠️  No users found in Firestore")
            return
        
        print(f"\nTotal Users: {len(user_list)}\n")
        
        for idx, user in enumerate(user_list, 1):
            print(f"{idx}. Email: {user['email']}")
            print(f"   Name: {user['name']}")
            print(f"   Role: {user['role']}")
            print(f"   UID: {user['id'][:20]}...")
            print()
        
        print("="*60)
    except Exception as e:
        print(f"❌ Error displaying summary: {e}")

def main():
    """Main function"""
    print("🔄 SIMONIK - Sync Firebase Auth to Firestore")
    print("="*60)
    
    # Initialize Firebase
    auth_client, db = initialize_firebase()
    if not auth_client or not db:
        return False
    
    try:
        # Get users from Firebase Auth
        users = get_auth_users(auth_client)
        if not users:
            print("\n⚠️  No users found in Firebase Authentication")
            print("💡 Please add users via Firebase Console first")
            return False
        
        # Sync users to Firestore
        if sync_users_to_firestore(db, users):
            # Display summary
            display_users_summary(db)
            
            print("\n" + "="*60)
            print("✅ Sync completed successfully!")
            print("="*60)
            print("\n🔄 Next Steps:")
            print("  1. Users can now login to SIMONIK app")
            print("  2. Admin and Ketua LPM have full access")
            print("  3. Other users have role-based access")
            print("\n🌐 Access Firebase Console:")
            print("  https://console.firebase.google.com/project/simonik-mahardika1-d83bb")
            
            return True
        else:
            return False
        
    except Exception as e:
        print(f"\n❌ Error during sync: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
