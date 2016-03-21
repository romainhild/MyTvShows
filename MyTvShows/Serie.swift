//
//  Serie.swift
//  MyTvShows
//
//  Created by Romain Hild on 14/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class Serie : NSObject, NSCoding {
    
    enum ImageType {
        case Banner
        case Poster
        case FanArt
    }
    
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
    
    var delegate: SerieDelegate?
    var delegateBanner: SerieBannerDelegate?
    var delegatePoster: SeriePosterDelegate?
    var delegateFanArt: SerieFanArtDelegate?
    
    var seriesid: String
    var seasons = [Season]()
    
    var actors = [String]()
    var airsDayOfWeek = ""
    var airsTime = ""
    var firstAired: NSDate?
    var genre = [String]()
    var imdbId = ""
    var language = ""
    var network = ""
    var overview = ""
    var rating = -1.0
    var ratingCount = -1
    var runtime = -1
    var seriesName = ""
    var status = ""
    var added: NSDate?
    var addedBy = -1
    var banner = ""
    var bannerLocalURL: NSURL?
    var fanart = ""
    var fanartLocalURL: NSURL?
    var lastupdated: NSDate?
    var poster = ""
    var posterLocalURL: NSURL?
    var zap2itId = ""
    var nextEpisode: NSDate?
    
    var posterColors: UIImageColors?
    
    var numberOfSeasons: Int {
        return seasons.count
    }
    
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
            }
            else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                if self.parseXMLData(data!) {
                    self.seasons.sortInPlace(<)
                    self.findNextEpisode()
                    self.delegate?.serieFinishedInit(self)
                } else {
                    self.error = true
                    print("Error while parsing series")
                }
            }
            else {
                print("Failure! \(response)")
                self.error = true
            }
        }
        dataTask.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        seriesid = ""
        super.init()
        seriesid = aDecoder.decodeObjectForKey("seriesid") as!  String
        seasons = aDecoder.decodeObjectForKey("seasons") as!  [Season]
        
        actors = aDecoder.decodeObjectForKey("actors") as!  [String]
        airsDayOfWeek = aDecoder.decodeObjectForKey("airsDayOfWeek") as!  String
        airsTime = aDecoder.decodeObjectForKey("airsTime") as!  String
        firstAired = aDecoder.decodeObjectForKey("firstAired") as!  NSDate?
        genre = aDecoder.decodeObjectForKey("genre") as!  [String]
        imdbId = aDecoder.decodeObjectForKey("imdbId") as!  String
        language = aDecoder.decodeObjectForKey("language") as!  String
        network = aDecoder.decodeObjectForKey("network") as!  String
        overview = aDecoder.decodeObjectForKey("overview") as!  String
        rating = aDecoder.decodeObjectForKey("rating") as! Double
        ratingCount = aDecoder.decodeObjectForKey("ratingCount") as! Int
        runtime = aDecoder.decodeObjectForKey("runtime") as! Int
        seriesName = aDecoder.decodeObjectForKey("seriesName") as!  String
        status = aDecoder.decodeObjectForKey("status") as!  String
        added = aDecoder.decodeObjectForKey("added") as!  NSDate?
        addedBy = aDecoder.decodeObjectForKey("addedBy") as! Int
        banner = aDecoder.decodeObjectForKey("banner") as!  String
        bannerLocalURL = aDecoder.decodeObjectForKey("bannerLocalURL") as!  NSURL?
        fanart = aDecoder.decodeObjectForKey("fanart") as!  String
        fanartLocalURL = aDecoder.decodeObjectForKey("fanartLocalURL") as!  NSURL?
        lastupdated = aDecoder.decodeObjectForKey("lastupdated") as!  NSDate?
        poster = aDecoder.decodeObjectForKey("poster") as!  String
        posterLocalURL = aDecoder.decodeObjectForKey("posterLocalURL") as!  NSURL?
        zap2itId = aDecoder.decodeObjectForKey("zap2itId") as!  String
        nextEpisode = aDecoder.decodeObjectForKey("nextEpisode") as!  NSDate?
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(seriesid, forKey: "seriesid")
        aCoder.encodeObject(seasons, forKey: "seasons")
        
        aCoder.encodeObject(actors, forKey: "actors")
        aCoder.encodeObject(airsDayOfWeek, forKey: "airsDayOfWeek")
        aCoder.encodeObject(airsTime, forKey: "airsTime")
        aCoder.encodeObject(firstAired, forKey: "firstAired")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(imdbId, forKey: "imdbId")
        aCoder.encodeObject(language, forKey: "language")
        aCoder.encodeObject(network, forKey: "network")
        aCoder.encodeObject(overview, forKey: "overview")
        aCoder.encodeObject(rating, forKey: "rating")
        aCoder.encodeObject(ratingCount, forKey: "ratingCount")
        aCoder.encodeObject(runtime, forKey: "runtime")
        aCoder.encodeObject(seriesName, forKey: "seriesName")
        aCoder.encodeObject(status, forKey: "status")
        aCoder.encodeObject(added, forKey: "added")
        aCoder.encodeObject(addedBy, forKey: "addedBy")
        aCoder.encodeObject(banner, forKey: "banner")
        aCoder.encodeObject(bannerLocalURL, forKey: "bannerLocalURL")
        aCoder.encodeObject(fanart, forKey: "fanart")
        aCoder.encodeObject(fanartLocalURL, forKey: "fanartLocalURL")
        aCoder.encodeObject(lastupdated, forKey: "lastupdated")
        aCoder.encodeObject(poster, forKey: "poster")
        aCoder.encodeObject(posterLocalURL, forKey: "posterLocalURL")
        aCoder.encodeObject(zap2itId, forKey: "zap2itId")
        aCoder.encodeObject(nextEpisode, forKey: "nextEpisode")
    }
    
    func update() {
        let tvDBApi = TvDBApiSingleton.sharedInstance
        let url = tvDBApi.urlForUpdatingSerieWithId(seriesid)
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) {
            data, response, error in
            if let error = error where error.code == -999 {
                return
            }
            else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                if self.parseXMLData(data!) {
                    self.seasons.sortInPlace(<)
                    self.findNextEpisode()
                    self.delegate?.serieFinishedInit(self)
                } else {
                    self.error = true
                    print("Error while parsing series")
                }
            }
            else {
                print("Failure! \(response)")
                self.error = true
            }
        }
        dataTask.resume()        
    }
    
    func indexOfSeasonWithId(id: String) -> Int? {
        return seasons.indexOf { $0.seasonId == id }
    }
    
    func findNextEpisode() {
        let now = NSDate()
        if let lastSeason = seasons.last {
            for episode in lastSeason.episodes {
                if episode > now {
                    nextEpisode = episode.epFirstAired!
                    break
                }
            }
        }
    }
    
    func downloadImage(type: ImageType) {
        let tvDBApi = TvDBApiSingleton.sharedInstance
        let url: NSURL
        switch type {
        case .Banner:
            url = tvDBApi.urlForBanner(banner)
        case .Poster:
            url = tvDBApi.urlForBanner(poster)
        case .FanArt:
            url = tvDBApi.urlForBanner(fanart)
        }
        
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url) {
            [weak self, type] url, response, error in
            if let error = error where error.code == -999 {
                return
            } else if error == nil, let url = url, destinationURL = localFilePathForUrl(url.absoluteString) {
                // copy to sandbox
                let fileManager = NSFileManager.defaultManager()
                do {
                    try fileManager.removeItemAtURL(destinationURL)
                } catch {
                    // Non-fatal: file probably doesn't exist
                }
                do {
                    try fileManager.copyItemAtURL(url, toURL: destinationURL)
                } catch let error as NSError {
                    print("Could not copy file to disk: \(error.localizedDescription)")
                }
                switch type {
                case .Banner:
                    self?.bannerLocalURL = destinationURL
                    self?.delegateBanner?.serieFinishedDownloadBanner(self!)
                case .Poster:
                    self?.posterLocalURL = destinationURL
                    self?.delegatePoster?.serieFinishedDownloadPoster(self!)
                case .FanArt:
                    self?.fanartLocalURL = destinationURL
                    self?.delegateFanArt?.serieFinishedDownloadFanArt(self!)
                }
            }
        }
        
        downloadTask.resume()
    }
}

extension Serie: NSXMLParserDelegate {
    func parseXMLData(data: NSData) -> Bool {
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
                if let number = indexOfSeasonWithId(episode.seasonId) {
                    seasons[number].append(episode)
                }
                else {
                    let season = Season(id: episode.seasonId, number: episode.epSeason)
                    season.append(episode)
                    seasons.append(season)
                }
                currentEpisodeParsed = nil
            default:
                break
            }
        }
        else { // Serie
            switch elementName {
            case "Actors":
                actors = currentCharactersParsed.componentsSeparatedByString("|").filter { !$0.isEmpty }
            case "Airs_DayOfWeek":
                airsDayOfWeek = currentCharactersParsed
            case "Airs_Time":
                airsTime = currentCharactersParsed
            case "FirstAired":
                firstAired = Serie.firstAiredFormatter.dateFromString(currentCharactersParsed)
            case "Genre":
                genre = currentCharactersParsed.componentsSeparatedByString("|").filter { !$0.isEmpty }
            case "IMDB_ID":
                imdbId = currentCharactersParsed
            case "Language":
                language = currentCharactersParsed
            case "Network":
                network = currentCharactersParsed
            case "Overview":
                overview = currentCharactersParsed
            case "Rating":
                if let rating = Double(currentCharactersParsed) {
                    self.rating = rating
                }
            case "RatingCount":
                if let ratingCount = Int(currentCharactersParsed) {
                    self.ratingCount = ratingCount
                }
            case "Runtime":
                if  let runtime = Int(currentCharactersParsed) {
                    self.runtime = runtime
                }
            case "SeriesName":
                seriesName = currentCharactersParsed
            case "Status":
                status = currentCharactersParsed
            case "added":
                added = Serie.addedFormatter.dateFromString(currentCharactersParsed)
            case "addedBy":
                if  let addedBy = Int(currentCharactersParsed) {
                    self.addedBy = addedBy
                }
            case "banner":
                if banner != currentCharactersParsed {
                    banner = currentCharactersParsed
                    downloadImage(.Banner)
                }
            case "fanart":
                if fanart != currentCharactersParsed {
                    fanart = currentCharactersParsed
                    downloadImage(.FanArt)
                }
            case "lastupdated":
                if let interval = Double(currentCharactersParsed) {
                    lastupdated = NSDate(timeIntervalSince1970: interval)
                }
            case "poster":
                if poster != currentCharactersParsed {
                    poster = currentCharactersParsed
                    downloadImage(.Poster)
                }
            case "zap2it_id":
                zap2itId = currentCharactersParsed
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

protocol SerieDelegate: class {
    func serieFinishedInit(serie: Serie)
}

protocol SerieBannerDelegate: class {
    func serieFinishedDownloadBanner(serie: Serie)
}

protocol SeriePosterDelegate: class {
    func serieFinishedDownloadPoster(serie: Serie)
}

protocol SerieFanArtDelegate: class {
    func serieFinishedDownloadFanArt(serie: Serie)
}

func < (lhs: Serie, rhs: Serie) -> Bool {
    return lhs.seriesName.localizedStandardCompare(rhs.seriesName) == .OrderedAscending
}

