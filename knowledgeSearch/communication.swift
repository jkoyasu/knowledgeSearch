//
//  communication.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/08/23.
//

import Alamofire
import SwiftUI

class Communication:ObservableObject{
    
//    let baseURL = "http://knowledge-search.intra.sharedom.net/qa_api/"
    var component = URLComponents()
    let scheme = "http"
    let host = "192.168.2.108"
    let port = 8000
    var token = UserDefaults.standard.string(forKey: "token") ?? ""
    var keyword = ""
    var start = 0
    var rows = "20"
    var cangoback: Bool {
        return start > 0
    }
    var cangoforward: Bool {
        return start < APIData[0].numFound ?? 0
    }
    
    @Published var APIData : [apiData] = []
    @Published var facet : facets?
    @Published var islogin = UserDefaults.standard.bool(forKey: "islogin") ?? true
    @Published var selectedtype : [String] = []
    @Published var selectedlarge : [String] = []
    @Published var selectedmed : [String] = []
    @Published var selectedsmall : [String] = []
    
    func login(){
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/api/token/"
        guard let url = component.url else {
            return
        }
//        let musername = "admin".data(using: .utf8)!
//        let mpassword = "mcsy1234".data(using: .utf8)!
        let username = "admin"
        let password = "mcsy1234"


        let headers: HTTPHeaders = [
            "Content-type": "application/json"
        ]
        
        let parameters = [
            "username": username,
            "password": password
        ]
        
        AF.request(url,
          method: .post,
          parameters: parameters,
          encoding: JSONEncoding.default, headers: headers)
        .responseJSON { response in
            if let result = response.value as? [String: Any] {
                if let statusCode = response.response?.statusCode {
                    
                    self.islogin = true
                    UserDefaults.standard.set(self.islogin, forKey: "islogin")
                    self.token = (result["access"] as? String ?? "")
                    UserDefaults.standard.set(self.token, forKey: "token")
                    print(self.token)
                }else{
                    print("login error")
                }
            }
        }
    }
    
    
    
    func search(){
        selectedtype = []
        selectedlarge = []
        selectedmed = []
        selectedsmall = []
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/get_qa_list/"
        var date = ""
        component.queryItems = [URLQueryItem(name: "qTxt", value: keyword.urlEncoded),URLQueryItem(name: "strDateSearch", value: date),URLQueryItem(name: "rows", value: rows),URLQueryItem(name: "start", value: String(start))]
        var req = URLRequest(url: component.url!)
        req.httpMethod = "GET"
        req.allHTTPHeaderFields = ["Authorization": "JWT " + token]
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data else { return }
            
//            print(data)
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode{
                    DispatchQueue.main.async {
                    self.APIData = try! JSONDecoder().decode([apiData].self, from: data)
                    }
                }else if response.statusCode == 401 {
                    print("認証エラー")
                    self.islogin = false
                    UserDefaults.standard.set(self.islogin, forKey: "islogin")
                }
            }
        }
        task.resume()
    }
    
    func searchfacet(facettype:[String],facetlarge:[String],facetmed:[String],facetsmall:[String]){
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/get_qa_list/"
        var date = ""
        component.queryItems = [URLQueryItem(name: "qTxt", value: keyword.urlEncoded),URLQueryItem(name: "strDateSearch", value: date),URLQueryItem(name: "rows", value: rows),URLQueryItem(name: "start", value: String(start))]
        for i in facettype{
            component.queryItems?.append(URLQueryItem(name: "disaster_type_facets", value: "disaster_type_facets:"+i))
        }
        for i in facetlarge{
            component.queryItems?.append(URLQueryItem(name: "industry_large_facets", value: "industry_large_facets:"+i))
        }
        for i in facetmed{
            component.queryItems?.append(URLQueryItem(name: "industry_medium_facets", value: "industry_medium_facets:"+i))
        }
        for i in facetsmall{
            component.queryItems?.append(URLQueryItem(name: "industry_small_facets", value: "industry_small_facets:"+i))
        }
        var req = URLRequest(url: component.url!)
        print("aiueo\(component.url)")
        req.httpMethod = "GET"
        req.allHTTPHeaderFields = ["Authorization": "JWT " + token]
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data else { return }
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode{
                    DispatchQueue.main.async {
                        self.APIData = try! JSONDecoder().decode([apiData].self, from: data)
                    }
                }else if response.statusCode == 401 {
                    print("認証エラー")
                    self.islogin = false
                    UserDefaults.standard.set(self.islogin, forKey: "islogin")
                }
            }
        }
        task.resume()
    }
    
    func get_facet(facettype:[String],facetlarge:[String],facetmed:[String],facetsmall:[String]){
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/get_facet_fields/"
        var date = ""
        component.queryItems = [URLQueryItem(name: "qTxt", value: keyword.urlEncoded),URLQueryItem(name: "strDateSearch", value: date)]
        for i in facettype{
            component.queryItems?.append(URLQueryItem(name: "disaster_type_facets", value: "disaster_type_facets:"+i))
        }
        for i in facetlarge{
            component.queryItems?.append(URLQueryItem(name: "industry_large_facets", value: "industry_large_facets:"+i))
        }
        for i in facetmed{
            component.queryItems?.append(URLQueryItem(name: "industry_medium_facets", value: "industry_medium_facets:"+i))
        }
        for i in facetsmall{
            component.queryItems?.append(URLQueryItem(name: "industry_small_facets", value: "industry_small_facets:"+i))
        }
        var req = URLRequest(url: component.url!)
        req.httpMethod = "GET"
        req.allHTTPHeaderFields = ["Authorization": "JWT " + token]
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data else { return }
            
//            print(data)
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode{

                    DispatchQueue.main.async {

                        self.facet = try! JSONDecoder().decode(facets.self, from: data)
                        if self.APIData.count > 0{
                            print("ファセット数は",self.facet)
                        }
                    }
                }else if response.statusCode == 401 {
                    print("認証エラー")
                    self.islogin = false
                    UserDefaults.standard.set(self.islogin, forKey: "islogin")
                }
            }
        }
        task.resume()
    }
    
}
    
extension String {
    var urlEncoded: String {
        // 半角英数字 + "/?-._~" のキャラクタセットを定義
        let charset = CharacterSet.alphanumerics.union(.init(charactersIn: "/?-._~"))
        // 一度すべてのパーセントエンコードを除去(URLデコード)
        let removed = removingPercentEncoding ?? self
        // あらためてパーセントエンコードして返す
        return removed.addingPercentEncoding(withAllowedCharacters: charset) ?? removed
    }
}
