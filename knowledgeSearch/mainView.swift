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
                    ForEach(communication.APIData) { data in
//                        let index = communication.APIData.firstIndex(of: data)
                        VStack{
                            NavigationLink(destination: DetailView(data: data)) {
//                                Text(index)
                                Text("災害種別:"+data.disaster_type)
                                Text("業種:"+data.industry_large)
                                Text("事故発生年月:"+data.accident_date)
                                Text("事故分類:"+data.accident_type)
                            }
                        }
                    }
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
                }
                .navigationBarTitle(Text("検索"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
