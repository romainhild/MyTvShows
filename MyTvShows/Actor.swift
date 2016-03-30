//
//  Actor.swift
//  MyTvShows
//
//  Created by Romain Hild on 30/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Actor: NSObject, NSCoding {
    var name = ""
    var role = ""
    var imageURL = ""
    var imagePath: NSURL?
    var sortOrder = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        name = aDecoder.decodeObjectForKey("name") as! String
        role = aDecoder.decodeObjectForKey("role") as! String
        imageURL = aDecoder.decodeObjectForKey("imageURL") as! String
        imagePath = aDecoder.decodeObjectForKey("imagePath") as! NSURL?
        sortOrder = aDecoder.decodeObjectForKey("sortOrder") as! Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(role, forKey: "role")
        aCoder.encodeObject(imageURL, forKey: "imageURL")
        aCoder.encodeObject(imagePath, forKey: "imagePath")
        aCoder.encodeObject(sortOrder, forKey: "sortOrder")
    }
    
    deinit {
        let fileManager = NSFileManager.defaultManager()
        if let url = imagePath, destinationURL = localFilePathForUrl(url.absoluteString) {
            do {
                try fileManager.removeItemAtURL(destinationURL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
        }
    }
}
