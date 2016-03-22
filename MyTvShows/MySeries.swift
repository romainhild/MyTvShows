//
//  MySeries.swift
//  MyTvShows
//
//  Created by Romain Hild on 15/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class MySeries: NSObject, NSCoding {
    var series = [Serie]()
    var delegate: MySeriesDelegate?
    var previousTime = ""
    
    var currentChararcterParsed = ""
    
    var count: Int {
        return series.count
    }
    
    override init() {
        super.init()
        
        let tvDBApi = TvDBApiSingleton.sharedInstance
        let url = tvDBApi.urlForCurrentTime()
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) {
            data, response, error in
            if let error = error where error.code == -999 {
                return
            }
            else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                self.parseXMLData(data!)
            }
            else {
                print("Failure! \(response)")
            }
        }
        
        dataTask.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        series = aDecoder.decodeObjectForKey("series") as! [Serie]
        previousTime = aDecoder.decodeObjectForKey("previousTime") as! String
        super.init()
        for serie in series {
            serie.delegate = self
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(series, forKey: "series")
        aCoder.encodeObject(previousTime, forKey: "previousTime")
    }
    
    subscript(index: Int) -> Serie {
        get {
            return series[index]
        }
        set {
            newValue.delegate = self
            series[index] = newValue
        }
    }
    
    func append(serie: Serie) {
        serie.delegate = self
        series.append(serie)
    }
    
    func remove(index: Int) {
        series.removeAtIndex(index)
    }
    
    func update(sender: MySeriesTableViewController) {
        let tvDBApi = TvDBApiSingleton.sharedInstance
        let url = tvDBApi.urlForUpdateWithTime(previousTime)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) {
            [weak sender] data, response, error in
            if let error = error where error.code == -999 {
                return
            }
            else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                self.parseXMLData(data!)
            }
            else {
                print("Failure! \(response)")
            }
            dispatch_async(dispatch_get_main_queue()) {
                sender?.refreshControl?.endRefreshing()
            }
        }
        
        dataTask.resume()
    }
    
    func serieWithId(id: String) -> Serie? {
        if let i = series.indexOf( { $0.seriesid == id } ) {
            return series[i]
        }
        else {
            return nil
        }
    }
    
    func episodeWithId(id: String) -> Episode? {
        for serie in series {
            for season in serie.seasons {
                if let i = season.episodes.indexOf({$0.epId == id }) {
                    return season.episodes[i]
                }
            }
        }
        return nil
    }
}

extension MySeries: SerieDelegate {
    func serieFinishedInit(serie: Serie) {
        series.sortInPlace(<)
        delegate?.mySeriesNeedRefresh(self)
    }
}

extension MySeries: NSXMLParserDelegate {
    func parseXMLData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentChararcterParsed = ""
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Time" {
            previousTime = currentChararcterParsed
        }
        else if elementName == "Series" {
            if let serie = serieWithId(currentChararcterParsed) {
                serie.update()
            }
        }
        else if elementName == "Episode" {
            if let episode = episodeWithId(currentChararcterParsed) {
                episode.update()
            }
        }
        currentChararcterParsed = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            currentChararcterParsed += string
        }
    }
}

protocol MySeriesDelegate: class {
    func mySeriesNeedRefresh(myseries: MySeries)
}