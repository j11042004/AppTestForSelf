//
//  AutoSearchViewController.swift
//  HelloGoogleMap
//
//  Created by Uran on 2018/5/3.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class AutoSearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var getDataDict : [String : Any]!
    var placeResults = [ResultPlace]()
    var markers = [GMSMarker]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        getDataDict = UserDefaults.standard.dictionary(forKey: "MapWebPlace")
        print("status : \(getDataDict["status"] as! String)")
        print("attributions: \(getDataDict["html_attributions"] as! [String])")
        print("next_page_token : \(getDataDict["next_page_token"] as! String)")
        // 分析 json 將他們丟到 place Object 中
        guard let results = getDataDict["results"] as? [[String : Any]] else {
            print("results is nil")
            return
        }
        for result in results {
            let place = ResultPlace()
            place.setPlaceInfo(With: result)
            self.placeResults.append(place)
        }
        for place in self.placeResults {
            let marker = GMSMarker()
            // 新增一個 Marker
            if let location = place.location{
                marker.position = location
            }
            marker.title = place.name
            marker.snippet = place.address
            marker.map = self.mapView
            
            self.markers.append(marker)
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

}


extension AutoSearchViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if !self.markers.contains(marker){
            
        }
        guard let index = self.markers.index(of: marker) else {
            return
        }
        let place = self.placeResults[index]
        print(place.name)

    }
}
