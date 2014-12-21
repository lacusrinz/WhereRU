//
//  ReGeocodeAnnotation.swift
//  WhereRU
//
//  Created by RInz on 14/12/18.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class ReGeocodeAnnotation: NSObject, MAAnnotation {
    var _reGeocode:AMapReGeocode?
    var reGeocode:AMapReGeocode?{
        get{
            return _reGeocode
        }
    }
    
    //MARK: - MAAnnotation Protocol
    var title:NSString{
        get{
            println("1:"+reGeocode!.addressComponent.province)
            println("2:"+reGeocode!.addressComponent.city)
            println("3:"+reGeocode!.addressComponent.district)
            println("4:"+reGeocode!.addressComponent.township)
            return reGeocode!.addressComponent.province + reGeocode!.addressComponent.city + reGeocode!.addressComponent.district + reGeocode!.addressComponent.township
        }
    }
    
    var subtitle:NSString{
        get{
            return reGeocode!.addressComponent.neighborhood + reGeocode!.addressComponent.building
        }
    }
    
    var _coordinate:CLLocationCoordinate2D
    var coordinate:CLLocationCoordinate2D{
        get{
            return _coordinate
        }
    }
    
    init(reGeocode:AMapReGeocode, coordinate:CLLocationCoordinate2D){
        self._reGeocode = reGeocode
        self._coordinate = coordinate
    }
    
}
