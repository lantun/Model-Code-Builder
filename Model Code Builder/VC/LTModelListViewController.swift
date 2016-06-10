//
//  LTModelListViewController.swift
//  Model Code Builder
//
//  Created by Tun Lan on 6/3/16.
//  Copyright © 2016 Tun Lan. All rights reserved.
//

import Cocoa

class LTModelListViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {

    @IBOutlet weak var listTableView: NSTableView!
    
    weak var mcbData:Global?  = nil
    
    
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func doubleAction(sender: NSTableView) {
        if sender.clickedRow != -1 {
            if sender.clickedColumn == 0 {
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                let ModelDetailViewController:LTModelDetailViewController = storyboard.instantiateControllerWithIdentifier("ModelDetail") as! LTModelDetailViewController
                
                self.presentViewControllerAsSheet(ModelDetailViewController)
                ModelDetailViewController.modelIndex = sender.clickedRow
                ModelDetailViewController.mcbData = mcbData
                let model:[String:AnyObject]? = mcbData?.source[sender.clickedRow]
                ModelDetailViewController.nameTextField.stringValue = model?["name"] as! String
                ModelDetailViewController.detailTableView.reloadData()
                
            }else if sender.clickedColumn == 1 {
                sender.editColumn(sender.clickedColumn, row: sender.clickedRow, withEvent: nil, select: true)
            }
        }else{
            
            // add model
            let fakeModel:[String:AnyObject] = ["name": "newModel", "item": [[String:AnyObject]](), "remark": "remark"]
            mcbData?.source.append(fakeModel)
            listTableView.reloadData()
            listTableView.selectRowIndexes(NSIndexSet(index: (mcbData?.source.count)!-1), byExtendingSelection: true)
            listTableView.editColumn(1, row: (mcbData?.source.count)!-1, withEvent: nil, select: true)
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let ModelDetailViewController:LTModelDetailViewController = storyboard.instantiateControllerWithIdentifier("ModelDetail") as! LTModelDetailViewController
            self.presentViewControllerAsSheet(ModelDetailViewController)
            
            ModelDetailViewController.modelIndex = sender.numberOfRows - 1
            ModelDetailViewController.mcbData = mcbData
            ModelDetailViewController.nameTextField.stringValue = "newModel"
            
        }
        
        
    }

    
    
    internal func numberOfRowsInTableView(tableView: NSTableView) -> Int{
        if (mcbData != nil) {
            return (mcbData?.source.count)!
        }
        return 0
    }
    
    internal func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int){
        var model:[String:AnyObject] = (mcbData?.source[row])!
        if tableColumn?.identifier == "list_remark"{
            model["remark"] = object as! String
        }
        mcbData?.source[row] = model
    }
    
    internal func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?{
        let item:[String:AnyObject] = (mcbData?.source[row])!
        if tableColumn?.identifier == "list_name"{
            return item["name"]
        }
        if tableColumn?.identifier == "list_remark"{
            return item["remark"]
        }
        return "err"
    }
    
    internal func tableView(tableView: NSTableView, toolTipForCell cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, row: Int, mouseLocation: NSPoint) -> String{
        if tableColumn?.identifier == "list_name" {
            return "double click to change mode data"
        }
        return "double click to change mode remark"
    }
    
    internal func tableView(tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableRowActionEdge) -> [NSTableViewRowAction]{
        return [NSTableViewRowAction(style: .Destructive, title: "delete") { (action:NSTableViewRowAction, row:Int) in
            self.mcbData?.source.removeAtIndex(row)
            self.listTableView.reloadData()
        }]
    }
}
