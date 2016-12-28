//
//  CSVParsingSupport.swift
//  Forte
//
//  Created by Jeff Fang on 5/1/16.
//  Copyright © 2016 swordx. All rights reserved.
//

import Foundation

struct ParseItem {
    var term: String
    var meaning: String
    var origin: String
}

class Parser {
    class func parseCSV(_ contentsOfURL: URL, encoding: String.Encoding) -> [ParseItem]? {
        let origins: [String: String] = ["(Fre)":"French",
                                         "(Ger)":"German",
                                         "(Por)":"Portuguese",
                                         "(Eng)":"English",
                                         "(Ita)":"Italian",
                                         "(Lat)":"Latin",
                                         "(Pol)":"Polish"]
        
        // Load the CSV file and parse it
        let delimiter = ","
        var items: [ParseItem] = []
        
        do {
            let content = try String(contentsOf: contentsOfURL, encoding: encoding)
            print(content)
            let lines:[String] = content.components(separatedBy: CharacterSet.newlines) as [String]
            
            for line in lines {
                var values:[String] = []
                var itemOriginDescription = ""
                
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            if value != "" {
                                for (origin, fullOrigin) in origins {
                                    if value!.contains(origin) {
                                        itemOriginDescription = fullOrigin
                                        value = value!.replacingOccurrences(of: origin, with: "") as NSString?
                                    }
                                }
                                
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.characters.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    let item = ParseItem(term: values[0], meaning: values[1], origin: itemOriginDescription)
                    items.append(item)
                }
            }
        } catch {
            print(error)
        }
        
        return items
    }
}
