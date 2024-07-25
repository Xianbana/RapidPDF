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
            ZStack {
               
                
                VStack {
                    Spacer()
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200.0, height: 200.0)
                        .cornerRadius(10.0)
                      
                    Spacer()
                    
                    ZStack {
                       
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 262, height: 10)
                            .cornerRadius(30.0)
                        
                        // 进度条
                        ProgressView(value: progress, total: 100)
                            .padding([.leading, .trailing], 5)
                            .frame(width: 262, height: 200)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.red))
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
                    }
                    
                    Spacer()
                    Image("startbg").edgesIgnoringSafeArea(.bottom)
                }
                .navigationBarHidden(true)
                
              
                NavigationLink(destination: ContentView(), isActive: $isCompleted) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarHidden(true)
//            .onReceive(adManager.$adClosed) { adClosed in
//                // 处理广告关闭事件
//                if adClosed {
//                    print("广告已关闭")
//                    
//                    closeAd = true
//                    // 在这里执行任何您想要的操作，例如导航到主内容视图等
//                }
//            }


        }.navigationViewStyle(StackNavigationViewStyle())

    }
    
//    // 启动Google Mobile Ads SDK
//    private func startGoogleMobileAdsSDK() {
//        DispatchQueue.main.async {
//            GADMobileAds.sharedInstance().start { status in
//                // 加载广告
//                loadAd()
//            }
//        }
//    }
//
//    // 加载广告
//    private func loadAd() {
//        Task {
//            await AppOpenAdManager.shared.loadAd()
//            adLoaded = true
//            // 尝试展示广告
//            showAdIfAvailable()
//        }
//    }
//
//    // 如果广告已加载，则展示广告
//    private func showAdIfAvailable() {
//        if adLoaded {
//            DispatchQueue.main.async {
//                AppOpenAdManager.shared.showAdIfAvailable()
//            }
//        }
//    }
}
#Preview {
    SplashView()
}
