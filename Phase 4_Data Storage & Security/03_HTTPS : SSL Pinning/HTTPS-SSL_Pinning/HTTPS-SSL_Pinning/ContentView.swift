//🌐 1. HTTPS คืออะไร
//HTTPS (Hypertext Transfer Protocol Secure)
//คือ HTTP + SSL/TLS encryption
//เมื่อใช้ HTTPS:
//ข้อมูลที่ส่งระหว่าง App ↔ Server ถูก เข้ารหัส (encrypted)
//ป้องกันการถูกดักฟัง (man-in-the-middle attack)
//เซิร์ฟเวอร์ต้องมี SSL Certificate ที่ออกโดย CA (เช่น Let's Encrypt, DigiCert)

//🔁 ขั้นตอนการเชื่อมต่อ HTTPS

//แอป (client) ขอเชื่อมต่อกับ server ผ่าน HTTPS
//Server ส่ง certificate (ใบรับรอง SSL) กลับมา
//iOS ตรวจสอบว่าใบรับรองนี้ถูกต้อง (CA ลงนาม)
//ถ้าผ่าน → เชื่อมต่อสำเร็จ (ข้อมูลทั้งหมดถูกเข้ารหัสระหว่างส่ง)

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
