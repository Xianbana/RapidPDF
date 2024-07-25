//
//  Service.swift
//  EasyTranslate
//
//  Created by 周波 on 2024/6/12.
//

import SwiftUI

struct Service: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
                           Back(title: "Terms Of Service") {
                               self.presentationMode.wrappedValue.dismiss()
                           }
                           GeometryReader { geometry in
                                          WebView(url: URL(string: "https://www.easytranslate.top/service.html")!)
                                              .frame(height: geometry.size.height ) // 44是标题栏的高度
                                      }
                       }
                               .navigationViewStyle(StackNavigationViewStyle())
                       .navigationBarHidden(true)
                       .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Service()
}
