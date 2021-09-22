//
// ContentView.swift
// knowledgeSearch
//
// Created by koyasu on 2021/08/16.
//

import SwiftUI
struct ContentView: View {
  @ObservedObject var communication = Communication()
  @State var isShowMenu = false
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
        GeometryReader { geometry in
          ZStack(alignment: .bottomTrailing){
            List{
              HStack{
                TextField("キーワード入力", text: $communication.keyword)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                Button( 
                  action: {
                    communication.get_facet()
                    communication.search()
                    if communication.APIData.count > 0{
                      print(communication.APIData[0].accident_date,communication.APIData.count)
                    }
                  }){
                  Text("検索")
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
              ForEach(communication.APIData) { data in
                NavigationLink(destination: DetailView(data: data)) {
                  VStack{
  //                  Text("災害種別")
  //                  Text("業種:\(data.industry_large!)")
  //                  Text("災害状況：\(data.htclear_text![0])")
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
                    }
                  }
                }
              }
            }
            //ボタン追加
            Button(
              action: {
                print(isShowMenu)
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
          }
        }
        .navigationBarTitle(Text("ナレッジ検索"))
      }
    }
  }
}
