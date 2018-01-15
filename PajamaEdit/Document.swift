//
//  Document.swift
//  PajamaEdit
//
//  Created by Sahand on 1/14/18.
//  Copyright © 2018 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    var utf8String: String? = nil
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data else {
            return
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            return
        }
        
        self.utf8String = string
    }
}

