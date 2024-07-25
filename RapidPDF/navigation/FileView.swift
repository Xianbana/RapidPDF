import SwiftUI

struct FileView: View {
    @State private var selectedTab: String = "PDF"
    let tabs = ["All","PDF", "Word", "Excel", "PNG","PPT","Image"]

    
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(height: UIApplication.statusBarHeight+44)
                        .foregroundColor(Color.red)
                    
                    HStack{
                        Spacer()
                        Text("File")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                    }.padding(.bottom,5)
                }
                
                VStack {
                    HStack {
                        ForEach(tabs, id: \.self) { tab in
                            VStack {
                                Text(tab)
                                    .font(.callout)
                                    .foregroundColor(selectedTab == tab ? .black : .gray)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedTab = tab
                                        }
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
                 
                   
                  
                    Text("\(selectedTab) 文件视图")
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                }.padding(.top,55)
          
            
                
                Spacer()

                
            }.edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
    
}

#Preview {
    FileView()
}
