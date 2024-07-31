import SwiftUI

struct FileView: View {
    @State private var selectedTab: String = "All"
    @State private var records: [Record] = []
    @State private var filteredRecords: [Record] = []
    let tabs = ["All", "PDF", "JPG", "WORD", "TXT", "HTML", "PNG"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(height: UIApplication.shared.statusBarFrame.height + 44)
                        .foregroundColor(Color.red)
                    
                    HStack {
                        Spacer()
                        Text("File")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                
                VStack {
                    HStack {
                        ForEach(tabs, id: \.self) { tab in
                            VStack {
                                Text(tab)
                                    .font(.callout)
                                    .foregroundColor(selectedTab == tab ? .black : .gray)
                                    .onTapGesture {
                                        selectedTab = tab
                                        filterRecords()
                                    }
                                
                                if selectedTab == tab {
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(.blue)
                                        .animation(.default, value: selectedTab)
                                } else {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.clear)
                                }
                            }
                        }
                    }
                    .zIndex(1.0)
                    
                    if filteredRecords.isEmpty {
                        Image("nilfile")
                            .resizable()
                            .scaledToFit()
                            .padding()
                    } else {
                        List(filteredRecords, id: \.id) { record in
                            FileRecentlyView(record: record, records: $records) {
                                // 回调函数，在删除文件后调用
                                self.refreshData()
                            }
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
          
            .onAppear {
                records = DatabaseManager.shared.fetchAllRecords()
                filterRecords()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func filterRecords() {
        if selectedTab == "All" {
            filteredRecords = records
        } else {
            let type = fileTypeInt(from: selectedTab)
            filteredRecords = records.filter { $0.type == type }
        }
    }
    
    func refreshData() {
        records = DatabaseManager.shared.fetchAllRecords()
        filterRecords()
    }
}
import SwiftUI

struct FileRecentlyView: View {
    var record: Record
    @Binding var records: [Record]
    var onDelete: () -> Void  // 回调函数

    @State private var showFilePreview = false
    @State private var showActionSheet = false // State to control showing the action sheet
    
    var body: some View {
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
                        .lineLimit(1)
                        .font(.footnote)
                    
                    Text(record.date)
                        .font(.caption2)
                        .foregroundColor(Color.black)
                        .opacity(0.8)
                })
                
                Spacer()
                
                Button(action: {
                    showActionSheet = true // Trigger action sheet
                }) {
                    Image("more")
                        .padding(.trailing, 10)
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .onAppear {
                print(record)
            }
        }
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
    }
    
    func shareFile(record: Record) {
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
    }
    
    func deleteFile(record: Record) {
        let fileURLString = record.url
        guard let fileURL = URL(string: fileURLString) else {
            print("无效的文件 URL")
            return
        }
        
        DatabaseManager.shared.delete(id: record.id)
        
        // Update records after deletion
        records = DatabaseManager.shared.fetchAllRecords()
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("文件已删除: \(fileURL)")
        } catch {
            print("删除文件时发生错误: \(error.localizedDescription)")
        }
        
        // 调用回调函数
        onDelete()
    }
}
