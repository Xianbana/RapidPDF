

import SwiftUI

struct SettingView: View {
    @State private var isService = false
    @State private var isPrivacy = false
    @State private var showAlert = false
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(height: UIApplication.shared.statusBarFrame.height + 44)
                    .foregroundColor(Color.red)
                
                HStack {
                    Spacer()
                    Text("Setting")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.bottom, 5)
            }
            
            
            SettingsItem(image: "terms", title: "Terms of Service")
                .padding(.top,10)
                .onTapGesture {
                    self.isService.toggle()
                }
            
            SettingsItem(image: "privacy", title: "Privacy Policy")
                .onTapGesture {
                    self.isPrivacy.toggle()
                }
            
            SettingsItem(image: "share", title: "Share")
                .onTapGesture(perform: {
                    shareText("Search for PDF Converter Pro in App Store")
                })
            
            SettingsItem(image: "contact", title: "Contact us")
                               .onTapGesture {
                                   showAlert = true
                               }
                               .alert(isPresented: $showAlert) {
                                   Alert(
                                       title: Text("Contact Us"),
                                       message: Text("Please proceed through \n captainone@foxmail.com   \nTell us"),
                                       dismissButton: .default(Text("Close"))
                                   )
                               }
            
            NavigationLink(destination: Privacy(),isActive: $isPrivacy) {
                EmptyView()
            } .hidden()
             
            NavigationLink(destination: Service(),isActive: $isService) {
                EmptyView()
            } .hidden()
             
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    func shareText(_ text: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        // 在 iPad 上设置 sourceView
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = rootViewController.view
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
}

#Preview {
    SettingView()
}

struct SettingsItem: View {
    var image:String
    var title:String
    var body: some View {
        HStack{
            Image(image)
            Text(title).padding(.leading,10)
            Spacer()
        }.padding()
        
    }
}
struct CustomAlertView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Please proceed through ")
            + Text("1196@qq.com").bold()
            + Text(" Tell us")
            
            Button("Close") {
                isPresented = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}
