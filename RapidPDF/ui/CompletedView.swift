//
//  CompletedView.swift
//  RapidPDF
//
//  Created by 周波 on 2024/7/24.
//

import SwiftUI

struct CompletedView: View {
    @Environment(\.presentationMode) var presentationMode
    var url:String
    var title:String
    var body: some View {
        NavigationView {
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
                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                
                Image("completed")
                    .padding(.top,30)
                
               
                HStack {
                    Image("ppt")
                    
                    Text("Midnight in Chel.pptx")
                }
                Text("Size:2M")
                
                
                HStack(){
                    Button(action: {}) {
                        HStack {
                            Image("backc")
                            Text("Return")
                                .foregroundColor(Color.red)
                                .bold()
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
                            Image("down")
                        
                            Text("Download")
                                .foregroundColor(Color.white)
                                .bold()
                        }
                       
                        .padding(.all,8)
                        .padding(.horizontal,5)
                        .background(Color.red)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 2)
                        )
                    }

                }.padding(.horizontal,20)
                Spacer()
            }.edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }  .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CompletedView(url:"i",title: "Dlkshv")
}
