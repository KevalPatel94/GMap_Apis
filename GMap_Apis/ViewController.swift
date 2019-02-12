//
//  ViewController.swift
//  GMap_Apis
//
//  Created by Keval Patel on 2/10/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    var mapView :  GMSMapView?
    let googleMapKey = "AIzaSyCXOOLgb2bi98stpzsCbqFq_cRAPnAaTiA"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AIzaSyCXOOLgb2bi98stpzsCbqFq_cRAPnAaTiA
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func loadView() {
        setUpMapView()
        directionAPI()
        geoCoding()
    }
    
    //MARK: - Initial setup for mapview
    func setUpMapView(){
        let camera = GMSCameraPosition.camera(withLatitude:  34.168875, longitude: -118.351647, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }
    
    //MARK: - directionAPI
    func directionAPI(){
        // It is strogly recommended to get place name from place API.
        // Because sometimes Server cant find coordinates of the location
        let direcrionUrl = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=\(googleMapKey)")
       
        URLSession.shared.dataTask(with: direcrionUrl!){ (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            }else if let response = response, let data = data{
                print(response)
                print(data)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
                    let routes = json["routes"] as! NSArray
                    for route in routes{
                        let routeOverviewPolyline = (route as AnyObject)["overview_polyline"]
                        if let points = (routeOverviewPolyline as AnyObject)["points"]{
                            let path = GMSPath.init(fromEncodedPath: "\(points!)")
                            let polyline = GMSPolyline.init(path: path!)
                            polyline.strokeWidth = 4
                            polyline.strokeColor = UIColor.blue
                            polyline.map = self.mapView
                            self.view = self.mapView
                        }
                    }
                }
                catch let jsonError{
                    print(jsonError.localizedDescription)
                }
            }
        }.resume()

    }
    
    //MARK: - geocoding API
    func geoCoding(){
         let geoCodenUrl = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=\(googleMapKey)")
        URLSession.shared.dataTask(with: geoCodenUrl!){ (data, response, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            }else if let response = response, let data = data{
                print(response)
                print(data)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
                    // Response from map API
                    print(json)
                }
                catch let jsonError{
                    print(jsonError.localizedDescription)
                }
            }
            }.resume()
    }
}
