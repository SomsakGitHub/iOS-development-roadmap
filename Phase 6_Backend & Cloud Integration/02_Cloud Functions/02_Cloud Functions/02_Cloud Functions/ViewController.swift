//☁️ Firebase Cloud Functions — สรุปเข้าใจง่าย
//
//💡 คือ “โค้ดฝั่ง Server” ที่รันอัตโนมัติบน Firebase
//เขียนด้วย JavaScript / TypeScript แล้ว deploy ไปยัง Google Cloud
//ใช้ได้กับทุกบริการใน Firebase เช่น Auth, Firestore, Storage, Analytics, Messaging

//⚙️ เริ่มต้นใช้งาน
//ติดตั้ง Firebase Tools
//npm install -g firebase-tools
//
//
//เข้าสู่ระบบ
//firebase login
//
//
//สร้างโปรเจกต์
//firebase init functions

//เลือก:
//
//Language → TypeScript
//Use ESLint → up to you
//Install dependencies → Yes

//📦 โครงสร้างไฟล์หลังจาก init
//functions/
// ├── src/
// │   └── index.ts      // เขียนฟังก์ชันที่นี่
// ├── package.json
// └── tsconfig.json

//🔥 ตัวอย่างที่ 1: HTTP Endpoint (API แบบง่าย)
//
//functions/src/index.ts
//
//import * as functions from "firebase-functions";
//export const helloWorld = functions.https.onRequest((req, res) => {
//  res.send("Hello from Firebase Cloud Functions!");
//});

//จากนั้น deploy:
//
//firebase deploy --only functions

//Firebase จะให้ URL เช่น
//
//https://us-central1-yourproject.cloudfunctions.net/helloWorld
//
//✅ ใช้ URL นี้เรียกจาก iOS ได้โดยตรงผ่าน URLSession
//✅ ทำให้เราใช้ Cloud Functions เป็น “Mini API” ได้เลย

//🔥 ตัวอย่างที่ 2: Trigger เมื่อ Firestore มีข้อมูลใหม่
//import * as functions from "firebase-functions";
//import * as admin from "firebase-admin";
//
//admin.initializeApp();
//
//export const onNewUser = functions.firestore
//  .document("users/{userId}")
//  .onCreate(async (snapshot, context) => {
//    const data = snapshot.data();
//    console.log("🎉 New user:", data?.name);
//
//    // เพิ่มแต้มเริ่มต้น
//    await snapshot.ref.update({ points: 100 });
//});


//✅ Trigger จะทำงานอัตโนมัติทุกครั้งที่มี document ใหม่ใน users
//❌ ไม่มีทางรันจาก client ได้โดยตรง (เพื่อความปลอดภัย)

//🔥 ตัวอย่างที่ 3: Trigger จาก Storage (เมื่ออัปโหลดไฟล์)
//export const onImageUpload = functions.storage
//  .object()
//  .onFinalize(async (object) => {
//    console.log("📸 Uploaded file:", object.name);
//    // สามารถ resize หรือบันทึก metadata ได้ที่นี่
//});
//
//
//✅ ใช้สำหรับแอปที่ผู้ใช้อัปโหลดรูปภาพ เช่น Profile หรือ Feed

//🔥 ตัวอย่างที่ 4: ส่ง Push Notification (ผ่าน FCM)

//export const sendPushOnNewMessage = functions.firestore
//  .document("messages/{messageId}")
//  .onCreate(async (snapshot) => {
//    const message = snapshot.data();
//    const payload = {
//      notification: {
//        title: "💬 New Message",
//        body: message?.text ?? "New message received"
//      }
//    };
//
//    await admin.messaging().sendToTopic("chat", payload);
//    console.log("✅ Push sent to topic 'chat'");
//  });

//✅ ทุกครั้งที่มีข้อความใหม่ใน messages → ส่งแจ้งเตือนอัตโนมัติ
//📱 ฝั่ง iOS สมัคร topic ด้วย
//
//Messaging.messaging().subscribe(toTopic: "chat")

//🔐 ตัวอย่างที่ 5: Protected API (Callable Function)
//
//ใช้สำหรับ “เรียกจาก iOS ด้วย Auth”
//ไม่ต้องเปิดเป็น URL สาธารณะ
//
//index.ts
//
//export const getUserScore = functions.https.onCall(async (data, context) => {
//  if (!context.auth) {
//    throw new functions.https.HttpsError("unauthenticated", "Please log in");
//  }
//
//  const uid = context.auth.uid;
//  const userDoc = await admin.firestore().collection("users").doc(uid).get();
//  return { score: userDoc.data()?.score ?? 0 };
//});

//ฝั่ง iOS เรียกใช้ (Firebase Functions SDK)
//import FirebaseFunctions
//
//let functions = Functions.functions()
//
//func fetchUserScore() {
//    functions.httpsCallable("getUserScore").call { result, error in
//        if let error = error {
//            print("❌ Error:", error)
//        } else if let data = result?.data as? [String: Any] {
//            print("🏅 Score:", data["score"] ?? 0)
//        }
//    }
//}
//
//✅ ฟังก์ชันนี้จะตรวจสอบ token ของผู้ใช้โดยอัตโนมัติ

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

