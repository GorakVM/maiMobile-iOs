//
//  XMLParser.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 12/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import Foundation

class XMLParser: NSObject, NSXMLParserDelegate {
    
    var dictionary = [String : AnyObject]()
    var charactersFound = ""
    var elementFound = false
    var array = [AnyObject]()
    
    init(data: NSData, handler: (AnyObject) -> Void) {
        super.init()
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        handler(array)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        elementFound = true
        charactersFound.removeAll()
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
//        print("foundCharacters: \(string)")
        if elementFound {
            charactersFound += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        dictionary[elementName] = charactersFound
        array.append(dictionary)
        dictionary.removeAll()
        charactersFound.removeAll()
        elementFound = false
    }
    
}