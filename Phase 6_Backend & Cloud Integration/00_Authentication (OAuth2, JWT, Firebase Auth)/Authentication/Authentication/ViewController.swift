//🌐 ภาพรวมระบบ Authentication
//
//เมื่อผู้ใช้ “ล็อกอิน” → แอปจะต้องยืนยันตัวตนกับ “Server” เพื่อรับสิทธิ์เข้าถึงข้อมูล
//โครงสร้างทั่วไปคือ
//[User] → [App] → [Auth Server] → [Token] → [API Server]
//
//เมื่อ Auth Server ยืนยันตัวตนสำเร็จ → จะส่ง “Token” (เช่น JWT) กลับมา
//เพื่อใช้เรียก API ต่อไปโดยไม่ต้องล็อกอินซ้ำทุกครั้ง

//🔸 1. OAuth 2.0
//
//มาตรฐานเปิดสำหรับการยืนยันตัวตน (Authorization)
//ใช้โดย Google, Facebook, GitHub, Apple Sign In ฯลฯ
//
//⚙️ หลักการทำงาน
//แอปขออนุญาตจากผู้ใช้ไปยัง Provider (Google, Apple)
//ผู้ใช้ล็อกอิน → ยอมให้เข้าถึงข้อมูล
//Provider ส่ง Authorization Code กลับมา
//แอปแลก code นี้กับ Access Token
//ใช้ token เพื่อเรียก API ได้

//🔁 Flow ยอดนิยม: Authorization Code Flow
//App → OAuth Provider (Google)
//     ↳ redirect ไปหน้า login
//     ↳ ผู้ใช้กดอนุญาต
//Provider → App (ส่ง authorization code)
//App → Server (แลก code เป็น access_token)
//Server → API (ใช้ token เพื่อเข้าถึงข้อมูล)

//🔧 ตัวอย่างใน iOS (Sign in with Google)

//import GoogleSignIn

//class LoginViewController: UIViewController {
//    @IBAction func googleSignInTapped(_ sender: Any) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        let config = GIDConfiguration(clientID: clientID)
//
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { result, error in
//            if let error = error {
//                print("❌ Google Sign-In error:", error)
//                return
//            }
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString else { return }
//
//            print("✅ Google token:", idToken)
//        }
//    }
//}

//Token ที่ได้ (เช่น idToken) คือ JWT ที่สามารถส่งไปตรวจสอบใน backend ได้

//🔸 2. JWT (JSON Web Token)
//
//Token ที่ใช้เก็บ “ข้อมูลยืนยันตัวตน” ในรูปแบบ เข้ารหัสแบบ base64
//ใช้กันแพร่หลายในระบบ login แบบ custom
//
//🧱 โครงสร้างของ JWT
//xxxxx.yyyyy.zzzzz

//🔍 ตัวอย่าง Payload

//{
//  "sub": "1234567890",
//  "name": "Somsak",
//  "role": "admin",
//  "exp": 1734567890
//}

//📦 ตัวอย่างใน iOS
//
//สมมติ backend ส่ง JWT กลับมา:

struct LoginResponse: Codable {
    let token: String
}

//func login() async {
//    let url = URL(string: "https://api.myapp.com/login")!
//    let body = ["username": "somsak", "password": "1234"]
//    let data = try JSONSerialization.data(withJSONObject: body)
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.httpBody = data
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    let (responseData, _) = try await URLSession.shared.data(for: request)
//    let result = try JSONDecoder().decode(LoginResponse.self, from: responseData)
//    
//    print("✅ Token:", result.token)
//    UserDefaults.standard.set(result.token, forKey: "jwt")
//}

//🔒 ใช้ JWT กับ API ที่ต้อง Authen

//func fetchUserProfile() async {
//    guard let token = UserDefaults.standard.string(forKey: "jwt") else { return }
//    var request = URLRequest(url: URL(string: "https://api.myapp.com/profile")!)
//    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//    let (data, _) = try await URLSession.shared.data(for: request)
//    print(String(data: data, encoding: .utf8)!)
//}

//✅ ใช้ header "Authorization": "Bearer <token>"
//❌ ถ้า token หมดอายุ (exp) → ต้อง refresh หรือ login ใหม่

//🔸 3. Firebase Authentication
//
//ใช้งานง่ายสุดใน iOS (และ cross-platform)
//รองรับ: Email, Google, Apple, Facebook, Phone, Anonymous login

//✅ ติดตั้ง
//pod 'Firebase/Auth'

//ใน AppDelegate:

//📧 Login ด้วย Email/Password
//import FirebaseAuth
//func login(email: String, password: String) {
//    Auth.auth().signIn(withEmail: email, password: password) { result, error in
//        if let error = error {
//            print("❌ Error:", error)
//            return
//        }
//        print("✅ Logged in as:", result?.user.email ?? "")
//    }
//}

//🆕 สมัครผู้ใช้ใหม่

//Auth.auth().createUser(withEmail: "test@gmail.com", password: "123456") { result, error in
//    if let error = error {
//        print("❌ Error:", error)
//    } else {
//        print("✅ New user:", result?.user.uid ?? "")
//    }
//}

//🍎 Sign in with Apple (ผ่าน Firebase)

//import AuthenticationServices
//import FirebaseAuth
//
//// 1. เริ่ม Sign in with Apple
//func startSignInWithAppleFlow() {
//    let request = ASAuthorizationAppleIDProvider().createRequest()
//    request.requestedScopes = [.fullName, .email]
//
//    let controller = ASAuthorizationController(authorizationRequests: [request])
//    controller.delegate = self
//    controller.performRequests()
//}
//
//// 2. Handle result
//extension YourViewController: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController,
//                                 didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
//           let idToken = appleIDCredential.identityToken,
//           let tokenString = String(data: idToken, encoding: .utf8) {
//            
//            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: "nonce")
//            
//            Auth.auth().signIn(with: credential) { result, error in
//                if let error = error {
//                    print("❌ Apple login failed:", error)
//                } else {
//                    print("✅ Logged in with Apple:", result?.user.uid ?? "")
//                }
//            }
//        }
//    }
//}

//🔐 ตรวจสอบสถานะผู้ใช้

//if let user = Auth.auth().currentUser {
//    print("✅ ผู้ใช้ล็อกอิน:", user.uid)
//} else {
//    print("🔒 ยังไม่ได้ล็อกอิน")
//}

//🚪 Logout

//try? Auth.auth().signOut()

//✅ ตัวอย่างโฟลว์เต็มในแอปจริง (Firebase Auth + JWT)
//[1] ผู้ใช้ล็อกอินผ่าน Firebase
//[2] Firebase ส่ง idToken (JWT) กลับมา
//[3] แอปส่ง token นี้ไป verify กับ backend
//[4] Backend ตรวจสอบกับ Firebase Admin SDK
//[5] ถ้าถูกต้อง → ออก access_token ให้แอปใช้เรียก API ต่อ
//
//💡 วิธีนี้ผสม “ง่ายของ Firebase” กับ “ความปลอดภัยของ JWT” ได้ดีที่สุด

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }



}

