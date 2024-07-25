//
//  Privacy.swift
//  EasyTranslate
//
//  Created by 周波 on 2024/6/12.
//

import SwiftUI

struct Privacy: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
                   Back(title: "Privacy Policy") {
                       self.presentationMode.wrappedValue.dismiss()
                   }
                   GeometryReader { geometry in
                                  WebView(url: URL(string: "https://www.easytranslate.top/privacy.html")!)
                                      .frame(height: geometry.size.height ) // 44是标题栏的高度
                              }
               }
                       .navigationViewStyle(StackNavigationViewStyle())
               .navigationBarHidden(true)
               .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Privacy()
}
