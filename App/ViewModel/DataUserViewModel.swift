//
//  DataUserViewModel.swift
//  App
//
//  Created by mac on 2024/9/26.
//

import UIKit

class DataUserViewModel{
    var datas: [DataUser] = [DataUser]()
    
    
    func getData(){
        let url = URL(string:"https://dimanyen.github.io/man.json")
        ApiClient.getDataFromServer(url: url!){ (success, data) in
            if success{
                do{
                    let object = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    var jsonArray = object?["response"] as? [[String:Any]]
                    
                }
                catch{
                }
            }
        }
    }
}
