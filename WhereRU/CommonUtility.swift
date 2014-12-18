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
}
