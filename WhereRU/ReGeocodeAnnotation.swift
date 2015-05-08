//
//  ReGeocodeAnnotation.swift
//  WhereRU
//
//  Created by RInz on 14/12/18.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class ReGeocodeAnnotation: NSObject, MAAnnotation {
    var reGeocode:AMapReGeocode?
    
    //MARK: - MAAnnotation Protocol
    
    func title() -> String! {
        println("1:"+reGeocode!.addressComponent.province)
        println("2:"+reGeocode!.addressComponent.city)
        println("3:"+reGeocode!.addressComponent.district)
        println("4:"+reGeocode!.addressComponent.township)
        return reGeocode!.addressComponent.province + reGeocode!.addressComponent.city + reGeocode!.addressComponent.district + reGeocode!.addressComponent.township
    }
    
    func subtitle() -> String! {
        return reGeocode!.addressComponent.neighborhood + reGeocode!.addressComponent.building
    }
    
    var _coordinate:CLLocationCoordinate2D
    var coordinate:CLLocationCoordinate2D{
        get{
            return _coordinate
        }
    }
    
    init(reGeocode:AMapReGeocode, coordinate:CLLocationCoordinate2D){
        self.reGeocode = reGeocode
        self._coordinate = coordinate
    }
    
}
