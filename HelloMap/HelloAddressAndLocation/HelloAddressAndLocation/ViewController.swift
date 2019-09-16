//
//  ViewController.swift
//  HelloAddressAndLocation
//
//  Created by Uran on 2018/3/16.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var change: UIButton!
    
    var startLocation : CLLocation?
    var lastLocation : CLLocation?

    var locationManager : CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.locationManager = CLLocationManager()
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.activityType = CLActivityType.fitness
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    @IBAction func change(_ sender: Any) {
        // 現在座標轉成地址
        if self.addressTextField.text?.count == 0{
            guard let last = self.lastLocation else{
                return
            }
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(last, completionHandler: { (places, error) in
                if let error = error {
                    NSLog("Error : \(error.localizedDescription)")
                    return
                }
                guard let places = places else{
                    return
                }
                for place in places{
                    // 地址
                    let name = place.name
                    // 國碼
                    let isoCountryCode = place.isoCountryCode
                    // 國家
                    let country = place.country
                    // 郵遞區號
                    let postalCode = place.postalCode
                    // 市名
                    let subAdministrativeArea = place.subAdministrativeArea
                    // 區鄉鎮
                    let locality = place.locality
                    // 村里
                    let subLocality = place.subLocality
                    // 路名
                    let thoroughfare = place.thoroughfare
                    // 門牌號碼
                    let subThoroughfare = place.subThoroughfare
                    // 位址 region
                    let region = place.region
                    // 時區
                    let timeZone = place.timeZone
                     print("name = \(name) \n isoContryCode = \(isoCountryCode) \n contry = \(country) \n postalCode = \(postalCode) \n subAdministrativeArea = \(subAdministrativeArea) \n locality = \(locality) \n subLocality = \(subLocality) \n thoroughfare = \(thoroughfare) \n subThoroughfare = \(subThoroughfare) \n region = \(region) \n timeZone = \(timeZone)")
                }
            })
            
            
            return
        }
        self.mapView.removeAnnotations(self.mapView.annotations)

        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.addressTextField.text
        // 尋找的範圍
        request.region = MKCoordinateRegion.init(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 127000, longitudeDelta: 127000))
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                NSLog("search Fail : \(error.localizedDescription)")
                return
            }
            guard let response = response else{
                return
            }
            for item in response.mapItems{
//                NSLog("item : \(item)")
                let name = item.name
                let phoneNumber = item.phoneNumber
                let placemark = item.placemark
                let url = item.url
                
                print("name : \(name) , phone: \(phoneNumber) , place:\(placemark) , url :\(url) ")
                self.mapView.addAnnotation(item.placemark)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let nowLocation = locations.last else {
            return
        }
        // 因為是 nil 才設定 現在位置為起始位置
        if startLocation == nil {
            self.startLocation = nowLocation
            var region = MKCoordinateRegion()
            region.center = nowLocation.coordinate
            region.span = MKCoordinateSpanMake(0.01, 0.01)
            self.mapView.setRegion(region, animated: true)
        }
        self.lastLocation = nowLocation
    }
}
extension ViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            return nil
        }
        let pinName = ""
//        if let name = self.data?.name {
//            pinName = name
//        }
        
        var resultPin = mapView.dequeueReusableAnnotationView(withIdentifier: pinName) as? MKPinAnnotationView
        if resultPin == nil{
            resultPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinName)
        }else{
            resultPin?.annotation = annotation
        }
        
        resultPin?.pinTintColor = UIColor.blue
        resultPin?.canShowCallout = true
        resultPin?.animatesDrop = true
        
        return resultPin
    }
}
