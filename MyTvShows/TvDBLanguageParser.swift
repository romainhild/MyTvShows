//
//  TvDBLanguageParser.swift
//  MyTvShows
//
//  Created by Romain Hild on 30/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class TvDBLanguageParser: NSObject, NSXMLParserDelegate {
    
    var delegate: TvDBLanguageParserDelegate?
    
    var currentCharactersParsed = ""
    var currentLanguage = ""
    var currentAbbreviation = ""
    
    func parseLanguageData(data: NSData) -> Bool {
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
        case "name":
            currentLanguage = currentCharactersParsed
        case "abbreviation":
            currentAbbreviation = currentCharactersParsed
        case "Language":
            delegate?.parser(self, parsedLanguage: currentLanguage, withAbbreviation: currentAbbreviation)
        default:
            break
        }
    }
}

protocol TvDBLanguageParserDelegate {
    func parser(parser: TvDBLanguageParser, parsedLanguage language: String, withAbbreviation abbr: String)
}