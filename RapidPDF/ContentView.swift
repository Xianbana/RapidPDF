
import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    @State private var showDetail = false
    
    var body: some View {
        NavigationView{
            ZStack {
                if showDetail {
                    SelectFileView(showDetail:$showDetail)
                        .transition(.opacity)
                        .zIndex(1)
                } else {
                    TabView(selection: $selectedTab) {
                        HomeView(showDetail: $showDetail)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                            .tag(0)
                        
                        FileView()
                            .tabItem {
                                Label("File", systemImage: "folder")
                            }
                            .tag(1)
                        
                        SettingView()
                            .tabItem {
                                Label("Settings", systemImage: "gearshape")
                            }
                            .tag(2)
                    }
                    .accentColor(.red)
                }
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}
#Preview {
    ContentView()
}
