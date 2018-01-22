//
//  Document.swift
//  PajamaEdit
//
//  Created by Sahand on 1/14/18.
//  Copyright © 2018 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import Foundation

enum TextDocumentError: Error {
    case failureToCreate
}

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
    
    static func create(completion: @escaping (TextDocument?, Error?) -> Void) {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Untitled").appendingPathExtension("txt")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let coordinationQueue = OperationQueue()
            coordinationQueue.name = "me.sahand.EasyEditText.documentbrowser.coordinationQueue"
            coordinationQueue.addOperation {
                NSLog("Running operation")
                let document = TextDocument(fileURL: url)
                var error: NSError? = nil
                NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: url, error: &error) { url in
                    document.save(to: url, for: .forCreating, completionHandler: { success in
                        if success {
                            DispatchQueue.main.async {
                                completion(document, nil)
                            }
                        }
                        if let error = error {
                            DispatchQueue.main.async {
                                completion(nil, error)
                            }
                        }
                    })
                }
            }
        }
    }
}

