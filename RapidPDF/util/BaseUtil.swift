import UIKit
import SwiftUI
import MobileCoreServices
import QuickLook
import Foundation
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    var onImagePicked: (URL?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var onImagePicked: (URL?) -> Void

        init(onImagePicked: @escaping (URL?) -> Void) {
            self.onImagePicked = onImagePicked
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                let fileManager = FileManager.default
                let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("image.jpg")

                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    do {
                        try imageData.write(to: fileURL)
                        onImagePicked(fileURL)
                    } catch {
                        print("Failed to save image: \(error.localizedDescription)")
                        onImagePicked(nil)
                    }
                } else {
                    onImagePicked(nil)
                }
            } else {
                onImagePicked(nil)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onImagePicked(nil)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}



func isFileLargerThan5MB(atPath path: String) -> Bool {
    let fileManager = FileManager.default

    do {
        let fileAttributes = try fileManager.attributesOfItem(atPath: path)
        if let fileSize = fileAttributes[.size] as? NSNumber {
            let fileSizeInMB = Double(fileSize.intValue) / (1024 * 1024)
            return fileSizeInMB > 5
        }
    } catch {
        print("Error retrieving file attributes: \(error.localizedDescription)")
    }

    return false
}

func extractFileExtension(from urlString: String) -> String {
    guard let url = URL(string: urlString) else {
        return "ppt"
    }
    
    // 获取文件名和扩展名
    let fileExtension = url.pathExtension
    
    // 如果扩展名为空，则返回 nil
    return fileExtension.isEmpty ? "pdf" : fileExtension
}


func extractFileName1(from urlString: String) -> String{
    guard let url = URL(string: urlString) else {
        return ""
    }
    
    // 提取查询参数
    let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
    
    // 查找文件名参数
    if let filename = queryItems?.first(where: { $0.name == "filename" })?.value {
        return filename
    }
    
    return ""
}


func getFileSizeInMB(urlString: String, completion: @escaping (String?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "HEAD"

    let task = URLSession.shared.dataTask(with: request) { _, response, error in
        guard let httpResponse = response as? HTTPURLResponse,
              let contentLength = httpResponse.allHeaderFields["Content-Length"] as? String,
              let fileSize = Double(contentLength),
              error == nil else {
            completion(nil)
            return
        }

        let fileSizeInMB = fileSize / (1024 * 1024)
        let fileSizeString = String(format: "%.2f MB", fileSizeInMB)
        completion(fileSizeString)
    }

    task.resume()
}



func extractFileName(from filePath: String) -> String {
    let url = URL(fileURLWithPath: filePath)
    let fileNameWithExtension = url.lastPathComponent
    let fileName = (fileNameWithExtension as NSString).deletingPathExtension
    
    if let fileNameUtf8 = fileName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        return fileNameUtf8
    }
    
    return fileName
}


func currentDateString() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
}


func downloadVPNConfig(urlString: String) {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    let task = URLSession.shared.downloadTask(with: url) { localUrl, response, error in
        guard let localUrl = localUrl else {
            if let error = error {
                print("Download failed: \(error.localizedDescription)")
            }
            return
        }
        
        // 获取应用的 Documents 目录
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // 生成保存文件的 URL，保持原文件名
        let savedUrl = documentsDirectory.appendingPathComponent(localUrl.lastPathComponent)
        
        do {
            // 移动文件到 Documents 目录
            try FileManager.default.moveItem(at: localUrl, to: savedUrl)
            print("File downloaded and moved to: \(savedUrl.path)")
        } catch {
            print("File processing error: \(error.localizedDescription)")
        }
    }
    
    task.resume()
}



func downloadFile(from urlString: String, completion: @escaping (Result<URL, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    let session = URLSession(configuration: .default)
    let downloadTask = session.downloadTask(with: url) { (tempLocalUrl, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let tempLocalUrl = tempLocalUrl else {
            completion(.failure(NSError(domain: "No file URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "No file URL"])))
            return
        }
        
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
     
        do {
            // 删除已有文件
            if fileManager.fileExists(atPath: destinationUrl.path) {
                try fileManager.removeItem(at: destinationUrl)
                print("Removed existing file at \(destinationUrl.path)")
            }
            
            // 将文件复制到目标路径
            try fileManager.copyItem(at: tempLocalUrl, to: destinationUrl)
            completion(.success(destinationUrl))
        } catch {
            print("Error copying file: \(error)")
            completion(.failure(error))
        }
    }
    
    downloadTask.resume()
}

func fileExists(at path: String) -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: path)
}

func checkFileAndUpdateURL(filePath: String) {
    guard let fileURL = URL(string: filePath) else {
        print("Invalid file path: \(filePath)")
        return
    }

    if fileExists(at: fileURL.path) {
        print("File exists at path: \(fileURL.path)")
        // 文件存在时可以执行其他操作，例如返回文件URL
    } else {
        print("File does not exist at path: \(fileURL.path)")
    }
}


func saveConversionArray(_ array: [Int], forKey key: String) {
    UserDefaults.standard.set(array, forKey: key)
}
func getConversionArray(forKey key: String) -> [Int] {
    return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
}


extension UserDefaults {
     enum Keys {
        static let savedURL = "savedURL"
    }
    
    // 保存 URL
    func setURL(_ url: URL?, forKey key: String) {
        set(url?.absoluteString, forKey: key)
    }
    
    // 获取 URL
    func url(forKey key: String) -> URL? {
        guard let urlString = string(forKey: key) else {
            return nil
        }
        return URL(string: urlString)
    }
}



func getFileConversionDescription(from types: [Int]) -> String {
    guard types.count == 2,
          let sourceType = FileType(rawValue: types[0]),
          let targetType = FileType(rawValue: types[1]) else {
        return "PDF to JPG"
    }
    
    return "\(sourceType.description) to \(targetType.description)"
}


func fileSizeInMB(at fileURL: URL) -> String? {
    do {
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
        if let fileSize = fileAttributes[FileAttributeKey.size] as? UInt64 {
            // 将文件大小从字节转换为 MB
            let fileSizeInMB = Double(fileSize) / (1000 * 1000)
            return String(format: "%.2f MB", fileSizeInMB)
        }
    } catch {
        print("Error retrieving file size: \(error)")
    }
    return nil
}


class UploadProgressDelegate: NSObject, URLSessionTaskDelegate {
    var onProgress: ((Double) -> Void)?
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        onProgress?(progress)
    }
}

func uploadFile(fileURL: URL, filetype: String, outputtype: String, to uploadURL: URL, progress: @escaping (Double) -> Void, completion: @escaping (Result<String, Error>) -> Void) -> URLSessionUploadTask? {
    print("upload url: ", fileURL)
    var request = URLRequest(url: uploadURL)
    request.httpMethod = "POST"

    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    do {
        let body = try createBody(with: fileURL, filetype: filetype, outputtype: outputtype, boundary: boundary)
        
        // 创建一个代理来监控上传进度
        let progressDelegate = UploadProgressDelegate()
        progressDelegate.onProgress = progress
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: progressDelegate, delegateQueue: nil)
        
        let task = session.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusError = NSError(domain: "uploadFile", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                completion(.failure(statusError))
                return
            }

            // 处理返回的数据
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                let dataError = NSError(domain: "uploadFile", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
                completion(.failure(dataError))
            }
        }

        task.resume()
        return task // 返回任务以便可以在需要时取消
    } catch {
        completion(.failure(error))
        return nil
    }
}


private func createBody(with fileURL: URL, filetype: String, outputtype: String, boundary: String) -> Data {
    var body = Data()
    let filename = fileURL.lastPathComponent
    let mimetype = "application/octet-stream"

    // 添加 file 参数
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
    body.append(try! Data(contentsOf: fileURL))
    body.append("\r\n".data(using: .utf8)!)

    // 添加 filetype 参数
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"filetype\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(filetype)\r\n".data(using: .utf8)!)

    // 添加 outputtype 参数
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"outputtype\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(outputtype)\r\n".data(using: .utf8)!)

    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    return body
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


import SwiftUI
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFileURL: URL?
    var type: [UTType]
    var onCompletion: ((URL) -> Void)?

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedFileURL = urls.first else { return }

            // 请求访问文件
            if selectedFileURL.startAccessingSecurityScopedResource() {
                defer { selectedFileURL.stopAccessingSecurityScopedResource() }

                // 获取应用的 Documents 目录路径
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationURL = documentsDirectory.appendingPathComponent(selectedFileURL.lastPathComponent)

                do {
                    // 如果 Documents 目录中已经存在同名文件，则先删除
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }
                    
                    // 将文件复制到 Documents 目录
                    try FileManager.default.copyItem(at: selectedFileURL, to: destinationURL)
                    
                    // 将复制后的文件 URL 赋值给父类的 selectedFileURL
                    parent.selectedFileURL = destinationURL
                    
                    // 调用完成闭包，传递文件链接
                    parent.onCompletion?(destinationURL)
                } catch {
                    print("Error copying file to documents directory: \(error)")
                }
            } else {
                print("Failed to start accessing security scoped resource.")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: type)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}


struct FilePreviewController: UIViewControllerRepresentable {
    let url: URL
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let previewController = QLPreviewController()
        previewController.dataSource = context.coordinator
        
        let navigationController = UINavigationController(rootViewController: previewController)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: context.coordinator, action: #selector(context.coordinator.dismissPreview))
        previewController.navigationItem.leftBarButtonItem = closeButton
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: FilePreviewController
        
        init(_ parent: FilePreviewController) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            parent.url as QLPreviewItem
        }
        
        @objc func dismissPreview() {
            parent.isPresented = false
        }
    }
}



struct PdfItem: Identifiable {
    let id = UUID()
    let text: String
    let imageName: String
    
}


extension UIApplication {
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}
