import SwiftUI

struct SplashView: View {
    @State private var progress: Double = 0
    @State private var progressInt: Int = 0
    @State private var isCompleted: Bool = false
    @State private var adLoaded: Bool = false
    @State private var closeAd: Bool = false
//    @StateObject var adManager = AppOpenAdManager.shared

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                
              

                
                Image("icon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200.0, height: 200.0)
                    .cornerRadius(10.0)
                
                // 进度条
                ProgressView(value: progress, total: 100)
                    .padding([.leading, .trailing], 5)
                    .frame(width: 200)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.red))
                    .padding(.top, 30)
                    .onAppear {
                        // 开始加载广告
                        // startGoogleMobileAdsSDK()
                        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
                            progress += 1
                            progressInt += 1
                            if progressInt >= 100 {
                                timer.invalidate()
                                isCompleted = true
                            }
                        }
                    }
                
                Spacer()
                
                Image("st")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: ContentView(), isActive: $isCompleted) {
                    EmptyView()
                }
                .hidden()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    func menuButton(imageName: String, title: String) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24) // 设置图片大小，可以根据需要调整
                Text(title)
                    .font(.system(size: 16))
                    .padding(.leading, 8) // 图片和文本之间的间距
                Spacer()
            }
            .padding(.all, 10)
            
            Rectangle()
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, maxHeight: 10) // 10 是分割线的高度
        }
    }
}

#Preview {
    SplashView()
}
struct MenuItem: View {
    var imageName: String
    var text: String
    var rectangleHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Image(imageName)
                Text(text)
                    .frame(width: 100, alignment: .leading) // 设置固定宽度
                Spacer()
            }
            .padding(.all, 10)
            
            if rectangleHeight > 0 {
                Rectangle()
                    .foregroundColor(Color("mainback"))
                    .frame(maxWidth: .infinity, maxHeight: rectangleHeight)
            }
        }
    }
}
