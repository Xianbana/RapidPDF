import SwiftUI
struct SelectFileView: View {
    @State var isSelect = false
    @Binding var showDetail: Bool
    @State private var selectedFileURL: URL?
    @State private var showDocumentPicker = false
    @State private var showFilePreview = false
    @State private var isConvert = false
    @State var isMain = false
   @State private var conversion :[Int] = [0,1]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(height: UIApplication.statusBarHeight+44)
                        .foregroundColor(Color.red)
                    
                    HStack{
                        Image("back")
                            .padding(.leading)
                            .onTapGesture {
                                withAnimation {
                                    showDetail = false
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        Spacer()
                        Text("Select File")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.trailing,36)
                        Spacer()
                        
                    }.padding(.bottom,5)
                }
                
                
                Image("select")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height / 2.03)
                
                VStack(spacing:0){
                    HStack{
                        Text("Convert PDF to Word")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                        Spacer()
                        
                    }.padding(.leading)
                    TextView(text: "Perfect corwersion data")
                    TextView(text: "Secondary editing of documents is more convenient")
                    TextView(text: "Easy copy of text data and real-time  comversion")
                    TextView(text: "Easy copy of text data and real-time  comversion")
                    
                    
                    
                    Button(action: {
                        self.isSelect.toggle()
                        showDocumentPicker = true
                       
                    }) {
                        Text("Select the file")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(30)
                            .font(.title2)
                        
                    }
                    .padding()
                    
                    
                    Spacer()
                }.background(Color("mainback"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
              
                
                NavigationLink(destination: ContentView(),isActive: $isMain) {
                    EmptyView()
                } .hidden()
                
                NavigationLink(destination: ConvertView(url: selectedFileURL ?? URL(string: "https://cnstus.com/pdfConversionWizard/transition")!,conversionArray:conversion),isActive: $isConvert) {
                    EmptyView()
                } .hidden()
                
                
                Spacer()
            }
            .onAppear{
               conversion = getConversionArray(forKey: "conversionArrayKey")
            }
            .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showDocumentPicker) {
                
             let type =  utTypes(for: conversion[0])
               
                DocumentPicker(selectedFileURL: $selectedFileURL,type:type) { fileURL in
                    
                    selectedFileURL = fileURL
                    self.isConvert.toggle()
                    
               }
            }
            .sheet(isPresented: $showFilePreview) {
                if let fileURL = selectedFileURL {
                    
                
                 FilePreviewController(url: fileURL, isPresented: $showFilePreview)
                }
            }
    }
}


//struct SelectFileView_Previews: PreviewProvider {
//    @State static var showDetail = true
//    
//    static var previews: some View {
//        SelectFileView(showDetail: $showDetail,conversionArray:[0,1])
//    }
//}

struct TextView: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text("•")
                .font(.title)
                .frame(alignment: .center)
            
            Text(text)
                .frame(maxHeight: .infinity, alignment: .center)
            
            Spacer()
        }
        .padding(.leading)
    }
}
