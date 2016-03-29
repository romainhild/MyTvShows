//
//  TvDBSerieParser.swift
//  MyTvShows
//
//  Created by Romain Hild on 28/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class TvDBSerieParser: NSObject, NSXMLParserDelegate {
    var serie: Serie
    
    var currentCharactersParsed = ""
    var currentEpisodeParsed: Episode?
    
    init(serie: Serie) {
        self.serie = serie
        super.init()
    }
    
    func parseSerieData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentCharactersParsed = ""
        if elementName == "Episode" {
            currentEpisodeParsed = Episode()
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let episode = currentEpisodeParsed { // Episode
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
            case "Episode":
                if let number = serie.indexOfSeasonWithId(episode.seasonId) {
                    serie.seasons[number].append(episode)
                }
                else {
                    let season = Season(id: episode.seasonId, number: episode.epSeason)
                    season.append(episode)
                    serie.seasons.append(season)
                }
                currentEpisodeParsed = nil
            default:
                break
            }
        }
        else { // Serie
            switch elementName {
            case "Actors":
                serie.actorsAsString = currentCharactersParsed.componentsSeparatedByString("|").filter { !$0.isEmpty }
            case "Airs_DayOfWeek":
                serie.airsDayOfWeek = currentCharactersParsed
            case "Airs_Time":
                serie.airsTime = currentCharactersParsed
            case "FirstAired":
                serie.firstAired = Serie.firstAiredFormatter.dateFromString(currentCharactersParsed)
            case "Genre":
                serie.genre = currentCharactersParsed.componentsSeparatedByString("|").filter { !$0.isEmpty }
            case "IMDB_ID":
                serie.imdbId = currentCharactersParsed
            case "Language":
                serie.language = currentCharactersParsed
            case "Network":
                serie.network = currentCharactersParsed
            case "Overview":
                serie.overview = currentCharactersParsed
            case "Rating":
                if let rating = Double(currentCharactersParsed) {
                    serie.rating = rating
                }
            case "RatingCount":
                if let ratingCount = Int(currentCharactersParsed) {
                    serie.ratingCount = ratingCount
                }
            case "Runtime":
                if  let runtime = Int(currentCharactersParsed) {
                    serie.runtime = runtime
                }
            case "SeriesName":
                serie.seriesName = currentCharactersParsed
            case "Status":
                serie.status = currentCharactersParsed
            case "added":
                serie.added = Serie.addedFormatter.dateFromString(currentCharactersParsed)
            case "addedBy":
                if  let addedBy = Int(currentCharactersParsed) {
                    serie.addedBy = addedBy
                }
            case "banner":
                if serie.banner != currentCharactersParsed {
                    serie.banner = currentCharactersParsed
                    serie.downloadImage(.Banner)
                }
            case "fanart":
                if serie.fanart != currentCharactersParsed {
                    serie.fanart = currentCharactersParsed
                    serie.downloadImage(.FanArt)
                }
            case "lastupdated":
                if let interval = Double(currentCharactersParsed) {
                    serie.lastupdated = NSDate(timeIntervalSince1970: interval)
                }
            case "poster":
                if serie.poster != currentCharactersParsed {
                    serie.poster = currentCharactersParsed
                    serie.downloadImage(.Poster)
                }
            case "zap2it_id":
                serie.zap2itId = currentCharactersParsed
            default:
                break
            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            currentCharactersParsed += string
        }
    }
}
