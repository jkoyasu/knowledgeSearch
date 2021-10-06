//
//  facet.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/09/22.
//
import Foundation

struct facets: Codable{
    let disaster_type_facets:[facet]
    let industry_large_facets:[facet]
    let industry_medium_facets:[facet]
    let industry_small_facets:[facet]
}

struct facet: Codable,Identifiable,Equatable {
    let id = UUID()
    let count:Int
    let name:String
}
