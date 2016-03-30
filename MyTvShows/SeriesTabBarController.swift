//
//  SeriesTabBarController.swift
//  MyTvShows
//
//  Created by Romain Hild on 30/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import UIKit

class SeriesTabBarController: UITabBarController {
    
    var mySeries: MySeries!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSeries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(mySeries, forKey: "mySeries")
        archiver.finishEncoding()
        data.writeToFile(prefPath(), atomically: true)
    }
    
    func loadSeries() {
        let path = prefPath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                mySeries = unarchiver.decodeObjectForKey("mySeries") as! MySeries
                unarchiver.finishDecoding()
            }
        }
        else {
            mySeries = MySeries()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
