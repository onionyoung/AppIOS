//
//  DataFriendViewModel.swift
//  App
//
//  Created by ios on 2024/9/27.
//

import UIKit

class DataFriendViewModel{
    var datas: [DataFriend] = [DataFriend]()
    var confirmDatas: [DataFriend] = [DataFriend]()
    var reloadTableView: (() ->())?
    var showError: (() -> ())?
    var showLoading: (() -> ())?
    var hideLoading: (() -> ())?
    
    func getData(){
        let url = URL(string:"https://dimanyen.github.io/friend1.json")
        ApiClient.getDataFromServer(url: url!){ (success, data) in
            if success{
                do{
                    let object = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    let jsonArray = object?["response"] as? [[String:Any]] ?? []
                    //self.datas.name = jsonArray?[0]["name"] as? String ?? ""
                    //self.datas.kokoid = jsonArray?[0]["kokoid"] as? String ?? ""
                    
                    for json in jsonArray{
                        let name = json["name"] as? String ?? ""
                        let status = json["status"] as? Int ?? -1
                        let isTopString = json["isTop"] as? String ?? "0"
                        let fid = json["fid"] as? String ?? ""
                        let updateDateString = json["updateDate"] as? String ?? ""
                        
                        //檢查isTop只能 0or1
                        var isTop = false
                        if (isTopString == "1"){
                            isTop = true
                        } else if (isTopString == "0"){
                            isTop = false
                        } else{
                            continue
                        }
                        
                        //不應該為空值
                        if (name.isEmpty || fid.isEmpty || updateDateString.isEmpty || status == -1){
                            continue
                        }
                        
                        //檢查日期
                        let dataFormatter = DateFormatter()
                        var updateDate:Date? = nil
                        if (updateDateString.contains("/")){
                            dataFormatter.dateFormat = "yyyy/MM/dd"
                        } else {
                            dataFormatter.dateFormat = "yyyyMMdd"
                        }
                        updateDate = dataFormatter.date(from: updateDateString)
                        if(updateDate == nil){continue}
                        
                        //寫入資料
                        let item = DataFriend(name: name,
                                   status: status,
                                   isTop: isTop,
                                   fid: fid,
                                   updateDate: updateDate!)
                        
                        if (status == 0){
                            self.confirmDatas.append(item)
                        }else {
                            self.datas.append(item)
                        }
                    }
                    self.reloadTableView?()
                }
                catch{
                }
            } else {
                self.showError?()
            }
            
        }
    }

    var numberOfCells: Int{
        return datas.count
    }
    
    func getCellViewModel(at indexPath: IndexPath)-> DataFriend{
        return datas[indexPath.row]
    }
    
    
}
