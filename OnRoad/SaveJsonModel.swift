//
//  GetJsonModel.swift
//  OnRoad
//
//  Created by 冨平準喜 on 2016/06/26.
//  Copyright © 2016年 冨平準喜. All rights reserved.
//

import Alamofire
import NCMB

class SaveJsonModel: NSObject {
    
    let url = "https://api.frameworxopendata.jp/api/v3/files/digitacho_report/"
    let acl = "321a9095e91da49809fe209f42eba1339944603ed608abdaa1ebae5f514f4e42"
    var requestURL:String?
    
    init(str:String) {
        self.requestURL = url + str + ".json"
    }
    
    func checkSaved(str:String,callback:Bool? -> Void)
    {
        let query = NCMBQuery(className: "Opendata1")
        query.whereKey("DateStr", equalTo: str)
        
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                print("error")
                callback(nil)
                
            }else{
                if objects.count == 0
                {
                    callback(false)
                }
                else
                {
                    callback(true)
                }
            }
        })
    }
    func getJson(str:String,callback:String -> Void)
    {
        Alamofire.request(.GET, requestURL!, parameters: ["acl:consumerKey": acl])
            .responseJSON {responce in
                if responce.result.isSuccess {
                    let json: JSON = JSON(responce.result.value!)
                    
                    var successCount = 0
                    
                    let count = json.count
                    
                    for i in 0...count-1
                    {
                        if json[i]["frameworx:operationName"].string == "荷積" || json[i]["frameworx:operationName"].string == "荷卸"
                        {
                            let startString = json[i]["frameworx:operationStart"].string!
                            let endString = json[i]["frameworx:operationEnd"].string!
                            
                            let start = startString.toDate()!
                            let end = endString.toDate()!

                            let geoPoint = NCMBGeoPoint(latitude: json[i]["geo:lat"].doubleValue, longitude: json[i]["geo:long"].doubleValue)
                            let title = json[i]["frameworx:operationName"].string
                            let carType = json[i]["frameworx:carType"].string
                            
                            // クラスのNCMBObjectを作成
                            let obj2 = NCMBObject(className: "Opendata1")
                            // オブジェクトに値を設定
                            obj2.setObject(geoPoint, forKey: "Location")
                            obj2.setObject(start, forKey: "StartTime")
                            obj2.setObject(end, forKey: "EndTime")
                            obj2.setObject(title, forKey: "Title")
                            obj2.setObject(carType, forKey: "carType")
                            obj2.setObject(str, forKey: "DateStr")
                            // データストアへの保存を実施
                            obj2.saveEventually { (error: NSError!) -> Void in
                                if error != nil {
                                    // 保存に失敗した場合の処理
                                    print("error"+String(i))
                                }else{
                                    // 保存に成功した場合の処理
                                    successCount += 1
                                    print("success"+String(i))
                                }

                            }
                        }
                        if i == count - 1
                        {
                            callback(String(successCount)+"/"+String(count)+"が保存出来ました．")
                        }
                    }
                }
                else
                {
                    print("can't open")
                    callback("エラー")
                }
                
        }
    }
}


extension String {
    func chopPrefix(count: Int = 1) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(count))
    }
    
    func chopSuffix(count: Int = 1) -> String {
        return self.substringToIndex(self.endIndex.advancedBy(-count))
    }
    func toDate() -> NSDate? {
        let short = self.chopSuffix(6)
        let time = short.stringByReplacingOccurrencesOfString("T", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
        let date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.locale = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return date_formatter.dateFromString(time)
    }
}

