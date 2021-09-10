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
        if data.accident_date != nil{
            Text(data.accident_date!)
        }
    }
}
