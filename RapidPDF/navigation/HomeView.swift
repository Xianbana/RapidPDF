

import SwiftUI

struct HomeView: View {
    @Binding var showDetail: Bool
    var body: some View {
        NavigationView{
            
            
            ZStack {
                TitleView( title: "PDF Converter")
                VStack(spacing:0){
                    HomeTitleView(title: "PDF Conversion").padding(.top, 64)
                    
                    PdfList(items: toPdfList,isToPdf: false,showDetail: $showDetail)
                    HomeTitleView(title: "Convert to PDF")
                    PdfList(items: pdfToList,isToPdf: true,showDetail: $showDetail)
                    HomeTitleView(title: "Document")
                    Spacer()
                    
                    
                    
                }
            }.navigationBarHidden(true)
        }.navigationBarHidden(true)
        
    }
}

//#Preview {
//    HomeView(showDetail: false)
//}


struct PdfList: View {
   
    var items :[PdfItem]
    var isToPdf:Bool
    @Binding var showDetail: Bool
    @State private var isSelect = false
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items) { item in
                    VStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .frame(width: 56, height: 56)
                                .foregroundColor(Color(item.imageName))
                                .clipShape(Circle())
                                .opacity(0.1)
                                .cornerRadius(20)
                            Button(action: {
                                self.isSelect.toggle()
                                
                                withAnimation {
                                                    showDetail = true
                                                }
                            } ){
                                Image(item.imageName)
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                            
                        }
                        if isToPdf{
                            Text("\(item.text) to PDF")
                                .font(.caption2)
                        }else{
                            Text("PDF to \(item.text)")
                                .font(.caption2)
                        }
                        NavigationLink(destination: SelectFileView(showDetail:$showDetail)
                                       ,
                                       isActive: $isSelect) {
                            EmptyView()
                        } .hidden()
                            .navigationBarHidden(true)
                        Spacer()
                    }
                    
                }
            }
            .padding(.leading)
        }
        
        .frame(width: UIScreen.main.bounds.width,height: 190)
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        
    }
}


import SwiftUI

// 主界面 A
struct MainView: View {
    @State private var selectedTab = 0
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            if showDetail {
                // 当 showDetail 为 true 时，显示 D 界面，并隐藏底部导航
                DView(showDetail: $showDetail)
                    .transition(.opacity) // 添加过渡动画
                    .zIndex(1) // 确保 DView 在最上层
            } else {
                TabView(selection: $selectedTab) {
                    // 界面 B
                    NavigationView {
                        VStack {
                            Text("B View")
                        }
                        .navigationTitle("B")
                    }
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("B")
                    }
                    .tag(0)
                    
                    // 界面 C
                    NavigationView {
                        VStack {
                            Text("C View")
                            Button("Go to D") {
                                withAnimation {
                                    showDetail = true
                                }
                            }
                        }
                        .navigationTitle("C")
                    }
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("C")
                    }
                    .tag(1)
                }
                .accentColor(.blue) // 设置底部导航选中的颜色
            }
        }
    }
}

// 界面 D
struct DView: View {
    @Binding var showDetail: Bool
    
    var body: some View {
        VStack {
            Text("D View")
            Button("Back to C") {
                // 返回上一个界面
                withAnimation {
                    showDetail = false
                }
            }
        }
        .navigationTitle("D")
    }
}



