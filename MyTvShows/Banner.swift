//
//  Image.swift
//  MyTvShows
//
//  Created by Romain Hild on 01/04/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Banner: NSObject, NSCoding {
    var bannerPath = ""
    var thumbnailPath = ""
    var bannerType = ""
    var bannerType2 = ""
    var bannerULR: NSURL?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        bannerPath = aDecoder.decodeObjectForKey("bannerPath") as! String
        thumbnailPath = aDecoder.decodeObjectForKey("thumbnailPath") as! String
        bannerType = aDecoder.decodeObjectForKey("bannerType") as! String
        bannerType2 = aDecoder.decodeObjectForKey("bannerType2") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(bannerPath, forKey: "bannerPath")
        aCoder.encodeObject(thumbnailPath, forKey: "thumbnailPath")
        aCoder.encodeObject(bannerType, forKey: "bannerType")
        aCoder.encodeObject(bannerType2, forKey: "bannerType2")
    }
}
