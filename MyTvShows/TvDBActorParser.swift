//
//  TvDBActorParser.swift
//  MyTvShows
//
//  Created by Romain Hild on 28/03/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

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
        switch elementName {
        case "Actor":
            delegate?.parser(self, parsedActor: currentActor!)
            currentActor = nil
        case "Image":
            currentActor?.imageURL = currentCharacterParsed
        case "Name":
            currentActor?.name = currentCharacterParsed
        case "Role":
            currentActor?.role = currentCharacterParsed
        case "SortOrder":
            currentActor?.sortOrder = Int(currentCharacterParsed)!
        default:
            break
        }
    }
}

protocol TvDBActorParserDelegate {
    func parser(parser: TvDBActorParser, parsedActor actor: Actor)
}
