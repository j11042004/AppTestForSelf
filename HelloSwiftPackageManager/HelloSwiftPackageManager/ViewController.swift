//
//  ViewController.swift
//  HelloSwiftPackageManager
//
//  Created by Uran on 2020/3/24.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit
enum Result<T> {
    case success(T)
    case fail(Error)
}
typealias Completion<T> = (_ result : Result<T>) -> Void

class MaskInfo : NSObject {
    let code : String
    let name : String
    let address : String
    let tel : String
    let adults : Int
    let children : Int
    let updateTime : String
    var placeMarks : [CLPlacemark]?
    init(code: String, name: String, address: String, tel: String, adults: Int, children: Int, updateTime: String){
        self.code = code
        self.name = name
        self.address = address
        self.tel = tel
        self.adults = adults
        self.children = children
        self.updateTime = updateTime
    }
    func getPlaceMark(/*completion : @escaping Completion<[CLPlacemark]>*/){
        guard self.address.count != 0 else { return }
        CLGeocoder().geocodeAddressString(self.address)
        { (placeMarks, error) in
            if let _ = error
            {
                NSLog("\(self.address) error : \(error?.localizedDescription)")
                return
            }
            guard let placeMarks = placeMarks else {
//                let error = NSError(domain: "Get Nil placeMarks", code: 404, userInfo: nil)
//                completion(Result.fail(error))
                return
            }
            self.placeMarks = placeMarks
            NSLog("get success place marks ")
        }
    }
}
class ViewController: UIViewController {
    let maskUrlStr = "http://data.nhi.gov.tw/Datasets/Download.ashx?rid=A21030000I-D50001-001&l=https://data.nhi.gov.tw/resource/mask/maskdata.csv"
    var maskInfos = [MaskInfo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        AF.request(maskUrlStr).response
        { [weak self](response) in
            if let error = response.error {
                NSLog("error : \(error.localizedDescription)")
                return
            }
            switch response.result {
            case .success(let data):
                guard
                    let data = data ,
                    let dataStr = String(data: data, encoding: .utf8)
                else {
                    return
                }
                let results = dataStr.components(separatedBy: "\n")
                self?.maskInfos.removeAll()
                self?.parsingMask(results: results)
                break
            case .failure(let error):
                NSLog("result error : \(error)")
                break
            }
        }
    }

    func parsingMask(results : [String]){
        var resultInfos = results
        resultInfos.removeFirst()
        resultInfos.removeLast()
        for result in resultInfos{
            let infos = result.components(separatedBy: ",")
            let code = infos[0]
            let name = infos[1]
            var address = infos[2]
            let tel = infos[3]
            let adults = Int(infos[4])
            let children = Int(infos[5])
            let updateTime = infos[6]
            address = address.convertToHalfwidth()
            let maskInfo = MaskInfo(code: code, name: name, address: address, tel: tel, adults: adults == nil ? 0 : adults!, children: children == nil ? 0 : children!, updateTime: updateTime)
            self.maskInfos.append(maskInfo)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController : UITableViewDelegate {
    
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maskInfos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let maskInfo = maskInfos[indexPath.row]
        if maskInfo.placeMarks == nil {
            maskInfo.getPlaceMark()
        }
        let title = "\(maskInfo.placeMarks == nil ? "❎" : "✅") \(maskInfo.name)"
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = maskInfo.address
        return cell
    }
}

