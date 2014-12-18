//
//  GeocodeAnnotation.swift
//  WhereRU
//
//  Created by RInz on 14/12/16.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class GeocodeAnnotation: NSObject, MAAnnotation {
    var _geocode:AMapGeocode?
    var geocode:AMapGeocode?{
        get{
            return self._geocode
        }
    }
    
    //MARK: - MAAnnotation Protocol
    var title:NSString{
        get{
            return self._geocode!.formattedAddress
        }
    }
    
    var subtitle:NSString{
        get{
            return self._geocode!.location.description
        }
    }
    
    var coordinate:CLLocationCoordinate2D{
        get{
            return CLLocationCoordinate2DMake(Double(self._geocode!.location.latitude), Double(self._geocode!.location.longitude))
        }
    }
    
    //MARK: - life circle
    init(geocode:AMapGeocode){
        self._geocode = geocode
    }
}
