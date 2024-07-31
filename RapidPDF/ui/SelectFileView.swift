import SwiftUI

struct SelectFileView: View {
    @State var isSelect = false
    @Binding var showDetail: Bool
    @State private var selectedFileURL: URL?
    @State private var showDocumentPicker = false
    @State private var selectImage = false
    @State private var isConvert = false
    @State var isMain = false
    @State private var conversion: [Int] = [0, 1]
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(height: UIApplication.statusBarHeight + 44)
                        .foregroundColor(Color.red)
                    
                    HStack {
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
                            .padding(.trailing, 36)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                
                GeometryReader { geometry in
                    VStack {
                        Image("select")
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                        
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("Convert PDF to Word")
                                    .font(.title)
                                    .bold()
                                Spacer()
                            }
                            .padding(.leading)
                            
                            TextView(text: "Perfect conversion data")
                            TextView(text: "Secondary editing of documents is more convenient")
                            TextView(text: "Easy copy of text data and real-time conversion")
                            TextView(text: "Easy copy of text data and real-time conversion")
                            
                            Button(action: {
                                self.isSelect.toggle()
                                showDocumentPicker = true
//                                if conversion.first == 5 || conversion.first == 2 {
//                                    selectImage = true
//
//                                
//                                }else{
//                                    self.isSelect.toggle()
//                                    showDocumentPicker = true
//                                }
                                
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
                        }
                        .padding(.top, 20)
                        .background(Color("mainback"))
                        
                        Spacer()
                    }.sheet(isPresented: $selectImage) {
                        ImagePicker { url in
                            selectedFileURL = url
                            self.isConvert.toggle()
                        }
                    }
                }
                
                NavigationLink(destination: ContentView(), isActive: $isMain) {
                    EmptyView()
                }
                .hidden()
                
                NavigationLink(destination: ConvertView(url: selectedFileURL ?? URL(string: "https://yotepu.com/PDFConverterPro/conversion")!, conversionArray: conversion), isActive: $isConvert) {
                    EmptyView()
                }
                .hidden()
            }
            .onAppear {
                conversion = getConversionArray(forKey: "conversionArrayKey")
                
                print("select file data",conversion)
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showDocumentPicker) {
            let type = utTypes(for: conversion[0])
            
            DocumentPicker(selectedFileURL: $selectedFileURL, type: type) { fileURL in
                if isFileLargerThan5MB(atPath: "\(fileURL)") {
                    showAlert = true
                } else {
                    selectedFileURL = fileURL
                    self.isConvert.toggle()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("File Size Check"),
                message: Text("File size cannot exceed 5MB."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

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

struct SelectFileView_Previews: PreviewProvider {
    static var previews: some View {
        SelectFileView(showDetail: .constant(false))
    }
}
