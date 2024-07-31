

import SwiftUI
import Photos

struct HomeView: View {
    @Binding var showDetail: Bool
    @State private var record:Record? = nil
    @State private var isEdit = false
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
                        
                    } .background(.white)
                  
                    
                    VStack {
                        HomeTitleView(title: "PDF Conversion").padding(.top,10)
                        PdfList(items: toPdfList,isToPdf: false,showDetail: $showDetail)
                        HomeTitleView(title: "Convert to PDF")
                        
                        PdfList(items: pdfToList,isToPdf: true,showDetail: $showDetail)
                        HomeTitleView(title: "Document")
                        
          
                        
                        
                        RecentlyView(record: $record,isEdit:$isEdit)
                        
                        Spacer()
                        
                    }.onAppear {
                        
                        let fetchedRecord = DatabaseManager.shared.fetchLatestRecord()
                        self.record = fetchedRecord
                    }
                
                   
                  
                }
                
                
                Spacer()
                
                
                
            }.onAppear{
                requestPhotoLibraryAccess()
            }
            .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.top)
            
        }.navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        
    }
  

    func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            // 已授权，无需进一步操作
            print("已授权访问相册")
            
        case .denied, .restricted:
            // 用户拒绝或受限，提示用户
            print("相册访问权限被拒绝或受限")
            
        case .notDetermined:
            // 未决定，申请权限
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    print("用户已授权访问相册")
                } else {
                    print("用户未授权访问相册")
                }
            }
            
        @unknown default:
            // 处理未知情况
            print("未知的相册权限状态")
        }
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


struct RecentlyView: View {
    @Binding var record: Record?
    @Binding var isEdit: Bool
    @State private var showFilePreview = false
    @State private var showActionSheet = false

    var body: some View {
        if let record = record {
            VStack {
                HStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 56, height: 56)
                            .foregroundColor(Color("png"))
                            .clipShape(Circle())
                            .opacity(0.1)
                            .cornerRadius(20)
                        Image(fileTypeString(from: record.type))
                            .resizable()
                            .frame(width: 36, height: 36)
                    }

                    VStack(alignment: .leading, content: {
                        Text(extractFileName(from: record.url))
                            .font(.footnote)
                            .padding(.vertical, 5)
                            .lineLimit(1)

                        Text(record.date)
                            .font(.caption2)
                            .foregroundColor(Color.black)
                            .opacity(0.8)
                            .padding(.vertical, 5)
                    }).padding(.leading, 10)

                    Spacer()
                    Button(action: {
                        showActionSheet = true // Trigger action sheet
                    }) {
                        Image("more")
                            .padding(.trailing, 10)
                    }
                }
                .padding(.all, 5)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .sheet(isPresented: $showFilePreview) {
                    let urlString = record.url
                    if let url = URL(string: urlString) {
                        FilePreviewController(url: url, isPresented: $showFilePreview)
                    }
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("Options"),
                        buttons: [
                            .default(Text("Share")) {
                                shareFile(record: record)
                            },
                            .default(Text("Open")) {
                                openFile()
                            },
                            .destructive(Text("Delete")) {
                                deleteFile(record: record)
                            },
                            .cancel()
                        ]
                    )
                }
            }.onAppear{
               
            }
        }
    
    }
    func shareFile(record:Record) {
       
        let fileURLString = record.url
               guard let fileURL = URL(string: fileURLString) else {
                   print("无效的文件 URL")
                   return
               }

               let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

               if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                   rootViewController.present(activityViewController, animated: true, completion: nil)
               } else {
                   print("无法获取当前的视图控制器")
               }
    }

    func openFile() {
        // Implement open functionality
        showFilePreview = true
        print("Open file: \(record?.url ?? "No URL")")
    }

    func deleteFile(record:Record) {
        let fileURLString = record.url
               guard let fileURL = URL(string: fileURLString) else {
                   print("无效的文件 URL")
                   return
               }
        DatabaseManager.shared.delete(id: record.id)
        self.record = DatabaseManager.shared.fetchLatestRecord()
               do {
                   try FileManager.default.removeItem(at: fileURL)
                 
                   print("文件已删除: \(fileURL)")
               } catch {
                   print("删除文件时发生错误: \(error.localizedDescription)")
               }
    }
}

struct RecentlyView_Previews: PreviewProvider {
    @State static var record: Record? = nil
    @State static var isEdit = false
    
    static var previews: some View {
        RecentlyView(record: $record, isEdit: $isEdit)
    }
}



struct Record {
    let id: Int64
    let url: String
    let type: Int
    let date: String // 修改为 String 类型
}
