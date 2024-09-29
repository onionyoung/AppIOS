//
//  DataFriendViewModel.swift
//  App
//
//  Created by ios on 2024/9/27.
//

import UIKit

class DataFriendViewModel{
    var datas: [DataFriend] = [DataFriend]()
    var searchData: [DataFriend] = [DataFriend]()
    var inviteDatas: [DataFriend] = [DataFriend]()
    
    var reloadInviteView: (() -> ())?
    var reloadTableView: (() ->())?
    var showError: (() -> ())?
    var showLoading: (() -> ())?
    var hideLoading: (() -> ())?
    
    var requestArray:[URL] = []
    //從API取得資料
    func getData(myMode:Int){
        var urlString:String = ""
        var urlString2:String = ""
        if(myMode == 1){
            urlString = "https://dimanyen.github.io/friend4.json"
        } else if(myMode == 2){
            urlString = "https://dimanyen.github.io/friend1.json"
            urlString2 = "https://dimanyen.github.io/friend2.json"
        } else if(myMode == 3){
            urlString = "https://dimanyen.github.io/friend3.json"
        }
        //檢查是否有問題
        let url = URL(string:urlString) ?? nil
        if(url == nil){
            showError?()
            return
        }
        //資料確認正確，初始化資料結構
        requestArray.append(url!)
        datas = [DataFriend]()
        searchData = [DataFriend]()
        inviteDatas = [DataFriend]()
        getData(url:url!)
        
        if(myMode == 2){
            let url2 = URL(string:urlString2) ?? nil
            if(url2 == nil){
                showError?()
                return
            }
            requestArray.append(url2!)
            getData(url:url2!)
        }
    }
    
    func getData(url:URL){
        showLoading?()
        ApiClient.getDataFromServer(url: url){ (success, data) in
            if success{
                do{
                    let object = try JSONSerialization.jsonObject(with: data!) as? NSDictionary
                    let jsonArray = object?["response"] as? [[String:Any]] ?? []
                    self.setResponseToData(jsonArray: jsonArray)
                }
                catch{
                    if(self.requestFinish(url: url)){
                        self.showError?()
                    }
                }
            } else {
                if(self.requestFinish(url: url)){                self.showError?()
                }
            }
            if(self.requestFinish(url: url)){
                //分類朋友清單和邀請清單
                self.sortData()
                //更新朋友清單前 過濾關鍵字
                self.searchData(keyword:"")
                //更新邀請清單
                self.reloadInviteView?()
                self.hideLoading?()
            }
        }
    }
    
    //分類朋友清單和邀請清單
    //順序(邀請中(status=2)->置頂朋友(isTop=1)->非置頂朋友(isTop=0)
    func sortData(){
        //邀請中
        var friendDataStatus2:[DataFriend] = [DataFriend]()
        //非置頂中非置頂
        var friendDataStatus1:[DataFriend] = [DataFriend]()
        //置頂
        var starData:[DataFriend] = [DataFriend]()
        
        for item in datas{
            if(item.status == 0){
                inviteDatas.append(item)
            }else if(item.status == 1){
                if(item.isTop == true){
                    starData.append(item)
                }else{
                    friendDataStatus1.append(item)
                }
            }else if(item.status == 2){
                friendDataStatus2.append(item)
            }
        }
        inviteDatas.sort(by: {invite1, invite2 in
            invite1.updateDate > invite2.updateDate
        })
        friendDataStatus1.sort(by: {friend1, friend2 in
            friend1.updateDate > friend2.updateDate
        })
        friendDataStatus2.sort(by: {friend1, friend2 in
            friend1.updateDate > friend2.updateDate
        })
        starData.sort(by: {star1, star2 in
            star1.updateDate > star2.updateDate
        })
        datas = friendDataStatus2 +  starData + friendDataStatus1
    }
    
    
    //request finish
    //如果還有requset還在執行，回傳false
    //全部request執行完，回傳true
    func requestFinish(url:URL)->Bool{
        var i = 0;
        for item in requestArray{
            if(item == url){
                requestArray.remove(at: i)
                break;
            }
            i = i+1
        }
        if(requestArray.count > 0) {return false}
        else {return true}
    }
    //檢查data是否重複
    func checkRepeatData(newItem: DataFriend){
        var i = 0
        var data = self.datas
        for item in data{
            if(item.fid == newItem.fid){
                if(item.updateDate < newItem.updateDate){
                    datas[i] = newItem
                }
                return
            }
            i = i + 1
        }
        datas.append(newItem)
    }
    func setResponseToData(jsonArray:[[String:Any]]){
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
            if(item.fid == "002"){
                print(item)
            }
            //檢查data是否重複
            self.checkRepeatData(newItem: item)
                
        }
    }
    //朋友清單 reload
    func searchData(keyword:String){
        searchData = [DataFriend]()
        //如果keyword為空，直接呈現全部
        if(keyword.isEmpty){
            searchData = datas
            self.reloadTableView?()
            return
        }
        //如果有keyword再塞選
        for item in datas{
            if(item.name.contains(keyword)){
                searchData.append(item)
            }
        }
        self.reloadTableView?()
    }
    var numberOfCells: Int{
        return searchData.count
    }
    func getCellViewModel(at indexPath: IndexPath)-> DataFriend{
        return searchData[indexPath.row]
    }
    
    //邀請列表
    var numberOfInviteCells: Int{
        return inviteDatas.count
    }
    func getInviteCellViewModel(index: Int)-> DataFriend{
        return inviteDatas[index]
    }
    
}
