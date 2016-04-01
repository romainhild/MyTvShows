//
//  TvDBImagesParser.swift
//  MyTvShows
//
//  Created by Romain Hild on 01/04/2016.
//  Copyright © 2016 Romain Hild. All rights reserved.
//

import Foundation

class TvDBImagesParser: NSObject, NSXMLParserDelegate {
    
    var type: Serie.ImageType
    
    var delegate: TvDBImagesParserDelegate?
    
    var currentCharactersParsed = ""
    var currentBanner: Banner?
    
    init(type: Serie.ImageType) {
        self.type = type
    }
    
    func parseImagesData(data: NSData) -> Bool {
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "Banner" {
            currentBanner = Banner()
        }
        currentCharactersParsed = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if string != "\n" {
            currentCharactersParsed += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Banner":
            delegate?.parser(self, parsedImage: currentBanner!)
        case "BannerPath":
            currentBanner?.bannerPath = currentCharactersParsed
        case "ThumbnailPath":
            currentBanner?.thumbnailPath = currentCharactersParsed
        case "BannerType":
            currentBanner?.bannerType = currentCharactersParsed
        case "BannerType2":
            currentBanner?.bannerType2 = currentCharactersParsed
        default:
            break
        }
    }
}

protocol TvDBImagesParserDelegate {
    func parser(parser: TvDBImagesParser, parsedImage image: Banner)
}
