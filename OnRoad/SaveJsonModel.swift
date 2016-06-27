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
    
    func getJson()
    {
        Alamofire.request(.GET, requestURL!, parameters: ["acl:consumerKey": acl])
            .responseJSON {responce in
                if responce.result.isSuccess {
                    let json: JSON = JSON(responce.result.value!)
                    
                    let count = json.count
                    
                    for i in 0...count
                    {
                        if json[i]["frameworx:operationName"].string == "荷積" || json[i]["frameworx:operationName"].string == "荷卸"
                        {
                            let startString = json[i]["frameworx:operationStart"].string!
                            let endString = json[i]["frameworx:operationEnd"].string!
                            
                            let start = startString.toDate()!
                            let end = endString.toDate()!

                            let geoPoint = NCMBGeoPoint(latitude: json[i]["geo:lat"].doubleValue, longitude: json[i]["geo:long"].doubleValue)
                            let title = json[i]["frameworx:operationName"].string
                            
                            // クラスのNCMBObjectを作成
                            let obj2 = NCMBObject(className: "Opendata1")
                            // オブジェクトに値を設定
                            obj2.setObject(geoPoint, forKey: "Location")
                            obj2.setObject(start, forKey: "StartTime")
                            obj2.setObject(end, forKey: "EndTime")
                            obj2.setObject(title, forKey: "Title")
                            // データストアへの保存を実施
                            obj2.saveEventually { (error: NSError!) -> Void in
                                if error != nil {
                                    // 保存に失敗した場合の処理
                                }else{
                                    // 保存に成功した場合の処理
                                }
                            }
                        }
                        
                    }
                    
                }
                else
                {
                    print("can't open")
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

