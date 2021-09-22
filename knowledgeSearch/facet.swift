//
//  facet.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/09/22.
//

import Foundation

struct facets{
    let facets:[String:facet]
}

struct facet{
    let name:String
    let count:Int
}
