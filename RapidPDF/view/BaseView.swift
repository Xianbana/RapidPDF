import SwiftUI
import WebKit
import Lottie



struct LottiePlayer: UIViewRepresentable {
    let name: String
    let animationSpeed: CGFloat
    let loopMode: LottieLoopMode
    
    init(
        name: String,
        animationSpeed: CGFloat = 1.0,
        loopMode: LottieLoopMode = .loop
    ) {
        self.name = name
        self.animationSpeed = animationSpeed
        self.loopMode = loopMode
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct TitleView: View {
    var title: String
    var body: some View {
        
        
        VStack {
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .foregroundColor(Color("mainback"))
                        .frame(width: UIScreen.main
                            .bounds.width, height: UIScreen.main
                            .bounds.height)
                    
                }
                Rectangle()
                    .frame(height: UIApplication.statusBarHeight+54)
                    .foregroundColor(Color.red)
                
                HStack{
                    Spacer()
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                }
            }.frame(height: 44)
            Spacer()
        }
    }
}


struct HomeTitleView: View {
    var title:String = ""
    var body: some View {
        VStack {
            HStack{
                Image("Vector")
                
                Text(title)
                    .padding(.leading,5)
                Spacer()
            }.padding(.leading,20)
            
        }
    }
}
#Preview {
    // HomeTitleView(title: "title")
    TitleView(title: "title")
}

import SwiftUI

struct Back: View {
    var title: String
    var onBackTap: () -> Void
    
    var body: some View {
        
        VStack (spacing:0){
            
            ZStack {
                Rectangle()
                    .frame(height: UIApplication.statusBarHeight+54)
                    .foregroundColor(Color.red)
                    .edgesIgnoringSafeArea(.top)
                HStack{
                    
                    Image("back")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .padding(.leading,20)
                        .onTapGesture {
                            
                            
                            self.onBackTap()
                        }
                    
                    Spacer()
                    Text(title)
                        .font(.title)
                        .foregroundColor(Color.black)
                        .bold()
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
                
            }.frame(height: 44)
            
        }
        
    }
    
}

#Preview {
    Back(title:"More"){
        
    }
}


