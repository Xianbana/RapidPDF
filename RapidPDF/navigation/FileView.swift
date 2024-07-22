//
//  FileView.swift
//  RapidPDF
//
//  Created by 周波 on 2024/7/22.
//

import SwiftUI

struct FileView: View {
    var body: some View {
        NavigationView{
            VStack{
                TitleView(title: "File")
                Spacer()
            }.navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

#Preview {
    FileView()
}
