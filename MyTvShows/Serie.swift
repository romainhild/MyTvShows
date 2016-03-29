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
    
    var actorsAsString = [String]()
    var actors = [Actor]()
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
                let parser = TvDBSerieParser(serie: self)
                if parser.parseSerieData(data!) {
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
        
        actorsAsString = aDecoder.decodeObjectForKey("actorsAsString") as! [String]
        actors = aDecoder.decodeObjectForKey("actors") as!  [Actor]
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
        
        aCoder.encodeObject(actorsAsString, forKey: "actorsAsString")
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
    
    deinit {
        let fileManager = NSFileManager.defaultManager()
        if let url = bannerLocalURL, destinationURL = localFilePathForUrl(url.absoluteString) {
            do {
                try fileManager.removeItemAtURL(destinationURL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
        }
        if let url = posterLocalURL, destinationURL = localFilePathForUrl(url.absoluteString) {
            do {
                try fileManager.removeItemAtURL(destinationURL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
        }
        if let url = fanartLocalURL, destinationURL = localFilePathForUrl(url.absoluteString) {
            do {
                try fileManager.removeItemAtURL(destinationURL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
        }
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
                let parser = TvDBSerieParser(serie: self)
                if parser.parseSerieData(data!) {
                    self.seasons.sortInPlace(<)
                    self.findNextEpisode()
                    // crash if called
                    //self.delegate?.serieFinishedInit(self)
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
                if episode >= now {
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

