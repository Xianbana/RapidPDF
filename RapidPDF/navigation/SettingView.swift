

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
                .padding(.top,20)
                .onTapGesture {
                    self.isService.toggle()
                }
            
            SettingsItem(image: "privacy", title: "Privacy Policy")
                .onTapGesture {
                    self.isPrivacy.toggle()
                }
            
            SettingsItem(image: "share", title: "Share")
            
            SettingsItem(image: "contact", title: "Contact us")
                               .onTapGesture {
                                   showAlert = true
                               }
                               .alert(isPresented: $showAlert) {
                                   Alert(
                                       title: Text("Contact Us"),
                                       message: Text("Please proceed through \n1196@qq.com \nTell us"),
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
