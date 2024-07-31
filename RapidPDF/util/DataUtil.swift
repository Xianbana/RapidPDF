import UIKit
import SwiftUI
import MobileCoreServices
import QuickLook
import Foundation




func fileTypeInt(from fileURL: String) -> Int {
    guard let fileExtension = fileURL.split(separator: ".").last?.lowercased() else {
        return -1
    }
    switch fileExtension {
    case "pdf":
        return 0
    case "html":
        return 1
    case "excel":
        return 2
    case "txt":
        return 3
    case "docx":
        return 4
    case "ppt":
        return 5
    default:
        return -1
    }
}

func fileTypeString(from intValue: Int) -> String {
    switch intValue {
    case 0:
        return "pdf"
    case 1:
        return "html"
    case 2:
        return "excel"
    case 3:
        return "txt"
    case 4:
        return "docx"
    case 5:
        return "ppt"
    default:
        return "unknown"
    }
}


func utTypes(for fileType: Int) -> [UTType] {
    let types: [FileType: UTType] = [
           .PDF: .pdf,
           .EXCEL: .spreadsheet,
           .HTML: .html,
           .PPT: .presentation,
           .TXT: .plainText,
           .WORD: UTType(filenameExtension: "docx") ?? .plainText

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
    case "EXCEL":
        targetType = .EXCEL
    case "WORD":
        targetType = .WORD
    case "HTML":
        targetType = .HTML
    case "TXT":
        targetType = .TXT
    case "PPT":
        targetType = .PPT
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


enum FileType: Int {
    case PDF = 0
    case HTML = 1
    case PPT = 2
    case TXT = 3
    case WORD = 4
    case EXCEL = 5
    
    var description: String {
        switch self {
        case .PDF:
            return "PDF"
        case .EXCEL:
            return "EXCEL"
        case .WORD:
            return "WORD"
        case .TXT:
            return "TXT"
        case .HTML:
            return "HTML"
        case .PPT:
            return "PPT"
        }
    }
}



struct APIResponse: Codable {
    let code: Int
    let msg: String?
    let result: String
}


let toPdfList = [
    PdfItem(text: "EXCEL", imageName: "excel"),
    PdfItem(text: "HTML", imageName: "html"),
    PdfItem(text: "PPT", imageName: "ppt"),
    PdfItem(text: "TXT", imageName: "txt"),
    PdfItem(text: "WORD", imageName: "word")
]


let pdfToList = [
    
    
    PdfItem(text: "TXT", imageName: "txt"),
  
    PdfItem(text: "HTML", imageName: "html"),
    
    PdfItem(text: "EXCEL", imageName: "excel"),
    
    PdfItem(text: "WORD", imageName: "word"),
    
    PdfItem(text: "PPT", imageName: "ppt")
 
   
]



let columns = [
    GridItem(.flexible(), alignment: .leading),
    GridItem(.flexible(), alignment: .leading),
    GridItem(.flexible(), alignment: .leading)
]
