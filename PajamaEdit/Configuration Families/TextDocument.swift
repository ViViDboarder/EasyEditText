//
//  Document.swift
//  PajamaEdit
//
//  Created by Sahand on 1/14/18.
//  Copyright © 2018 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import Foundation

class TextDocument: UIDocument {
    
    var utf8String: String = ""
    
    override func contents(forType typeName: String) throws -> Any {
        guard let data = utf8String.data(using: .utf8) else {
            fatalError()
        }
        
        return data
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
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        return [
            URLResourceKey.hasHiddenExtensionKey: true
        ]
    }
}

