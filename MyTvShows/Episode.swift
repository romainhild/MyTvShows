//
//  Episode.swift
//  MyTvShows
//
//  Created by Romain Hild on 17/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Episode: NSObject {
    
    static let firstAiredStringFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    var epId = ""
    var epNumber = -1
    var epSeason = -1
    var epName = ""
    var epLanguage = ""
    var epOverview = ""
    var epFirstAiredAsString = ""
    var epFirstAired: NSDate?
    var epDirector = ""
    var epRatingAsString = ""
    var epRating = -1.0
    var epRatingCountAsString = ""
    var epRatingCount = -1
    var epImdbId = ""
    var epLastUpdated: NSDate?
    var seasonId = ""
    var serieId = ""
    var epFilename = ""
    
    func isFromSeason(season: Int) -> Bool {
        return epSeason == season
    }
    
}

func < (lhs: Episode, rhs: Episode) -> Bool {
    if let lhsDate = lhs.epFirstAired {
        if let rhsDate = rhs.epFirstAired {
            return lhsDate.compare(rhsDate) == .OrderedAscending
        }
        else {
            return false
        }
    }
    else {
        return true
    }
}

func > (lhs: Episode, rhs: NSDate) -> Bool {
    if let lhsDate = lhs.epFirstAired {
        return lhsDate.compare(rhs) == .OrderedDescending
    }
    else {
        return false
    }
}