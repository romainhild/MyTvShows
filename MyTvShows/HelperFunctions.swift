//
//  UIImageView + DownloadImage.swift
//  MyTvShows
//
//  Created by Romain Hild on 15/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

func documentsDirectory() -> NSString {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
}

func localFilePathForUrl(previewUrl: String) -> NSURL? {
    let documentsPath = documentsDirectory()
    if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
        let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
        return NSURL(fileURLWithPath:fullPath)
    }
    return nil
}

func prefPath() -> String {
    return (documentsDirectory() as NSString).stringByAppendingPathComponent("pref.plist")
}

extension NSDate {
    func isSameDay(date: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let order = calendar.compareDate(self, toDate: date, toUnitGranularity: .Day)
        return order == .OrderedSame
    }
}