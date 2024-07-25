import SwiftUI

struct SplashView: View {
    @State private var progress: Double = 0
    @State private var isCompleted: Bool = false
    @State private var totalTime: Double = 3
    @State private var adLoaded: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                LinearGradient(gradient: Gradient(colors: [Color("title"), Color.white]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                Image("icon")
                
                
            }
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: totalTime / 100.0, repeats: true) { timer in
                    progress += 1
                    if progress >= 100 {
                        timer.invalidate()
                        isCompleted = true
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
            }
            
            .navigationBarHidden(true)
            
        }
        
        NavigationLink(destination: ContentView(), isActive: $isCompleted) {
            EmptyView()
        }
        .hidden()
        
        
    }
}

#Preview {
    SplashView()
}
