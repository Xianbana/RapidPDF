import SwiftUI


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
                            .edgesIgnoringSafeArea(.all)
                    }
                    Rectangle()
                        .frame(height: UIApplication.statusBarHeight+54)
                        .foregroundColor(Color.red)
                        .edgesIgnoringSafeArea(.top)
                    HStack{
                        Spacer()
                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading)
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
            }.padding(.leading,10)
            
        }
    }
}
#Preview {
   // HomeTitleView(title: "title")
   TitleView(title: "title")
}

