//
//  TvDBSearchParser.swift
//  MyTvShows
//
//  Created by Romain Hild on 28/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class TvDBSearchParser: NSObject, NSXMLParserDelegate {
    static let sharedInstance = TvDBSearchParser()
    
    var delegate: TvDBSearchParserDelegate?
    
    var currentCharacterParsed = ""
    var currentSearch: SearchResult?
    
    func parseSearchData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "Series" {
            currentSearch = SearchResult()
        }
        currentCharacterParsed = ""
    }

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            currentCharacterParsed += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Series":
            delegate?.parser(self, parsedSearchResult: currentSearch!)
            currentSearch = nil
        case "seriesid":
            currentSearch?.id = currentCharacterParsed
        case "SeriesName":
            currentSearch?.name = currentCharacterParsed
        case "language":
            currentSearch?.lang = currentCharacterParsed
        default:
            break
        }
    }
    
}

protocol TvDBSearchParserDelegate {
    func parser(parser: TvDBSearchParser, parsedSearchResult search: SearchResult)
}