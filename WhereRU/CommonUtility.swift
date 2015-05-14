//
//  CommonUtility.swift
//  WhereRU
//
//  Created by RInz on 14/12/16.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class CommonUtility: NSObject {
    class func minMapRectForMapPoints(mapPoints:[MAMapPoint] ,count:Int) -> MAMapRect{
        if (count <= 1){
            NSLog("minMapRectForMapPoints: 无效的参数.")
            return MAMapRectZero
        }
        var minX:Double = (mapPoints[0] as MAMapPoint).x
        var minY:Double = (mapPoints[0] as MAMapPoint).y
        var maxX = minX
        var maxY = minY
        for(var i:Int=1;i<count;i++){
            var point:MAMapPoint = mapPoints[i]
            if (point.x < minX){
                minX = point.x;
            }
            
            if (point.x > maxX){
                maxX = point.x;
            }
            
            if (point.y < minY){
                minY = point.y;
            }
            
            if (point.y > maxY){
                maxY = point.y;
            }
        }
        return MAMapRectMake(minX, minY, fabs(maxX - minX), fabs(maxY - minY))
    }
    
    class func minMapRectForAnnotations(annotations:[GeocodeAnnotation]) -> MAMapRect{
        if (annotations.count <= 1)
        {
            NSLog("minMapRectForAnnotations: 无效的参数.")
            return MAMapRectZero
        }
        
        var mapPoints = Array<MAMapPoint>()
        
        (annotations as NSArray).enumerateObjectsUsingBlock { (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
//            mapPoints[idx] = MAMapPointForCoordinate((obj.coordinate))
            mapPoints.append(MAMapPointForCoordinate((obj.coordinate)))
        }
        
        var minMapRect:MAMapRect = self.minMapRectForMapPoints(mapPoints, count: annotations.count)
        
        return minMapRect;
    }
    
    class func polylinesForPath(path:AMapPath?) -> NSArray?{
        if (path == nil || path!.steps.count == 0){
            return nil
        }
        var polylines:NSMutableArray = NSMutableArray()
        (path!.steps as NSArray).enumerateObjectsUsingBlock { (step:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            var stepPolyline:MAPolyline? = self.polylineForStep(step as! AMapStep!)
            if stepPolyline != nil{
                println("lalala stepPolyline:\(stepPolyline)")
                polylines.addObject(stepPolyline!)
                if idx>0{
                    self.replenishPolylinesForPathWith(stepPolyline!, lastPolyline: self.polylineForStep((path!.steps as NSArray).objectAtIndex(idx-1) as! AMapStep)!, polylines: polylines)
                }
            }
        }
        return polylines
    }
    
    class func replenishPolylinesForPathWith(stepPolyline:MAPolyline,lastPolyline:MAPolyline,polylines:NSMutableArray){
        var startCoor:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var endCoor:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var points:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        stepPolyline.getCoordinates(&endCoor, range: NSMakeRange(0, 1))
//        stepPolyline.getCoordinates(&startCoor, range: NSMakeRange(lastPolyline.pointCount - 1, 1))
        
        if(endCoor.latitude != startCoor.latitude || endCoor.longitude != startCoor.longitude){
//            points[0] = startCoor
//            points[1] = endCoor
            points.append(startCoor)
            points.append(endCoor)
            
            var polyline:MAPolyline = MAPolyline(coordinates: &points, count: 2)
            var dathPolyline:LineDashPolyline = LineDashPolyline(polyline: polyline)
            polylines.addObject(dathPolyline)
        }
    }
    
    class func polylineForStep(step:AMapStep!)->MAPolyline?{
        if step == nil{
            return nil
        }
        return self.polylineForCoordinateString(step.polyline)
    }
    
    class func polylineForCoordinateString(coordinateString:NSString)->MAPolyline?{
        if coordinateString.length == 0{
            return nil
        }
        var count = 0
        let coordinatesTotal = coordinatesForString(coordinateString, parseToken: ";")
        count = coordinatesTotal.coordinateCount
        var coordinates:[CLLocationCoordinate2D] = coordinatesTotal.coordinates!
        var polyline:MAPolyline = MAPolyline(coordinates: &coordinates, count: UInt(count))
        return polyline
    }
    
    class func coordinatesForString(string:NSString?, parseToken:NSString?)->(coordinates:[CLLocationCoordinate2D]?, coordinateCount:Int){
        var token = parseToken
        if string == nil{
            return (nil,0)
        }
        if token == nil{
            token = ","
        }
        var str = ""
        if !token!.isEqualToString(","){
            str = string!.stringByReplacingOccurrencesOfString(token! as String, withString: ",")
        }else{
            str = string! as String
        }
        var components:NSArray = str .componentsSeparatedByString(",")
        var count:Int = components.count/2
        var coordinates:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for var i:Int = 0; i<count; ++i{
            var coordinate = CLLocationCoordinate2D(latitude: components.objectAtIndex(2*i).doubleValue, longitude: components.objectAtIndex(2*i+1).doubleValue)
            coordinates.append(coordinate)
        }
        return (coordinates, count)
    }
    
    class func mapRectForOverlays(overlays:NSArray) -> MAMapRect{
        if overlays.count == 0{
            println("Wrong param\(__FUNCTION__)")
            return MAMapRectZero
        }
        var mapRect:MAMapRect?
        var buffer:[MAMapRect] = [MAMapRect]()
        overlays.enumerateObjectsUsingBlock { (obj:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
//            buffer[idx] = obj.boundingMapRect
            buffer.append(obj.boundingMapRect)
        }
        
        mapRect = self.mapRectUnion(buffer, count: overlays.count)
        
        return mapRect!
    }
    
    class func mapRectUnion(mapRects:[MAMapRect], count:Int) -> MAMapRect{
        if(mapRects.count == 0 || count == 0){
            return MAMapRectZero
        }
        
        var unionMapRect:MAMapRect = mapRects[0]
        
        for(var i:Int=0; i<count; ++i){
            unionMapRect = self.unionMapRect1(unionMapRect, mapRect2: mapRects[i])
        }
        
        return unionMapRect
    }
    
    class func unionMapRect1(mapRect1:MAMapRect, mapRect2:MAMapRect) -> MAMapRect{
        var rect1 = CGRectMake(CGFloat(mapRect1.origin.x), CGFloat(mapRect1.origin.y), CGFloat(mapRect1.size.width), CGFloat(mapRect1.size.height));
        var rect2 = CGRectMake(CGFloat(mapRect2.origin.x), CGFloat(mapRect2.origin.y), CGFloat(mapRect2.size.width), CGFloat(mapRect2.size.height));
        var unionRect:CGRect = CGRectUnion(rect1, rect2)
        
        return MAMapRectMake(Double(unionRect.origin.x), Double(unionRect.origin.y), Double(unionRect.size.width), Double(unionRect.size.height))
    }
}
