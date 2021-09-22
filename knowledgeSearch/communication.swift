//
//  communication.swift
//  knowledgeSearch
//
//  Created by koyasu on 2021/08/23.
//

import Foundation
import Alamofire

class Communication:ObservableObject{
    
    let baseURL = "http://knowledge-search.intra.sharedom.net/"
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
    
    func login(){
        let url = baseURL + "qa_api/api/token/"
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
                    
                }else{
                    print("login error")
                }
            }
        }
    }
    
    
    
    func search(){
        var urlComponents = URLComponents(string:(baseURL + "qa_api/get_qa_list/"))!
        var date = ""
        urlComponents.queryItems = [URLQueryItem(name: "qTxt", value: keyword.urlEncoded),URLQueryItem(name: "strDateSearch", value: date),URLQueryItem(name: "rows", value: rows),URLQueryItem(name: "start", value: String(start))]
        var req = URLRequest(url: urlComponents.url!)
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
                    self.APIData = try! JSONDecoder().decode([apiData].self, from: data)
                    print(self.APIData)
                }else if response.statusCode == 401 {
                    print("認証エラー")
                    self.islogin = false
                    UserDefaults.standard.set(self.islogin, forKey: "islogin")
                }
            }
        }
        task.resume()
    }
    
    func searchfacet(facetname:String,facetvalue:String){
        var urlComponents = URLComponents(string:(baseURL + "qa_api/get_qa_list/"))!
        var date = ""
        urlComponents.queryItems = [URLQueryItem(name: "qTxt", value: keyword.urlEncoded),URLQueryItem(name: "strDateSearch", value: date),URLQueryItem(name: "rows", value: rows),URLQueryItem(name: "start", value: String(start)),URLQueryItem(name: facetname, value: facetname+":"+facetvalue.urlEncoded)]
        var req = URLRequest(url: urlComponents.url!)
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
                    self.APIData = try! JSONDecoder().decode([apiData].self, from: data)
                    print(self.APIData)
                }else if response.statusCode == 401 {
                    print("認証エラー")
                    self.islogin = false
                    UserDefaults.standard.set(self.islogin, forKey: "islogin")
                }
            }
        }
        task.resume()
    }
    
    func  get_facet(){
        var urlComponents = URLComponents(string:(baseURL + "get_facet_fields/"))!
        var date = ""
        urlComponents.queryItems = [URLQueryItem(name: "qTxt", value: keyword.urlEncoded),URLQueryItem(name: "strDateSearch", value: date)]
        var req = URLRequest(url: urlComponents.url!)
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
                    self.facet = try! JSONDecoder().decode(facets.self, from: data)
                    print(self.facet)
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
