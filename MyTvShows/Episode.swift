//
//  Episode.swift
//  MyTvShows
//
//  Created by Romain Hild on 17/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Episode: NSObject, NSCoding {
    
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
    var epFirstAired: NSDate?
    var epDirector = ""
    var epRating = -1.0
    var epRatingCount = -1
    var epImdbId = ""
    var epLastUpdated: NSDate?
    var seasonId = ""
    var serieId = ""
    var epFilename = ""
    
    var currentCharactersParsed = ""
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        epId = aDecoder.decodeObjectForKey("epId") as! String
        epNumber = aDecoder.decodeObjectForKey("epNumber") as! Int
        epSeason = aDecoder.decodeObjectForKey("epSeason") as! Int
        epName = aDecoder.decodeObjectForKey("epName") as! String
        epLanguage = aDecoder.decodeObjectForKey("epLanguage") as! String
        epOverview = aDecoder.decodeObjectForKey("epOverview") as! String
        epFirstAired = aDecoder.decodeObjectForKey("epFirstAired") as! NSDate?
        epDirector = aDecoder.decodeObjectForKey("epDirector") as! String
        epRating = aDecoder.decodeObjectForKey("epRating") as! Double
        epRatingCount = aDecoder.decodeObjectForKey("epRatingCount") as! Int
        epImdbId = aDecoder.decodeObjectForKey("epImdbId") as! String
        epLastUpdated = aDecoder.decodeObjectForKey("epLastUpdated") as! NSDate?
        seasonId = aDecoder.decodeObjectForKey("seasonId") as! String
        serieId = aDecoder.decodeObjectForKey("serieId") as! String
        epFilename = aDecoder.decodeObjectForKey("epFilename") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(epId, forKey: "epId")
        aCoder.encodeObject(epNumber, forKey: "epNumber")
        aCoder.encodeObject(epSeason, forKey: "epSeason")
        aCoder.encodeObject(epName, forKey: "epName")
        aCoder.encodeObject(epLanguage, forKey: "epLanguage")
        aCoder.encodeObject(epOverview, forKey: "epOverview")
        aCoder.encodeObject(epFirstAired, forKey: "epFirstAired")
        aCoder.encodeObject(epDirector, forKey: "epDirector")
        aCoder.encodeObject(epRating, forKey: "epRating")
        aCoder.encodeObject(epRatingCount, forKey: "epRatingCount")
        aCoder.encodeObject(epImdbId, forKey: "epImdbId")
        aCoder.encodeObject(epLastUpdated, forKey: "epLastUpdated")
        aCoder.encodeObject(seasonId, forKey: "seasonId")
        aCoder.encodeObject(serieId, forKey: "serieId")
        aCoder.encodeObject(epFilename, forKey: "epFilename")
    }
    
    func update() {
        let tvDBApi = TvDBApiSingleton.sharedInstance
        let url = tvDBApi.urlForUpdatingEpisodeWithId(epId)
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) {
            data, response, error in
            if let error = error where error.code == -999 {
                return
            }
            else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                let parser = TvDBEpisodeParser(episode: self)
                if !parser.parseEpisodeData(data!) {
                    print("Error while parsing episode")
                }
            }
            else {
                print("Failure! \(response)")
            }
        }
        dataTask.resume()
    }
    
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

func >= (lhs: Episode, rhs: NSDate) -> Bool {
    let calendar = NSCalendar.currentCalendar()
    if let lhsDate = lhs.epFirstAired {
        let order = calendar.compareDate(lhsDate, toDate: rhs, toUnitGranularity: .Day)
        return order == .OrderedDescending || order == .OrderedSame
    }
    else {
        return false
    }
}