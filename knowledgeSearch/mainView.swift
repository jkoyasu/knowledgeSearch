//
//  ContentView.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/08/16.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var communication = Communication()
    
    var body: some View {
        if !communication.islogin {
                Button(
                action: {
                    communication.login()
                    print(communication.APIData)
                }){
                Text("ログイン")
                }
        }else{
            Text("ナレッジ検索")
                .bold()

            if communication.APIData.count > 0{
                HStack{ //ここから「前へ」「次へ」ボタン
                    Spacer()
                    .frame(width: 10)
                    Button(
                        action: {
                            print("goback pushed")
//                          communication.start -= 20
//                          communication.search()
                        }){
                        Text("前へ")
                            .foregroundColor(communication.cangoback ? Color.blue: Color(UIColor.lightGray))
                        }.onTapGesture{
                            communication.start -= 20
                            communication.search()
                        }
                    .disabled(!communication.cangoback)
                    Spacer()
                        
                    //let start = communication.start + 1
                    //let goal = communication.start + 20
                    //Text("\(start)件目~\(goal)件目")
                        
                    //Spacer()
                    Button(
                        action: {
                            print("goforward pushed")
//                          communication.start += 20
//                          communication.search()
                        }){
                            Text("次へ")
                                .foregroundColor(communication.cangoforward ? Color.blue: Color(UIColor.lightGray))
                    }.onTapGesture{
                        communication.start += 20
                        communication.search()
                    }
                    .disabled(!communication.cangoforward)
                    Spacer()
                        .frame(width:10)
                }//ここまで「前へ」「次へ」ボタン
            }//ここまでif
            HStack(){//ここから検索フォーム
                Spacer()
                    .frame(width: 10)
                TextField("キーワード入力", text: $communication.keyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(
                    action: {
                        communication.search()
                        if communication.APIData.count > 0{
                            print(communication.APIData[0].accident_date!,communication.APIData.count)
                        }
                    }){
                    Text("検索")
                    }
                Spacer()
                    .frame(width: 10)
            }//ここまで検索フォーム
            Spacer()
            NavigationView {
                //if let apidata = communication.APIData{
                    List{
                        //ここから検索結果の表示部分
                      ForEach(communication.APIData) { data in
                            //let index = communication.APIData.firstIndex(of: data)
             
                            NavigationLink(destination: DetailView(data: data)) {
//                                Text(index)
                                VStack{
                                    HStack(){
//                                     Text("災害種別")
                                        Text("災害種別:\(data.disaster_type!)")
                                        Spacer()
                                    }
    //                              HStack(){
    //                                        Text("業種:\(data.industry_large!)")
    //                                        Spacer()
    //                               }
                                    HStack(){
                                        Text("災害状況：\(data.htclear_text![0])")
//                                      Text("災害状況")
                                        Spacer()
                                    }
                                    HStack{
                                        // group{
                                        if let accident_date = data.accident_date{
                                            let startIndex = accident_date.index(accident_date.startIndex, offsetBy: 5)
                                            let endIndex = accident_date.index(accident_date.startIndex,offsetBy: 6)
                                            let revdate = accident_date.prefix(4)+"/"+accident_date[startIndex...endIndex]
                                            Text(revdate + " " + data.accident_type!)
                                               .foregroundColor(Color.red)
                                            Spacer()
                                        }
                                        Text("事故分類:\(data.accident_type!)")
                                            .foregroundColor(Color.red)
                                    }
                                }
                            }//NavigationLink
                        } //Foreach
                   }//ここまでList
//                }
                .navigationBarHidden(true)
                .navigationBarTitle("ナレッジ検索")
            }//Navigationview
        }//iflogin
    }//body
}//struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
