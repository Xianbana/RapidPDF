

import SwiftUI

struct HomeView: View {
    @Binding var showDetail: Bool
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(height: UIApplication.statusBarHeight+44)
                        .foregroundColor(Color.red)
                    
                    HStack{
                        Spacer()
                        Text("PDF converter")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                    }.padding(.bottom,5)
                }
                
                ZStack {
                    GeometryReader { geometry in
                        Rectangle()
                            .foregroundColor(Color("mainback"))
                            .frame(width: 2000, height: 2000)
                        
                    }
                    VStack {
                        HomeTitleView(title: "PDF Conversion").padding(.top,10)
                        PdfList(items: toPdfList,isToPdf: false,showDetail: $showDetail)
                        HomeTitleView(title: "Convert to PDF")
                        PdfList(items: pdfToList,isToPdf: true,showDetail: $showDetail)
                        HomeTitleView(title: "Document")
                        Spacer()
                    }
                }
                
                Spacer()
                
                
            }.navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
            
        }.navigationBarHidden(true)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var showDetail = true
    
    static var previews: some View {
        HomeView(showDetail: $showDetail)
    }
}



struct PdfList: View {

    var items :[PdfItem]
    var isToPdf:Bool
    @State private var startIndex = 0
    @State private var acceptIndex = 0
    @Binding var showDetail: Bool
    @State private var isSelect = false
    @State private var conversionArray: [Int] = [0, 3]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items) { item in
                    VStack {
                        Spacer()
                       
                           
                            Button(action: {
                                self.isSelect.toggle()
                             let code =  getFileConversionTypes(isFromPDF: isToPdf, fileType: item.text)
                              
                                withAnimation {
                                    showDetail = true
                                    saveConversionArray(code, forKey: "conversionArrayKey")
                                    NavigationLink(destination: SelectFileView(showDetail:$showDetail)  , isActive: $isSelect) {
                                        EmptyView()
                                    } .hidden()
                                        .navigationBarHidden(true)
                                }
                            } ){
                                ZStack {
                                Rectangle()
                                    .frame(width: 56, height: 56)
                                    .foregroundColor(Color(item.imageName))
                                    .clipShape(Circle())
                                    .opacity(0.1)
                                    .cornerRadius(20)
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
                      
                        Spacer()
                    }
                    
                }
            }
            .padding(.leading)
        }
        
        .frame(width: UIScreen.main.bounds.width - 40,height: 190)
        .background(Color.white)
        .cornerRadius(10)
        
    }
}
