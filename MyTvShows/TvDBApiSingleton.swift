//
//  TvDBApiSingleton.swift
//  MyTvShows
//
//  Created by Romain Hild on 15/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class TvDBApiSingleton {
    static let sharedInstance = TvDBApiSingleton()
    
    let apiKey = "38ECB8077661147B"
    let mirror = "https://thetvdb.com"
    let lang = ""
    var language: String {
        get {
            if !lang.isEmpty {
                return "/language/\(lang).xml"
            } else {
                return ""
            }
        }
    }
    
    private init() {}
    
    func urlForSerieId(id: String) -> NSURL {
        return NSURL(string: "\(mirror)/api/\(apiKey)/series/\(id)\(language)")!
    }
    
    func urlForSearch(searchText: String) -> NSURL {
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return NSURL(string: "\(mirror)/api/GetSeries.php?seriesname=\(escapedSearchText)\(language)")!
    }
    
    func urlForBanner(banner: String) -> NSURL {
        let escapedBanner = banner.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return NSURL(string: "\(mirror)/banners/\(escapedBanner)")!
    }
}