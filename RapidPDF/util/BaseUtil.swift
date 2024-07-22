import UIKit




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
