//
//  CompletedView.swift
//  RapidPDF
//
//  Created by 周波 on 2024/7/24.
//

import SwiftUI

struct CompletedView: View {
    @Environment(\.presentationMode) var presentationMode
    var url:String
    var title:String
    @State private var isDownload = false
    @State private var downloading = false
    @State private var isBack = false
    @State private var size = "calculating"
    @State private var fileVar:URL = URL(fileURLWithPath: "savedFilePath")
    var body: some View {
        NavigationView {
            ZStack{
                if isDownload {
                    LoadingView(lottie: "download",content: "Downloading")
                        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                }
                
                VStack(spacing: 20) {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .frame(height: UIApplication.shared.statusBarFrame.height + 44)
                            .foregroundColor(Color.red)
                        
                        HStack {
                            Image("back")
                                .padding(.leading)
                                .onTapGesture {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            Spacer()
                            Text(title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                    }
                    
                    Image("completed")
                        .padding(.top,30)
                    
                    
                    HStack {
                        Image(extractFileExtension(from: url))
                        
                        Text( extractFileName1(from: url))
                    }
                    
                    Text("Size:\(size)")
                   
                    
                    
                    HStack(){
                        Button(action: {
                           isBack = true
                        }) {
                            HStack {
                                Image("backc")
                                Text("Return")
                                    .foregroundColor(Color.red)
                                    .bold()
                            }
                            
                            .padding(.all,8)
                            .padding(.horizontal,5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: ContentView(),isActive: $isBack) {
                            EmptyView()
                        } .hidden()
                        
                        Button(action: {
                            isDownload = true
                            downloadFile(from: url) { result in
                                switch result {
                                case .success(let fileURL):
                                    print("download save url:",fileURL)
                                    DatabaseManager.shared.insert(url: "\(fileURL)", type: fileTypeInt(from:url), date: currentDateString())
                                    isDownload = false
                                    downloading = true
                                isBack = true
                                case .failure(let error):
                                    print("Failed to download file: \(error)")
                                }
                            }
                        }) {
                            HStack {
                                Image("down")
                                
                                Text("Download")
                                    .foregroundColor(Color.white)
                                    .bold()
                            }
                            
                            .padding(.all,8)
                            .padding(.horizontal,5)
                            .background(Color.red)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                        }
                        
                    }.padding(.horizontal,20)
                       
                    
                    Spacer()
                }
                .onAppear{
                    print(url)
                    getFileSizeInMB(urlString: url) { fileSizeString in
                        if let fileSizeString = fileSizeString {
                          size = fileSizeString
                        } else {
                            print("无法获取文件大小")
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
            
        
        } 
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }

}

//#Preview {
//    CompletedView(url:"i",title: "Dlkshv")
//}
