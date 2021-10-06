//
// ContentView.swift
// knowledgeSearch
//
// Created by koyasu on 2021/08/16.
//

import SwiftUI
struct ContentView: View {
    @EnvironmentObject var communication:Communication
    @State var isShowMenu = false
    var body: some View {
        if !communication.islogin {
            Button(
                action: {
                    communication.login()
                }){
                Text("ログイン")
            }
        }else{
            NavigationView {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomTrailing){
                        List{
                            HStack{
                                TextField("キーワード入力", text: $communication.keyword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button(
                                    action: {
                                        print("buttonpushed")
                                    }){
                                    Text("検索")
                                }.onTapGesture{
                                    communication.get_facet()
                                    communication.search()
                                }
                            }
                            if communication.APIData.count > 0{
                                HStack{
                                    //Spacer()
                                    Button(
                                        action: {
                                            print("goback pushed")
                                        }){
                                        Text("前へ")
                                            .foregroundColor(communication.cangoback ? Color.blue: Color(UIColor.lightGray))
                                    }.onTapGesture{
                                        communication.start -= 20
                                        communication.search()
                                    }
                                    .disabled(!communication.cangoback)
                                    Spacer()
                                    let startRow: Int? = communication.start + 1
                                    let endRow: Int?  = communication.start + 20
                                    Text("\(startRow!)~\(endRow!)件目")
                                    Spacer()
                
                                    Button(
                                        action: {
                                            print("goforward pushed")
                                        }){
                                        Text("次へ")
                                            .foregroundColor(communication.cangoforward ? Color.blue: Color(UIColor.lightGray))
                                    }.onTapGesture{
                                        communication.start += 20
                                        communication.search()
                                    }
                                    .disabled(!communication.cangoforward)
                                    //Spacer()
                                
                                }//HStack
                                .padding()
                            }//「前へ」「次へ」の行
                
                            ForEach(communication.APIData) { data in
                                NavigationLink(destination: DetailView(data: data)) {
                                    VStack{
                                        HStack {
                                            Text("災害種別:\(data.disaster_type!)")
                                                .font(.headline)
                                            Spacer()
                                        }
                
                                        VStack{
                                            HStack{
                                                Text("災害状況:")
                                                    .font(.headline)
                                                Spacer()
                                            }
                                            HStack{
                                                Text(data.htclear_text![0])
                                                Spacer()
                                            }
                                        }
                
                    
                                        HStack{
                                            // group{
                                            if let accident_date = data.accident_date{
                                                let startIndex = accident_date.index(accident_date.startIndex, offsetBy: 5)
                                                let endIndex = accident_date.index(accident_date.startIndex,offsetBy: 6)
                                                let revdate = accident_date.prefix(4)+"/"+accident_date[startIndex...endIndex]
                                                Text(revdate + data.accident_type!)
                                                    .font(.headline)
                                                    .foregroundColor(Color.red)
                                                Spacer()
                                            }// if文
                                        }//Hstack
                            
                            
                                    }//Vstack
                        
                                }//Navigation Link
                            }//ForEach(communication.APIData)
                
                            if communication.APIData.count > 0{
                                HStack{
                                //Spacer()
                
                                    Button(
                                        action: {
                                            print("goback pushed")
                                        }){
                                        Text("前へ")
                                            .foregroundColor(communication.cangoback ? Color.blue: Color(UIColor.lightGray))
                                    }.onTapGesture{
                                        communication.start -= 20
                                        communication.search()
                                    }
                                    .disabled(!communication.cangoback)
                                
                                
                                    Spacer()
                                    let startRow: Int? = communication.start + 1
                                    let endRow: Int? = communication.start + 20
                                    Text("\(startRow!)~\(endRow!)件目")
                                    Spacer()
                    
                                    Button(
                                        action: {
                                            print("goforward pushed")
                                    }){
                                        Text("次へ")
                                        .foregroundColor(communication.cangoforward ? Color.blue: Color(UIColor.lightGray))
                                    }.onTapGesture{
                                        communication.start += 20
                                        communication.search()
                                    }
                                    .disabled(!communication.cangoforward)
                                    //Spacer()
                
                                }//HStack
                                .padding()
                            }//APIDataの有無
                        }//List
                        
                        if communication.facet != nil{
                            Button(
                                action: {
                                    isShowMenu = true
                            }){
                            Text("絞り込み")
                        }
                        .padding()
                        .accentColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(26)
                        .shadow(color: Color.purple, radius: 15, x: 0, y: 5)
                        .offset(x: -10, y: -10)
                        MenuViewWithinSafeArea(isShowMenu: $isShowMenu,bottomSafeAreaInsets: geometry.safeAreaInsets.bottom)
                            .ignoresSafeArea(edges: .bottom)
                        }//facet有無
                    }//ZStack
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }
                }//GeometoryReader
                .navigationBarTitle(Text("ナレッジ検索"), displayMode: .inline)
            }//NavigationView
        }//Loginのif
    }//body
}//struct

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
