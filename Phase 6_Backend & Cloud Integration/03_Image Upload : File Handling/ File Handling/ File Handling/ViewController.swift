//🪄 ขั้นตอนใน iOS (UIKit / SwiftUI)
//1️⃣ เลือกรูปจากเครื่อง (UIImagePickerController)

//class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    @IBAction func selectImageTapped(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//        if let image = info[.originalImage] as? UIImage {
//            uploadImageToFirebase(image)
//        }
//    }
//}

//2️⃣ อัปโหลดรูปไป Firebase Storage

//import FirebaseStorage
//
//func uploadImageToFirebase(_ image: UIImage) {
//    let storageRef = Storage.storage().reference()
//    let fileName = "images/\(UUID().uuidString).jpg"
//    let imageRef = storageRef.child(fileName)
//
//    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
//
//    // 🔄 เริ่มอัปโหลด
//    let uploadTask = imageRef.putData(imageData)
//
//    uploadTask.observe(.progress) { snapshot in
//        let percent = Double(snapshot.progress?.completedUnitCount ?? 0) /
//                      Double(snapshot.progress?.totalUnitCount ?? 1)
//        print("📤 Upload progress: \(Int(percent * 100))%")
//    }
//
//    uploadTask.observe(.success) { _ in
//        imageRef.downloadURL { url, error in
//            if let url = url {
//                print("✅ Uploaded URL:", url.absoluteString)
//            }
//        }
//    }
//
//    uploadTask.observe(.failure) { snapshot in
//        print("❌ Upload failed:", snapshot.error ?? "")
//    }
//}

//✅ UUID().uuidString ช่วยป้องกันชื่อไฟล์ซ้ำ
//✅ ใช้ .jpegData(compressionQuality:) เพื่อลดขนาดไฟล์ก่อนอัปโหลด

//3️⃣ บันทึก URL ไป Firestore

//import FirebaseFirestore
//
//func saveImageURLToFirestore(_ url: URL) {
//    let db = Firestore.firestore()
//    db.collection("images").addDocument(data: [
//        "url": url.absoluteString,
//        "createdAt": Date()
//    ]) { error in
//        if let error = error {
//            print("❌ Firestore save error:", error)
//        } else {
//            print("✅ Image URL saved!")
//        }
//    }
//}

//4️⃣ ดาวน์โหลดรูปกลับมาแสดง

//import SDWebImage
//
//imageView.sd_setImage(with: URL(string: imageURL),
//                      placeholderImage: UIImage(systemName: "photo"))

//pod 'SDWebImage'

//📦 Upload หลายไฟล์ (เช่น อัปโหลดโพสต์พร้อมหลายรูป)

//func uploadMultipleImages(_ images: [UIImage]) async -> [String] {
//    var urls: [String] = []
//    let storageRef = Storage.storage().reference()
//    
//    for image in images {
//        guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
//        let fileRef = storageRef.child("posts/\(UUID().uuidString).jpg")
//        do {
//            _ = try await fileRef.putDataAsync(data)
//            let url = try await fileRef.downloadURL()
//            urls.append(url.absoluteString)
//        } catch {
//            print("❌ Error uploading:", error)
//        }
//    }
//    return urls
//}

//✅ ใช้ async/await (iOS 15+) ทำให้โค้ดดูเรียบและเข้าใจง่าย

//✏️ เขียนไฟล์
//func saveTextFile() {
//    let text = "Hello File!"
//    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        .appendingPathComponent("example.txt")
//    try? text.write(to: url, atomically: true, encoding: .utf8)
//    print("✅ Saved at:", url)
//}

//📖 อ่านไฟล์
//func readFile() {
//    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        .appendingPathComponent("example.txt")
//    let text = try? String(contentsOf: url)
//    print("📄 Content:", text ?? "nil")
//}

//🗑️ ลบไฟล์
//try? FileManager.default.removeItem(at: url)

//💾 ตัวอย่างการอัปโหลด + แสดง Progress Bar (UIKit)

//import FirebaseStorage
//import UIKit
//
//class UploadViewController: UIViewController {
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var progressView: UIProgressView!
//
//    func uploadImage(_ image: UIImage) {
//        let storageRef = Storage.storage().reference().child("uploads/\(UUID().uuidString).jpg")
//        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
//
//        let uploadTask = storageRef.putData(data)
//
//        uploadTask.observe(.progress) { snapshot in
//            let progress = Float(snapshot.progress?.fractionCompleted ?? 0)
//            self.progressView.progress = progress
//        }
//
//        uploadTask.observe(.success) { _ in
//            storageRef.downloadURL { url, _ in
//                print("✅ URL:", url?.absoluteString ?? "")
//            }
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




