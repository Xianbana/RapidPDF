//
//  SelectFileView.swift
//  RapidPDF
//
//  Created by 周波 on 2024/7/22.
//

import SwiftUI

struct SelectFileView: View {
    @State var isSelect = false
    @Binding var showDetail: Bool

    @State var isMain = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack{
                TitleView(title: "Select File")
                
                VStack {
                    Text("jump").onTapGesture {
                        self.isSelect.toggle()
                    }
                    Text("back").onTapGesture {
                        withAnimation {
                            showDetail = false
                        }
                    }
                    Spacer()
                }.padding(.top,64)
                
                NavigationLink(destination: SelectFile() , isActive: $isSelect) {
                    EmptyView()
                } .hidden()
                 .navigationBarHidden(true)
                
                NavigationLink(destination: ContentView(),isActive: $isMain) {
                    EmptyView()
                } .hidden()
                 .navigationBarHidden(true)
                
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
}

//#Preview {
//    @State static var showDetail = true
//    SelectFileView(showDetail:showDetail)
//}
struct DView_Previews: PreviewProvider {
    @State static var showDetail = true

    static var previews: some View {
        DView(showDetail: $showDetail)
    }
}
