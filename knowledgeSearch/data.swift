//
//  data.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/08/26.
//

import Foundation

struct datas {
    var data : apiData
    var index : Int
}

struct apiData: Codable,Identifiable,Equatable {
    let accident_date:String?
    let accident_time:String?
    let accident_type:String?
    let age:String?
    let cause_large:String?
    let cause_medium:String?
    let cause_small:String?
    let clear_text:String?
    let disaster_type:String?
    let htaccident_type:String?
    let htcause_large:String?
    let htcause_medium:String?
    let htcause_small:String?
    let htclear_text:[String]?
    let htindustry_large:String?
    let htindustry_medium:String?
    let htindustry_small:String?
    let htmachine_name:String?
    let id:String?
    let index:Int?
    let industry_large:String?
    let industry_medium:String?
    let industry_scale:String?
    let industry_small:String?
    let machine_name:String?
    let numFound:Int?
}
