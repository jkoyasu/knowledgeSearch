//
//  facet.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/09/22.
//
import Foundation

struct facets: Codable,Identifiable{
    let id:String?
    let maker_facets:[facet]
    let manufaction_device_facets:[facet]
}

struct facet: Codable,Identifiable,Equatable {
    let id:String?
    let count:Int
    let name:String
}
