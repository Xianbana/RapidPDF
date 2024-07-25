
import Foundation
import SwiftUI



enum FileType: Int {
    case PDF = 0
    case JPG = 1
    case PPT = 2
    case PNG = 3
    case EXCEL = 4
    case WORD = 5
    
    var description: String {
        switch self {
        case .PDF:
            return "PDF"
        case .JPG:
            return "JPG"
        case .WORD:
            return "WORD"
        case .EXCEL:
            return "EXCEL"
        case .PPT:
            return "PPT"
        case .PNG:
            return "PNG"
        }
    }
}



struct APIResponse: Codable {
    let code: Int
    let msg: String?
    let result: String
}


let toPdfList = [
    PdfItem(text: "JPG", imageName: "jpg"),
    PdfItem(text: "PPT", imageName: "ppt"),
    PdfItem(text: "PNG", imageName: "png"),
    PdfItem(text: "Excel", imageName: "excel"),
    PdfItem(text: "Word", imageName: "word")
]


let pdfToList = [
    
    
    PdfItem(text: "Excel", imageName: "excel"),
  
    PdfItem(text: "PPT", imageName: "ppt"),
    
    PdfItem(text: "JPG", imageName: "jpg"),
    
    PdfItem(text: "Word", imageName: "word"),
    
    PdfItem(text: "PNG", imageName: "png")
 
   
]



let columns = [
    GridItem(.flexible(), alignment: .leading),
    GridItem(.flexible(), alignment: .leading),
    GridItem(.flexible(), alignment: .leading)
]
