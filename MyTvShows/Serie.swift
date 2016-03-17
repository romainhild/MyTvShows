//
//  Serie.swift
//  MyTvShows
//
//  Created by Romain Hild on 14/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Serie : NSObject {
    
    var delegate: SerieDelegate?
    
    static let firstAiredFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let firstAiredStringFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    static let addedFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    var seriesid: String
    
    var actorsAsString = ""
    var actors = [String]()
    var airsDayOfWeek = ""
    var airsTime = ""
    var contentRating = ""
    var firstAiredAsString = ""
    var firstAired: NSDate?
    var genreAsString = ""
    var genre = [String]()
    var imdbId = ""
    var language = ""
    var network = ""
    var overview = ""
    var ratingAsString = ""
    var rating = -1.0
    var ratingCountAsString = ""
    var ratingCount = -1
    var runtimeAsString = ""
    var runtime = -1
    var seriesName = ""
    var status = ""
    var addedAsString = ""
    var added: NSDate?
    var addedByAsString = ""
    var addedBy = -1
    var banner = ""
    var fanart = ""
    var lastupdatedAsString = ""
    var lastupdated: NSDate?
    var poster = ""
    var zap2itId = ""
    
    var indexOfOverview: NSIndexPath?
    var indexOfRatings: NSIndexPath?
    var indexOfGenre = [NSIndexPath]()
    var indexOfFirstAired: NSIndexPath?
    var indexOfStatus: NSIndexPath?
    var indexOfAirDay: NSIndexPath?
    var indexOfAirTime: NSIndexPath?
    var indexOfNetwork: NSIndexPath?
    var indexOfRuntime: NSIndexPath?
    var numberOfRows = 0
    
    var currentCharactersParsed = ""
    var currentEpisodeParsed: Episode?
    
    var error = false
    
    init( id: String) {
        seriesid = id

        super.init()
        
        let tvDBApi = TvDBApiSingleton.sharedInstance
        let url = tvDBApi.urlForSerieId(seriesid)
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) {
            data, response, error in
            if let error = error where error.code == -999 {
                return
            } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                if self.parseXMLData(data!) {
                    self.initIndexes()
                    self.delegate?.serieFinishedInit(self)
                } else {
                    self.error = true
                    print("Error while parsing series")
                }
            } else {
                print("Failure! \(response)")
                self.error = true
            }
        }
        dataTask.resume()
    }
    
    func initIndexes() {
        var rows = 0
        if !overview.isEmpty {
            indexOfOverview = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        if rating != -1 {
            indexOfRatings = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        if !genre.isEmpty {
            for _ in genre {
                indexOfGenre.append(NSIndexPath(forRow: rows, inSection: 0))
                rows++
            }
        }
        if let _ = firstAired {
            indexOfFirstAired = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        if !status.isEmpty {
            indexOfStatus = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        if !airsDayOfWeek.isEmpty {
            indexOfAirDay = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        if !airsTime.isEmpty {
            indexOfAirTime = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        if !network.isEmpty {
            indexOfNetwork = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        if runtime != -1 {
            indexOfRuntime = NSIndexPath(forRow: rows, inSection: 0)
            rows++
        }
        numberOfRows = rows
    }
}

extension Serie: NSXMLParserDelegate {
    func parseXMLData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementParsed = elementName
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Actors":
            actors = actorsAsString.componentsSeparatedByString("|").filter { !$0.isEmpty }
        case "FirstAired":
            firstAired = Serie.firstAiredFormatter.dateFromString(firstAiredAsString)
        case "Genre":
            genre = genreAsString.componentsSeparatedByString("|").filter { !$0.isEmpty }
        case "Rating":
            if !ratingAsString.isEmpty, let rating = Double(ratingAsString) {
                self.rating = rating
            }
        case "RatingCount":
            if !ratingCountAsString.isEmpty, let ratingCount = Int(ratingCountAsString) {
                self.ratingCount = ratingCount
            }
        case "Runtime":
            if !runtimeAsString.isEmpty, let runtime = Int(runtimeAsString) {
                self.runtime = runtime
            }
        case "added":
            added = Serie.addedFormatter.dateFromString(addedAsString)
        case "addedBy":
            if !addedByAsString.isEmpty, let addedBy = Int(addedByAsString) {
                self.addedBy = addedBy
            }
        case "lastupdated":
            if let interval = Double(lastupdatedAsString) {
                lastupdated = NSDate(timeIntervalSince1970: interval)
            }
        default:
            break
        }
        currentElementParsed = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            switch currentElementParsed {
            case "Actors":
                actorsAsString += string
            case "Airs_DayOfWeek":
                airsDayOfWeek += string
            case "Airs_Time":
                airsTime += string
            case "ContentRating":
                contentRating += string
            case "FirstAired":
                firstAiredAsString += string
            case "Genre":
                genreAsString += string
            case "IMDB_ID":
                imdbId += string
            case "Language":
                language += string
            case "Network":
                network += string
            case "Overview":
                overview += string
            case "Rating":
                ratingAsString += string
            case "RatingCount":
                ratingCountAsString += string
            case "Runtime":
                runtimeAsString += string
            case "SeriesName":
                seriesName += string
            case "Status":
                status += string
            case "added":
                addedAsString += string
            case "addedBy":
                addedByAsString += string
            case "banner":
                banner += string
            case "fanart":
                fanart += string
            case "lastupdated":
                lastupdatedAsString += string
            case "poster":
                poster += string
            case "zap2it_id":
                zap2itId += string
            default:
                break
            }
        }
    }
}

protocol SerieDelegate: class {
    func serieFinishedInit(serie: Serie)
}

func < (lhs: Serie, rhs: Serie) -> Bool {
    return lhs.seriesName.localizedStandardCompare(rhs.seriesName) == .OrderedAscending
}
