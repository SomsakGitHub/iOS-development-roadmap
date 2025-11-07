//🧩 1. ติดตั้ง Firebase
//
//ใน Podfile:
//
//pod 'Firebase/Database'
//pod 'Firebase/Firestore'
//pod 'Firebase/Storage'

//จากนั้นใน AppDelegate.swift:

//⚡️ Realtime Database

//ฐานข้อมูลแบบ JSON tree
//Sync ข้อมูลทันทีเมื่อมีการเปลี่ยนแปลง
//โครงสร้างคล้าย ๆ แบบนี้:

//"users": {
//  "uid123": {
//    "name": "Somsak",
//    "age": 25
//  }
//}

//✏️ เขียนข้อมูล

//import FirebaseDatabase
//
//let ref = Database.database().reference()
//
//ref.child("users").child("uid123").setValue([
//    "name": "Somsak",
//    "age": 25
//])

//📖 อ่านข้อมูล

//ref.child("users/uid123").observeSingleEvent(of: .value) { snapshot in
//    if let user = snapshot.value as? [String: Any] {
//        print("👤 User:", user)
//    }
//}

//🔁 ฟังการเปลี่ยนแปลงแบบเรียลไทม์

//ref.child("messages").observe(.childAdded) { snapshot in
//    if let message = snapshot.value as? [String: Any] {
//        print("💬 New message:", message)
//    }
//}

//✅ เหมาะกับแอป Chat, Live Feed, Realtime Dashboard

//🔥 Firestore (Cloud Firestore)
//
//ระบบใหม่กว่า Realtime DB
//ใช้โครงสร้างแบบ “Collection → Document”
//เหมาะกับแอปส่วนใหญ่ เช่น feed, user, product, post

//🔹 โครงสร้างตัวอย่าง
//users (collection)
// └── userId (document)
//      ├── name: "Somsak"
//      ├── age: 25
//      └── city: "Bangkok"

//✏️ เพิ่มหรืออัปเดตข้อมูล

//import FirebaseFirestore
//
//let db = Firestore.firestore()
//
//db.collection("users").document("uid123").setData([
//    "name": "Somsak",
//    "age": 25,
//    "city": "Bangkok"
//]) { error in
//    if let error = error {
//        print("❌ Error writing document:", error)
//    } else {
//        print("✅ Document successfully written!")
//    }
//}

//🔁 ฟังการเปลี่ยนแปลงแบบเรียลไทม์

//db.collection("messages").addSnapshotListener { snapshot, error in
//    guard let documents = snapshot?.documents else { return }
//    for doc in documents {
//        print("💬", doc.data())
//    }
//}

//🔍 Query (Filter ข้อมูล)

//db.collection("users")
//    .whereField("age", isGreaterThan: 18)
//    .getDocuments { snapshot, _ in
//        for doc in snapshot!.documents {
//            print(doc.data())
//        }
//    }

//☁️ Firebase Storage
//สำหรับเก็บไฟล์ เช่น รูปภาพ, วิดีโอ, เอกสาร
//ใช้คู่กับ Firestore เพื่อบันทึกลิงก์ของไฟล์ไว้ในฐานข้อมูล

//📤 อัปโหลดรูปภาพ

//import FirebaseStorage
//
//func uploadImage(_ image: UIImage) {
//    let storageRef = Storage.storage().reference()
//    let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
//
//    guard let data = image.jpegData(compressionQuality: 0.8) else { return }
//
//    imageRef.putData(data) { metadata, error in
//        if let error = error {
//            print("❌ Upload failed:", error)
//            return
//        }
//
//        imageRef.downloadURL { url, _ in
//            print("✅ Uploaded image URL:", url?.absoluteString ?? "")
//        }
//    }
//}

//📥 ดาวน์โหลดรูปภาพ

//let imageRef = Storage.storage().reference(withPath: "images/example.jpg")
//
//imageRef.downloadURL { url, error in
//    if let url = url {
//        print("🌐 Download URL:", url)
//    }
//}

//🧩 ตัวอย่างรวม Firestore + Storage
//
//บันทึกรูปโปรไฟล์ พร้อมชื่อผู้ใช้ใน Firestore

//func saveUserProfile(name: String, image: UIImage) {
//    let db = Firestore.firestore()
//    let storageRef = Storage.storage().reference().child("profiles/\(UUID().uuidString).jpg")
//    
//    guard let data = image.jpegData(compressionQuality: 0.8) else { return }
//    
//    storageRef.putData(data) { _, error in
//        if let error = error { print(error); return }
//        
//        storageRef.downloadURL { url, _ in
//            guard let imageURL = url?.absoluteString else { return }
//            db.collection("users").addDocument(data: [
//                "name": name,
//                "photoURL": imageURL
//            ])
//            print("✅ User saved with image!")
//        }
//    }
//}

//🚀 ตัวอย่างแอปจริง (Chat แบบ Realtime)

//struct Message: Codable {
//    let text: String
//    let sender: String
//    let timestamp: Double
//}
//
//func sendMessage(_ text: String) {
//    let message = [
//        "text": text,
//        "sender": "Somsak",
//        "timestamp": Date().timeIntervalSince1970
//    ] as [String : Any]
//    
//    let ref = Database.database().reference().child("messages").childByAutoId()
//    ref.setValue(message)
//}
//
//func listenMessages() {
//    let ref = Database.database().reference().child("messages")
//    ref.observe(.childAdded) { snapshot in
//        if let msg = snapshot.value as? [String: Any] {
//            print("💬 \(msg["sender"] ?? ""): \(msg["text"] ?? "")")
//        }
//    }
//}


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

