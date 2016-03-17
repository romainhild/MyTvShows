//
//  Season.swift
//  MyTvShows
//
//  Created by Romain Hild on 17/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Season: NSObject {
    var seasonId = ""
    var seasonNumber = -1
    
    var episodes = [Episode]()
    
    init(id: String, number: Int) {
        seasonId = id
        seasonNumber = number
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