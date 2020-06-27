//
//  MaskInfoViewController.swift
//  HelloSwiftPinterest
//
//  Created by Uran on 2020/2/7.
//  Copyright © 2020 Uran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
enum Result<T> {
  case success(T)
  case fail(Error)
}
struct HospitalMaskInfo {
    var code : String
    var name : String
    var address : String
    var tel : String
    var albumNum : String
    var childNum : String
    var update : String
}
class MaskInfoViewController: UIViewController {
    var hospitalInfos = [HospitalMaskInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMaskInfo { (result) in
            switch result {
            case .success(let maskInfos) :
                let info : HospitalMaskInfo? = maskInfos[20]
                NSLog("info address : \(info?.address)")
                CLGeocoder().geocodeAddressString(info!.address)
                { (placemarks, error) in
                    if let error = error {
                        NSLog("change location error : \(error.localizedDescription)")
                        return
                    }
                    guard let placeMarks = placemarks else {
                        return
                    }
                    for mask in placeMarks {
                        NSLog("location : \(mask.location)")
                    }
                }
                break
            case .fail(let error) :
                NSLog("get error : \(error.localizedDescription)")
                break
            }
        }
    }
    func getMaskInfo(completion : @escaping (Result<[HospitalMaskInfo]>)->Void){
        let urlStr = "http://data.nhi.gov.tw/Datasets/Download.ashx?rid=A21030000I-D50001-001&l=https://data.nhi.gov.tw/resource/mask/maskdata.csv"
        NSLog("get mask Info")
        let url = URL(string: urlStr)!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        self.hospitalInfos.removeAll()
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(Result.fail(error))
                return
            }
            var statusCode = 0
            if let response = response as? HTTPURLResponse {
                statusCode = response.statusCode
            }
            let faileError : Error = NSError(domain: "Get ResultData error", code: statusCode, userInfo: nil)
            guard let data = data ,
                let valueStr = String(data: data, encoding: .utf8)
            else{
                completion(Result.fail(faileError))
                return
            }
            var maskInfos = [HospitalMaskInfo]()
            var values = valueStr.components(separatedBy: "\r\n")
            values.removeFirst()
            for value in values {
                if value.count == 0 {continue}
                let info = value.components(separatedBy: ",")
                let code = info[0]
                let name = info[1]
                let address = info[2]
                let tel = info[3]
                let albumNum = info[4]
                let childNum = info[5]
                let update = info[6]
                let maskInfo = HospitalMaskInfo(code: code, name: name, address: address, tel: tel, albumNum: albumNum, childNum: childNum, update: update)
                maskInfos.append(maskInfo)
            }
            if maskInfos.count == 0 {
                completion(Result.fail(faileError))
                return
            }
            completion(Result.success(maskInfos))
        }.resume()
    }
}
extension MaskInfoViewController : UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
