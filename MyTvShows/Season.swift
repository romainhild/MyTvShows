//
//  Season.swift
//  MyTvShows
//
//  Created by Romain Hild on 17/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Season: NSObject, NSCoding {
    var seasonId = ""
    var seasonNumber = -1
    var count: Int {
        return episodes.count
    }
    
    var episodes = [Episode]()
    
    init(id: String, number: Int) {
        super.init()

        seasonId = id
        seasonNumber = number
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        seasonId = aDecoder.decodeObjectForKey("seasonId") as! String
        seasonNumber = aDecoder.decodeObjectForKey("seasonNumber") as! Int
        episodes = aDecoder.decodeObjectForKey("episodes") as! [Episode]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(seasonId, forKey: "seasonId")
        aCoder.encodeObject(seasonNumber, forKey: "seasonNumber")
        aCoder.encodeObject(episodes, forKey: "episodes")
    }
    
    subscript(index: Int) -> Episode {
        get {
            return episodes[index]
        }
        set {
            episodes[index] = newValue
        }
    }
    
    func append(episode: Episode) {
        episodes.append(episode)
    }

}

func < (lhs: Season, rhs: Season) -> Bool {
    return lhs.seasonNumber < rhs.seasonNumber
}