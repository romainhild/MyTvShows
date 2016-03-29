//
//  TvDBEpisodeParser.swift
//  MyTvShows
//
//  Created by Romain Hild on 28/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class TvDBEpisodeParser: NSObject, NSXMLParserDelegate {
    var episode: Episode!
    
    var currentCharactersParsed = ""
    
    init(episode: Episode) {
        self.episode = episode
        super.init()
    }
    
    func parseEpisodeData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentCharactersParsed = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            currentCharactersParsed += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "id":
            episode.epId = currentCharactersParsed
        case "Director":
            episode.epDirector = currentCharactersParsed
        case "EpisodeName":
            episode.epName = currentCharactersParsed
        case "EpisodeNumber":
            if let number = Int(currentCharactersParsed) {
                episode.epNumber = number
            }
        case "FirstAired":
            episode.epFirstAired = Serie.firstAiredFormatter.dateFromString(currentCharactersParsed)
        case "IMDB_ID":
            episode.epImdbId = currentCharactersParsed
        case "Language":
            episode.epLanguage = currentCharactersParsed
        case "Overview":
            episode.epOverview = currentCharactersParsed
        case "Rating":
            if let rating = Double(currentCharactersParsed) {
                episode.epRating = rating
            }
        case "RatingCount":
            if let ratingCount = Int(currentCharactersParsed) {
                episode.epRatingCount = ratingCount
            }
        case "SeasonNumber":
            if let number = Int(currentCharactersParsed) {
                episode.epSeason = number
            }
        case "filename":
            episode.epFilename = currentCharactersParsed
        case "lastupdated":
            if let interval = Double(currentCharactersParsed) {
                episode.epLastUpdated = NSDate(timeIntervalSince1970: interval)
            }
        case "seasonid":
            episode.seasonId = currentCharactersParsed
        case "seriesid":
            episode.serieId = currentCharactersParsed
        default:
            break
        }
    }
 
}
