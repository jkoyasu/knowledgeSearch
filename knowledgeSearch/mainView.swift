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
            NavigationView {
                List{
                    HStack{
                        TextField("キーワード入力", text: $communication.keyword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(
                            action: {
                                communication.search()
                                if communication.APIData.count > 0{
                                    print(communication.APIData[0].accident_date,communication.APIData.count)
                                }
                            }){
                            Text("検索")
                            }
                    }
//                    communication.APIData.enumerated().forEach( { (index,data) in
//                List{
                    if communication.APIData.count > 0{
                        HStack{
                            Spacer()
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
                            Spacer()
                        }
                    }
                        ForEach(communication.APIData) { data in
        //                        let index = communication.APIData.firstIndex(of: data)
          
                            NavigationLink(destination: DetailView(data: data)) {
    //                                Text(index)
                                    
                                VStack{
                                    Text("災害種別")
                                   // Text(data.disaster_type!)
                                    Text("業種:\(data.industry_large!)")
                                    Text("災害状況：\(data.htclear_text![0])")
                                    HStack{
                                       // group{
                                        if let accident_date = data.accident_date{
                                            let startIndex = accident_date.index(accident_date.startIndex, offsetBy: 5)
                                            let endIndex = accident_date.index(accident_date.startIndex,offsetBy: 6)
                                            let revdate = accident_date.prefix(4)+"/"+accident_date[startIndex...endIndex]
                                            Text(revdate + data.accident_type!)
                                                .foregroundColor(Color.red)
                                            Spacer()
                                        }
    //                                        Text("事故分類:\(data.accident_type!)")
    //                                            .foregroundColor(Color.red)
                                    }
                                }
                            }
                        }
                    //}
                }
                .navigationBarTitle(Text("ナレッジ検索"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
