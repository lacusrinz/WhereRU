//
//  LineDashPolyline.swift
//  WhereRU
//
//  Created by RInz on 15/2/16.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class LineDashPolyline: NSObject, MAOverlay {
    var _polyline:MAPolyline?
    
    var coordinate:CLLocationCoordinate2D{
        get{
            return polyline!.coordinate
        }
    }
    
    var boundingMapRect:MAMapRect{
        get{
            return polyline!.boundingMapRect
        }
    }
    
    var polyline:MAPolyline!{
        get{
            return _polyline
        }
    }
    
    
    init(polyline:MAPolyline) {
        super.init()
        self._polyline = polyline
    }

}
