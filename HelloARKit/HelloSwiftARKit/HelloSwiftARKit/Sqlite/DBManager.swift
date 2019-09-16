//
//  DBManager.swift
//  HelloSwiftARKit
//
//  Created by Uran on 2018/3/9.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import ARKit
class DBManager: NSObject {
    
    let field_TableName = "ARTable"
    let field_AnchorID = "AnchorID"
    let field_AnchorMatrix = "Matrix"
    
    static let shared : DBManager = DBManager()
    var databasePath : String!
    let databaseFileName = "ARDatabase.sqlite"
    var database : FMDatabase!
    
    override init() {
        super.init()
        let documentsDirectory = NSHomeDirectory() + "/Documents"
        databasePath = documentsDirectory.appending("/\(databaseFileName)")
        NSLog("database path : \(databasePath)")
    }
    
    
    /// 建立 Database
    ///
    /// - Returns: 回傳是否建立成功
    func createDatabase() -> Bool {
        var created = false
        // 若 FileManager 還未拿到檔案
        if !FileManager.default.fileExists(atPath: self.databasePath) {
            // 設定 Database
            database = FMDatabase(path: self.databasePath!)
            // 若 Database 不是 Nil
            if database != nil {
                // Open the database. 這時 Database會被建立
                if database.open() {
                    // 執行建立 Table 的 Query
                    let createMoviesTableQuery = "CREATE TABLE `\(field_TableName)` (`\(field_AnchorID)`    INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,    `\(field_AnchorMatrix)`    TEXT);"
                    do {
                        // 嘗試執行 Database
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                        
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    // 關閉 Database
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return created
    }
    func openDatabase() -> Bool{
        if self.database == nil {
            if FileManager.default.fileExists(atPath: databasePath){
                self.database = FMDatabase(path: databasePath)
            }
        }
        if database != nil{
            if database.open(){
                return true
            }
        }
        return false
    }
    /// 新增 Anchor 的 4*4 矩陣 到 Database 中
    func insertAnchorData(_ AnchorMatrix : matrix_float4x4){
        if !self.openDatabase() {
            return
        }
        let matrix4X4 = AnchorMatrix.columns
        let matrixArray : [[Float]] = [[matrix4X4.0.x,matrix4X4.0.y,matrix4X4.0.z,matrix4X4.0.w],[matrix4X4.1.x,matrix4X4.1.y,matrix4X4.1.z,matrix4X4.1.w],[matrix4X4.2.x,matrix4X4.2.y,matrix4X4.2.z,matrix4X4.2.w],[matrix4X4.3.x,matrix4X4.3.y,matrix4X4.3.z,matrix4X4.3.w]]
        let matrixStr = String(describing: matrixArray)
        let query = "INSERT INTO `\(field_TableName)`(`\(field_AnchorID)`,`\(field_AnchorMatrix)`) VALUES (NULL,\"\(matrixStr)\");"
        if !self.database.executeStatements(query){
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
        }
        self.database.close()
    }
    
    /// 取得 Sql Data 中所有的資料
    func searchAllData() -> [CusAnchor]?{
        var anchorArray = [CusAnchor]()
        if !openDatabase() {
            return nil
        }
        let query = "SELECT * FROM `ARTable`"
        do {
            let results = try self.database.executeQuery(query, values: nil)
            var id = Int(results.int(forColumn: field_AnchorID))
            var matrix : String = ""
            if let matrixString = results.string(forColumn: field_AnchorMatrix) {
                matrix = matrixString
            }else{
                matrix = "nil"
            }
            NSLog("0 results ID : \(id),matrix : \(matrix)")
            
            while results.next() {
                id = Int(results.int(forColumn: field_AnchorID))
                if let matrixString = results.string(forColumn: field_AnchorMatrix) {
                    let matrix = self.dataResultToMatrix(resultStr: matrixString)
                    // 要回傳的資料 Array
                    let anchor = CusAnchor.init(transform: matrix)
                    anchor.dataID = id
                    anchorArray.append(anchor)
                }else{
                    matrix = "nil"
                }
            }
        } catch {
            print("search error : \(error.localizedDescription)")
        }
        self.database.close()
        
        if anchorArray.count == 0 {
            return nil
        }
        return anchorArray
    }
    
    /// 根據 ID 刪除資料
    ///
    /// - Parameter ID: 要被刪除的 ID
    /// - Returns: 是否有刪除成功
    func deleteData(withID ID:Int) -> Bool{
        var delete = false
        if !self.openDatabase(){
            return delete
        }
        let query = "delete from \(field_TableName) where \(field_AnchorID)=?"
        do {
            try database.executeUpdate(query, values: [ID])
            delete = true
        } catch  {
            NSLog("delete Error : \(error.localizedDescription)")
        }
        return delete
    }
    
    
    /// 將在 SQL 中的 matrix String 轉成 Matrix4X4
    ///
    /// - Parameter resultStr: SQL 中的 matrix String
    /// - Returns: Scene 的 matrix 位置
    private func dataResultToMatrix(resultStr : String) -> float4x4{
        // 取代無用字元
        var newStr = resultStr.replacingOccurrences(of: "[", with: "")
        newStr = newStr.replacingOccurrences(of: "]", with: "")
        newStr = newStr.replacingOccurrences(of: " ", with: "")
        // 將 String 做分割
        let matrixStrArray = newStr.components(separatedBy: ",")
        // 將 String Array 轉成 Float Array
        var matrixDoubleArray = [Double]()
        for pointStr in matrixStrArray {
            guard let point = Double(pointStr) else{
                matrixDoubleArray.append(0)
                continue
            }
            matrixDoubleArray.append(point)
        }
        // 將 Double Array -> double4 Array ([[Float]])
        var count = 0
        
        var double4Array = [double4]()
        var valueArray = [Double]()
        while matrixDoubleArray.count != 0 {
            if count == 4{
                count = 0
                continue
            }
            // 加到 matrixDoubleArray 中，判斷是否可轉成 Double 若可就轉否則就加入0
            if let value = matrixDoubleArray.first{
                valueArray.append(value)
            }else{
                valueArray.append(0)
            }
            matrixDoubleArray.remove(at: 0)
            // 判斷 valueArray count 是否為 4 ，若是則轉成 double4 加到 Array 中
            if valueArray.count == 4{
                let column = double4(valueArray)
                double4Array.append(column)
                // 將 valueArray 設為 [Double]() 將裡面資料清空
                valueArray = [Double]()
            }
            count += 1
        }
        // 將 double4Array 轉成 float4x4
        let matrix4X4 = double4x4(double4Array)
        let matrix4 = SCNMatrix4(matrix4X4)
        let matrix : float4x4 = float4x4(matrix4)
        return matrix
    }
    
}
