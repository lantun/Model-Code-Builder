//
//  Document.swift
//  Model Code Builder
//
//  Created by Tun Lan on 6/3/16.
//  Copyright © 2016 Tun Lan. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var mcbData: Global = Global()

    override init() {
        super.init()
        mcbData.source = Global.fakeSourceApi()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        
        let tabVC:NSTabViewController = windowController.contentViewController as! NSTabViewController
        let listVC:LTModelListViewController = (tabVC.tabViewItems[0] ).viewController as! LTModelListViewController
        listVC.mcbData = mcbData
        listVC.listTableView.reloadData()
        
        let codeVC:LTModelCodeViewCtroller = (tabVC.tabViewItems[1] ).viewController as! LTModelCodeViewCtroller
        codeVC.mcbData = mcbData
        self.addWindowController(windowController)
        
    }

    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(mcbData.source)
        return data
        
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }


    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        
        mcbData.source = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [[String:AnyObject]]
        
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }


}

