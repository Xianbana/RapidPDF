import UIKit
import SwiftUI
import MobileCoreServices
import QuickLook
import Foundation

func saveConversionArray(_ array: [Int], forKey key: String) {
    UserDefaults.standard.set(array, forKey: key)
}
func getConversionArray(forKey key: String) -> [Int] {
    return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
}


func fileTypeString(from intValue: Int) -> String {
    switch intValue {
    case 0:
        return "pdf"
    case 1:
        return "jpg"
    case 2:
        return "pptx"
    case 3:
        return "png"
    case 4:
        return "xls"
    case 5:
        return "docx"
    default:
        return "unknown"
    }
}


func utTypes(for fileType: Int) -> [UTType] {
    let types: [FileType: UTType] = [
        .PDF: .pdf,
        .JPG: .image,
        .PPT: .presentation,
        .PNG: .image,
        .EXCEL: .spreadsheet,
        .WORD: .plainText
    ]
    
    guard let fileType = FileType(rawValue: fileType), let utType = types[fileType] else {
        return []
    }
    
    return [utType]
}

func getFileConversionTypes(isFromPDF: Bool, fileType: String) -> [Int] {
    let targetType: FileType?
    
    switch fileType.uppercased() {
    case "PDF":
        targetType = .PDF
    case "JPG":
        targetType = .JPG
    case "WORD":
        targetType = .WORD
    case "EXCEL":
        targetType = .EXCEL
    case "PPT":
        targetType = .PPT
    case "PNG":
        targetType = .PNG
    default:
        targetType = nil
    }
    
    if let targetType = targetType {
        if isFromPDF {
            return [targetType.rawValue, FileType.PDF.rawValue]

        } else {
            return [FileType.PDF.rawValue, targetType.rawValue]
        }
    } else {
        return []
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


func uploadFile(fileURL: URL, filetype: String, outputtype: String, to uploadURL: URL, progress: @escaping (Double) -> Void, completion: @escaping (Result<String, Error>) -> Void) {
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
    } catch {
        completion(.failure(error))
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



struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFileURL: URL?
    var type:[UTType]

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

                // 获取临时目录路径
                let tempDirectory = FileManager.default.temporaryDirectory
                let tempFileURL = tempDirectory.appendingPathComponent(selectedFileURL.lastPathComponent)
                
                do {
                    // 如果临时目录中已经存在同名文件，则先删除
                    if FileManager.default.fileExists(atPath: tempFileURL.path) {
                        try FileManager.default.removeItem(at: tempFileURL)
                    }
                    
                    // 将文件复制到临时目录
                    try FileManager.default.copyItem(at: selectedFileURL, to: tempFileURL)
                    
                    // 将复制后的文件 URL 赋值给父类的 selectedFileURL
                    parent.selectedFileURL = tempFileURL
                    
                    // 调用完成闭包，传递文件链接
                    parent.onCompletion?(tempFileURL)
                } catch {
                    print("Error copying file to temporary directory: \(error)")
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
