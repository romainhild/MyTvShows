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
        return NSURL(string: "\(mirror)/api/\(apiKey)/series/\(id)/all\(language)")!
    }
    
    func urlForUpdatingSerieWithId(id: String) -> NSURL {
        return NSURL(string: "\(mirror)/api/\(apiKey)/series/\(id)\(language)")!
    }
    
    func urlForUpdatingEpisodeWithId(id: String) -> NSURL {
        return NSURL(string: "\(mirror)/api/\(apiKey)/episodes/\(id)\(language)")!
    }
    
    func urlForSearch(searchText: String) -> NSURL {
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return NSURL(string: "\(mirror)/api/GetSeries.php?seriesname=\(escapedSearchText)\(language)")!
    }
    
    func urlForBanner(banner: String) -> NSURL {
        let escapedBanner = banner.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return NSURL(string: "\(mirror)/banners/\(escapedBanner)")!
    }
    
    func urlForCurrentTime() -> NSURL {
        return NSURL(string: "\(mirror)/api/Updates.php?type=none")!
    }
    
    func urlForUpdateWithTime(time: String) -> NSURL {
        return NSURL(string: "\(mirror)/api/Updates.php?type=all&time=\(time)")!
    }
    
    func urlForActorsForSerieId(id: String) -> NSURL {
        return NSURL(string: "\(mirror)/api/\(apiKey)/series/\(id)/actors.xml")!
    }
}

class TvDBActorParser: NSObject, NSXMLParserDelegate {
    static let sharedInstance = TvDBActorParser()
    
    var delegate: TvDBActorParserDelegate?
    
    var currentCharacterParsed = ""
    var currentActor: Actor?
    
    func parseActorData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "Actor" {
            currentActor = Actor()
        }
        currentCharacterParsed = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            currentCharacterParsed += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Actor" {
            delegate?.parser(self, parsedActor: currentActor!)
            currentActor = nil
        }
        else if elementName == "Image" {
            currentActor?.imageURL = currentCharacterParsed
        }
        else if elementName == "Name" {
            currentActor?.name = currentCharacterParsed
        }
        else if elementName == "Role" {
            currentActor?.role = currentCharacterParsed
        }
        else if elementName == "SortOrder" {
            currentActor?.sortOrder = Int(currentCharacterParsed)!
        }
    }
}

protocol TvDBActorParserDelegate {
    func parser(parser: TvDBActorParser, parsedActor actor: Actor)
}
