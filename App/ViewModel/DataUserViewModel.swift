//
//  DataUserViewModel.swift
//  App
//
//  Created by mac on 2024/9/26.
//

import UIKit

class DataUserViewModel{
    var datas: DataUser = DataUser(name: "", kokoid: "")
    var reloadData: (() ->())?
    
    func getData(){
        let url = URL(string:"https://dimanyen.github.io/man.json")
        ApiClient.getDataFromServer(url: url!){ (success, data) in
            if success{
                do{
                    let object = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    let jsonArray = object?["response"] as? [[String:Any]]
                    self.datas.name = jsonArray?[0]["name"] as? String ?? ""
                    self.datas.kokoid = jsonArray?[0]["kokoid"] as? String ?? ""
                    self.reloadData?()
                }
                catch{
                }
            }
        }
    }
}
