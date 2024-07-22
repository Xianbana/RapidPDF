

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView{
            VStack{
                TitleView(title: "Settings")
                Spacer()
            }.navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

#Preview {
    SettingView()
}
