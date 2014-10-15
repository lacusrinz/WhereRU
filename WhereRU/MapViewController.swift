//
//  MapViewController.swift
//  WhereRU
//
//  Created by RInz on 14-9-25.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var label: UILabel!
    
    var _label:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = _label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
