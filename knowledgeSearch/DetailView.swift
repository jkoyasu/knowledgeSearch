//
//  DetailView.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/08/26.
//

import SwiftUI

struct DetailView: View {
    var data : apiData
    var body: some View {
        List{
            if let disaster_type = data.disaster_type{
                Text("災害種別："+disaster_type)
            }
            
            Group{
                if let industry_large = data.industry_large{
                    Text("業種（大分類）："+industry_large)
                }

                if let industry_medium = data.industry_medium{
                    Text("業種（中分類）："+industry_medium)
                }

                if let industry_small = data.industry_small{
                    Text("業種（小分類）："+industry_small)
                }
            }
            
            Group{
                if let accident_date = data.accident_date{
                    let startIndex = accident_date.index(accident_date.startIndex, offsetBy: 5)
                    let endIndex = accident_date.index(accident_date.startIndex,offsetBy: 6)
                    let revdate = accident_date.prefix(4)+"年"+accident_date[startIndex...endIndex]+"月"
                    Text("事故発生年月："+revdate)
                }
                
                if let accident_time = data.accident_time{
                    Text("事故発生時間帯："+accident_time)
                }
            }

            if let accident_type = data.accident_type{
                Text("事故分類："+accident_type)
            }

            if let cause_large = data.cause_large{
                Text("起因物（大分類）："+cause_large)
            }

            if let cause_small = data.cause_small{
                Text("起因物（小分類）："+cause_small)
            }
            
            if let industry_scale = data.industry_scale{
                Text("事業場規模："+industry_scale)
            }

            if let htclear_text = data.htclear_text{
                Text("災害状況："+htclear_text[0])
            }
//
//            if let machine_name = data.machine_name{
//                if machine_name != " "{
//                    Text("機械名："+machine_name)
//                }
//            }
            
            //            if var age = data.age{
            //                if age != " "{
            //                    Text("年齢："+age)
            //                }
            //            }
            //
            //            if let htindustry_large = data.htindustry_large{
            //                Text("原因："+htindustry_large)
            //            }
            //
            //            if let htindustry_medium = data.htindustry_medium{
            //                Text("原因："+htindustry_medium)
            //            }
            //
            //            if let htindustry_small = data.htindustry_small{
            //                Text("原因："+htindustry_small)
            //            }
            //
            //            if let htmachine_name = data.htmachine_name{
            //                Text("原因："+htmachine_name)
            //            }
            //
            //            if let id = data.id{
            //                Text("ID："+id)
            //            }
            //
            //            if let index = data.index{
            //                Text("インデックス："+String(index))
            //            }
            
            //            if let clear_text = data.clear_text{
            //                if clear_text != " "{
            //                    Text("："+clear_text)
            //                }
            //            }
            //            if let htaccident_type = data.htaccident_type{
            //                Text("原因："+htaccident_type)
            //            }

            //            if let htcause_large = data.htcause_large{
            //                Text("原因："+htcause_large)
            //            }

            //            if let htcause_medium = data.htcause_medium{
            //                Text("原因："+htcause_medium)
            //            }
            //
            //            if let htcause_small = data.htcause_small{
            //                Text("原因："+htcause_small)
            //            }
            //
            //            if let cause_medium = data.cause_medium{
            //                Text("起因物（中分類）："+cause_medium)
            //            }


        }
    }
}
