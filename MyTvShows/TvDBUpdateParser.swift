//
//  TvDBUpdateParser.swift
//  MyTvShows
//
//  Created by Romain Hild on 28/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class TvDBUpdateParser: NSObject, NSXMLParserDelegate {
    static let sharedInstance = TvDBUpdateParser()
    
    var delegate: TvDBUpdateParserDelegate?
    
    var currentCharacterParsed = ""
    
    func parseUpdateData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentCharacterParsed = ""
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Time":
            delegate?.parser(self, parsedTime: currentCharacterParsed)
        case "Series":
            delegate?.parser(self, parsedSeriesId: currentCharacterParsed)
        case "Episode":
            delegate?.parser(self, parsedEpisodeId: currentCharacterParsed)
        default:
            break
        }
        currentCharacterParsed = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            currentCharacterParsed += string
        }
    }
}

protocol TvDBUpdateParserDelegate {
    func parser(parser: TvDBUpdateParser, parsedTime time: String)
    func parser(parser: TvDBUpdateParser, parsedSeriesId seriesid: String)
    func parser(parser: TvDBUpdateParser, parsedEpisodeId episodeid: String)
}
