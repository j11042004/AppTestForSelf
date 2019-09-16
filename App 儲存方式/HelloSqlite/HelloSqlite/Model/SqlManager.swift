//
//  SqlManager.swift
//  HelloSqlite
//
//  Created by Uran on 2018/2/26.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import SQLite3

typealias SearchCompleteHandle = (_ success:Bool , _ results:Array<Dictionary<String, Any?>> ) -> Void
typealias CompleteHandle = (_ success:Bool , _ errorMsg:String?) -> Void

class SqlManager: NSObject {
    static let standard = SqlManager()
    private let tableName = "UserData"
    
    private var db : OpaquePointer? = nil
    
    
    // MARK: 開啟資料庫
    func openDB() {
        let fm = FileManager.default
        // 取得 要加入的 Sqlite
        let src = Bundle.main.path(forResource: "firstdb", ofType: "sqlite")
        // 取得沙盒路徑
//        guard let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else{
//            NSLog("documentsPath is nil")
//            return
//        }
//        NSLog("documentsPath : \(documentsPath)")
        let dst = NSHomeDirectory() + "/Documents/firstdb.sqlite"
        
        if let src = src {
            NSLog("src : \(src) \ndst : \(dst)")
        }else{
            NSLog("dst : \(dst)")
        }
        // 把 要加入的 Sqlite 複製到 指定的位置上
        if !fm.fileExists(atPath: dst){
            do{
                try fm.copyItem(atPath: src!, toPath: dst)
            } catch {
                NSLog("copy error path")
            }
        }
        // 開啟 dst 位置的 Sqlite
        if sqlite3_open(dst, &db) == SQLITE_OK {
            print("DB 開啟成功")
        }else{
            print("DB 開啟失敗")
            db = nil
        }
    }
    
    // MARK: 關閉資料庫
    func closeDB() {
        if db == nil {
            return
        }
        sqlite3_close(db!)
        db = nil
    }
    
    
    // MARK: 搜尋資料庫
    
    /// 搜尋全部的資料庫
    /// - Parameters:
    ///   - showAll: 是否顯示全部資料
    ///   - id: 要尋找的 ID
    ///   - complete: 完成後要做的事
    func searchDB(showAll:Bool , id : String?, complete:SearchCompleteHandle ) {
        var results : Array<[String:Any?]> = [[String:Any?]]()
        if db == nil{
            NSLog("DB 未開")
            complete(false , [["error":"資料庫未開啟"]])
            return
        }
        var statement : OpaquePointer? = nil
        
        var sql : String = String()
        if showAll{
            sql = "SELECT * FROM \(tableName)"
        }else{
            sql = "select * from \(tableName) where iid = ?"
        }
        if sqlite3_prepare(db, sql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Search Prepare Error : \(errmsg)")
            complete(false , [["error":errmsg]])
        }
        // 都要寫在 sqlite3_prepare 後
        // 將 tmp 值 塞到 sql 中的 ?
        if !showAll && id != nil {
            if let idInt = Int(id!)  {
                if sqlite3_bind_int(statement, 1, Int32(idInt)) == SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("Search ID Bind Error : \(errmsg)")
                }
            }else{
                print("Search ID Bind Error : ID 錯誤")
            }
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            var result : [String:Any?] = [String:Any?]()
            
            let iid = sqlite3_column_text(statement, 0)
            let cname = sqlite3_column_text(statement, 1)
            
            if let iid = iid {
                let iid = String(cString: iid)
                result["iid"]=iid
            }
            if let cname = cname{
                let cname = String(cString: cname)
                result["cname"] = cname
            }
            
            // 2 是因為 image 欄位在第三欄
            let length = sqlite3_column_bytes(statement, 2)
            let bytes = sqlite3_column_blob(statement, 2)
            let imgData = NSData(bytes: bytes, length: Int(length))
            let image = UIImage(data: imgData as Data)
            result["image"]=image
            
            results.append(result)
        }
        sqlite3_finalize(statement)
        
        complete(true,results)
    }
    
    // MARK: 新增資料到資料庫
    
    /// 新增資料到資料庫
    ///
    /// - Parameters:
    ///   - cname: 要新增的 name
    ///   - image: 要新增的 image
    ///   - complete: 通知新增完成
    func insertDB(cname : String? , image: UIImage? ,complete : CompleteHandle) {
        if db == nil{
            NSLog("DB 未開")
            return
        }
        var statement : OpaquePointer? = nil
        
        if let image = image {
            // 判斷圖片是否存在
            guard let imgData = UIImagePNGRepresentation(image) else{
                complete(false,"image 不能轉成 Data")
                return
            }
            let imgNSData = imgData as NSData
            let sql = "insert into \(tableName)('cname','image') values(?, ?)"
            if sqlite3_prepare(db, sql, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("insert image name Prepare Error : \(errmsg)")
                complete(false,errmsg)
            }
            // 新增名字
            if let name = cname {
                if sqlite3_bind_text(statement, 1, name.cString(using: .utf8), -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("change Bind Error : \(errmsg)")
                    complete(false,errmsg)
                }
            }
            // 新增圖片
            if sqlite3_bind_blob(statement, 2, imgNSData.bytes, Int32( imgNSData.length), nil) != SQLITE_OK  {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("sendImgData Bind Error : \(errmsg)")
                complete(false,errmsg)
            }
        }else {
            let sql = "insert into \(tableName)('cname','image') values(?, NUll)"
            // 準備 Sql
            if sqlite3_prepare(db, sql, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Insert Prepare Error : \(errmsg)")
                complete(false,errmsg)
            }
            if cname != nil {
                if sqlite3_bind_text(statement, 1, cname, -1, nil) != SQLITE_OK  {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("Cname Bind Error : \(errmsg)")
                    complete(false,errmsg)
                }
            }
        }
        
        // 看是否成功
        if sqlite3_step(statement) == SQLITE_DONE {
            print("新增成功")
            complete(true,nil)
        }else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("新增失敗 Error : \(errmsg)")
            complete(false,errmsg)
        }
        
        sqlite3_finalize(statement)
    }
    
    // MARK: - 更新資料到資料庫
    
    /// 更新資料到資料庫
    ///
    /// - Parameters:
    ///   - id: 要更新資料的 id
    ///   - name: 要更新的名字
    ///   - image: 要更新的圖片
    ///   - complete: 完成後的動作
    func updateData(id : String, name : String?, image : UIImage, complete:CompleteHandle){
        if db == nil{
            NSLog("DB 未開")
            complete(false, "資料庫未開啟")
            return
        }
        guard let idInt = Int(id) else{
            complete(false, "ID 錯誤，不是數字")
            return
        }
        var statement : OpaquePointer? = nil
        
        // 判斷圖片是否存在
        if let imgData = UIImagePNGRepresentation(image){
            // 圖片 轉成 NSData
            let sendImgData = NSData(data:imgData)
            let sendSql = "UPDATE \(tableName) SET image = ?, cname = ? WHERE iid = ?"
            
            if sqlite3_prepare(db, sendSql, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("update Prepare Error : \(errmsg)")
                complete(false, errmsg)
            }
            // 更換圖片
            if sqlite3_bind_blob(statement, 1, sendImgData.bytes, Int32( sendImgData.length), nil) != SQLITE_OK  {
                
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("sendImgData Bind Error : \(errmsg)")
                
                complete(false, errmsg)
            }
            // 更換名字
            if let name = name {
                if sqlite3_bind_text(statement, 2, name.cString(using: .utf8), -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("change name Bind Error : \(errmsg)")
                    complete(false, errmsg)
                }
            }
            // 將要更換的 ID 帶入
            if sqlite3_bind_int(statement, 3, Int32(idInt)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("sendImgData Bind int Error : \(errmsg)")
                
                complete(false, errmsg)
            }
            
        }else{
            let sendSql = "UPDATE \(tableName) SET cname = ? WHERE iid = ?"
            // 準備 Sql
            if sqlite3_prepare(db, sendSql, -1, &statement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("update Prepare Error : \(errmsg)")
                complete(false, errmsg)
            }
            // 更換名字
            if let name = name {
                if sqlite3_bind_text(statement, 1, name.cString(using: .utf8), -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("change name Bind Error : \(errmsg)")
                    complete(false, errmsg)
                }
            }
            // 將要更換的 ID 帶入
            if sqlite3_bind_int(statement, 2, Int32(idInt)) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("sendImgData Bind int Error : \(errmsg)")
                
                complete(false, errmsg)
            }
        }
        if sqlite3_step(statement) == SQLITE_DONE {
            print("存入成功")
            
            complete(true, nil)
        }
        sqlite3_finalize(statement)
    }
    //    MARK: 刪除資料
    func deleteData(id:String, complete:CompleteHandle){
        if db == nil{
            NSLog("DB 未開")
            complete(false, "資料庫未開啟")
            return
        }
        guard let idInt = Int(id) else{
            complete(false, "ID 錯誤，不是數字")
            return
        }
        var statement : OpaquePointer? = nil
        
        let sendSql = "delete from \(tableName) where iid = ?"
        // 準備 Sql
        if sqlite3_prepare(db, sendSql, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("update Prepare Error : \(errmsg)")
            complete(false, errmsg)
        }
        // 將要刪除的 ID 帶入
        if sqlite3_bind_int(statement, 1, Int32(idInt)) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Delete Data Bind int Error : \(errmsg)")
            complete(false, errmsg)
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("刪除成功")
            
            complete(true, nil)
        }
        sqlite3_finalize(statement)
    }
    
    
}
