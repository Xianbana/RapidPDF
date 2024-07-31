import SwiftUI

struct ConvertView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var uploadProgress: CGFloat = 0.0  // 进度状态
    @State private var isLoading = false
    @State private var isCompeleted = false
    @State private var size = "0.0"
    @State private var downUrl = ""
    var url:URL
    @State private var uploadTask: URLSessionUploadTask?
    @State private var isReturn = false
    @State private var isCancel = false
    @State private var showAlert = false
    var conversionArray :[Int]
    var body: some View {
        NavigationView {
            
            ZStack{
                if isLoading {
                    LoadingView(lottie: "loading",content: "Converting")
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
                            Text(getFileConversionDescription(from: conversionArray))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                    }
                    
                    ProgressCircleView(progress: $uploadProgress)
                        .padding(.top,30)
                    
                    
                    Text("Processing a file suchas pdf,please wait.")
                    
                    HStack {
                        Image(extractFileExtension(from: "\(url)"))
                            .onAppear{
                                print("image:",url,extractFileExtension(from: "\(url)"))
                            }
                        
                        Text(url.lastPathComponent)
                    }
                    Text("Size:\(size)")
                    
                    
                    HStack(){
                        Button(action: {
                            isReturn = true
                            uploadTask?.cancel()
                            
                        }) {
                            HStack {
                                Image("backc")
                                Text("Return")
                                    .foregroundColor(.red)
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
                        
                        
                        Button(action: {}) {
                            HStack {
                                Image("cancel")
                                
                                Text("Cancel")
                                    .foregroundColor(.red)
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
                        
                    }.padding(.horizontal,20)
                    Spacer()
                }
                
              
                
                NavigationLink(destination: CompletedView(url: downUrl,title:getFileConversionDescription(from: conversionArray)),isActive: $isCompeleted ) {
                    EmptyView()
                } .hidden()
                
                NavigationLink(destination: ContentView(),isActive: $isReturn) {
                    EmptyView()
                } .hidden()
                
                
            }.onAppear{
                print(fileTypeString(from: conversionArray[0]),"to",fileTypeString(from: conversionArray[1]))
                if let sizeInMB = fileSizeInMB(at: url) {
                    size = sizeInMB
                } else {
                    print("Unable to determine file size.")
                }
                
                //   let fileURL = URL(fileURLWithPath: url)
                let uploadURL = URL(string: "https://yotepu.com/PDFConverterPro/conversion")!
                uploadTask = uploadFile(fileURL: url, filetype: fileTypeString(from: conversionArray[0]), outputtype: fileTypeString(from: conversionArray[1]), to: uploadURL, progress: { percent in
                    print(percent)
                    DispatchQueue.main.async {
                        uploadProgress = CGFloat(percent * 100)
                        if percent >= 1{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isLoading = true
                                    }
                        }
                    }
                }) { result in
                    switch result {
                    case .success(let message):
                        self.isLoading=false
                        
                        if let jsonData = message.data(using: .utf8) {
                            let decoder = JSONDecoder()
                            do {
                                let response = try decoder.decode(APIResponse.self, from: jsonData)
                                if response.code == 200{
                                    isCompeleted = true
                                    downUrl = response.result
                                }
                                else{
                                    showAlert = true
                                }
                            } catch {
                                showAlert = true
                            }
                        }
                       
                    case .failure(let error):
                        showAlert = true
                    }
                }
                
              
                
            }
            .alert(isPresented: $showAlert) {
                           Alert(
                               title: Text("Conversion results"),
                               message: Text("Conversion failed, please try again later."),
                               dismissButton: .default(Text("OK"))
                           )
                       }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

//struct ConvertView_Previews: PreviewProvider {
//
//
//    static var previews: some View {
//        let fileURL = URL(fileURLWithPath: "file:///private/var/mobile/Containers/Data/Application/7530592D-F93B-4DE2-BB63-F992DFB5DAF0/tmp/11111.pdf")
//
//        ConvertView(url:fileURL)
//    }
//}


import SwiftUI

struct ProgressCircleView: View {
    @Binding var progress: CGFloat
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                
                Circle()
                    .trim(from: 0.0, to: min(progress / 100, 0.99)) // 最大值限制为0.99
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear(duration: 0.1), value: progress)
                
                Text(String(format: "%.0f %%", progress))
                    .font(.largeTitle)
                    .bold()
            }
            .frame(width: 200, height: 200)
        }
    }
}


import SwiftUI
import Combine

class ProgressViewModel: ObservableObject {
    @Published var displayedProgress: CGFloat = 0.0
    @Published var progress: CGFloat = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    private var timer: Timer?
    private var progressUpdateInterval: TimeInterval = 0.1
    private var slowUpdateInterval: TimeInterval = 1.0
    private var isSlowUpdating = false
    
    func startProgress() {
        // 取消现有定时器
        timer?.invalidate()
        
        // 创建新的定时器来更新进度
        timer = Timer.scheduledTimer(withTimeInterval: progressUpdateInterval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.displayedProgress < self.progress {
                self.displayedProgress = min(self.displayedProgress + 1.0, self.progress)
                self.isSlowUpdating = false
            } else if self.displayedProgress > self.progress {
                self.displayedProgress = max(self.displayedProgress - 1.0, self.progress)
                self.isSlowUpdating = true
            }
            
            // 调整更新频率
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: self.isSlowUpdating ? self.slowUpdateInterval : self.progressUpdateInterval, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.displayedProgress < self.progress {
                    self.displayedProgress = min(self.displayedProgress + 1.0, self.progress)
                } else if self.displayedProgress > self.progress {
                    self.displayedProgress = max(self.displayedProgress - 1.0, self.progress)
                }
            }
            RunLoop.current.add(self.timer!, forMode: .common)
        }
    }
    
    private func updateProgress() {
        startProgress()
    }
}




struct LoadingView: View {
    var lottie:String
    var content:String
    var body: some View {
        VStack {
            LottiePlayer(name: lottie)
                .frame(width: 180, height: 180)
                .padding()
            Text(content)
                .bold()
                .padding(.top,-10)
            Spacer()
        }
        .frame(width: 250, height: 250)
        .background(Color("mainback"))
       
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
