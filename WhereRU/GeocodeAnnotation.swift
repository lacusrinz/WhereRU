//
//  GeocodeAnnotation.swift
//  WhereRU
//
//  Created by RInz on 14/12/16.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class GeocodeAnnotation: NSObject, MAAnnotation {
    var geocode:AMapGeocode?
    
    //MARK: - MAAnnotation Protocol
//    var title:NSString{
//        get{
//            return self._geocode!.formattedAddress
//        }
//    }
//    
//    var subtitle:NSString{
//        get{
//            return self._geocode!.location.description
//        }
//    }

    func title() -> String! {
        return self.geocode!.formattedAddress
    }
    
    func subtitle() -> String! {
        return self.geocode!.location.description
    }
    
    var coordinate:CLLocationCoordinate2D{
        get{
            return CLLocationCoordinate2DMake(Double(self.geocode!.location.latitude), Double(self.geocode!.location.longitude))
        }
    }
    
    //MARK: - life circle
    init(geocode:AMapGeocode) {
        self.geocode = geocode
    }
}
