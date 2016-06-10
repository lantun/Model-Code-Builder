//
//  LTModelDetailViewController.swift
//  Model Code Builder
//
//  Created by Tun Lan on 6/3/16.
//  Copyright © 2016 Tun Lan. All rights reserved.
//

import Cocoa

class LTModelDetailViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate {

    @IBOutlet weak var applyBtn: NSButton!
    @IBOutlet weak var detailTableView: NSTableView!
    @IBOutlet weak var nameTextField: NSTextField!
    
    weak var mcbData:Global?  = nil
    
    var modelIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if (mcbData != nil) {
            let model:[String:AnyObject]? = mcbData?.source[modelIndex]
            nameTextField.stringValue = (model?["name"])! as! String
        }
    }
    
    @IBAction func applyAction(sender: AnyObject) {
        self.dismissController(sender)
    }

    @IBAction func doubleAction(sender: AnyObject) {
        if sender.clickedRow != -1 {
            sender.editColumn(sender.clickedColumn, row: sender.clickedRow, withEvent: nil, select: true)
        }else{
            sender.beginUpdates()
            var model:[String:AnyObject]? = mcbData?.source[modelIndex]
            let item:[String:AnyObject] = ["name": "", "type": "String", "alias": "", "remark": ""]
            var items:[[String:AnyObject]] = model?["item"] as! [[String:AnyObject]]
            items.append(item)
            mcbData?.source[modelIndex] = model!
            sender.insertRowsAtIndexes(NSIndexSet(index: sender.numberOfRows), withAnimation: .EffectFade)
            sender.endUpdates()
            sender.editColumn(0, row: sender.numberOfRows-1, withEvent: nil, select: true)
        }
    }
    
    internal func numberOfRowsInTableView(tableView: NSTableView) -> Int{
        if (mcbData != nil) {
            let model:[String:AnyObject]? = mcbData?.source[modelIndex]
            return (model?["item"]!.count)!
        }
        return 0
    }
    
    internal func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?{
        let model:[String:AnyObject]? = mcbData?.source[modelIndex]
        var items:[[String:AnyObject]] = model?["item"] as! [[String:AnyObject]]
        let item:[String:AnyObject] = items[row]
        if tableColumn?.identifier == "parameter_name"{
            return item["name"]
        }
        if tableColumn?.identifier == "parameter_type"{
            return item["type"]
        }
        if tableColumn?.identifier == "parameter_alias"{
            return item["alias"]
        }
        if tableColumn?.identifier == "parameter_remark"{
            return item["remark"]
        }
        return "err"
    }
    
    internal func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int){
        var model:[String:AnyObject]? = mcbData?.source[modelIndex]
        var items:[[String:AnyObject]] = model?["item"] as! [[String:AnyObject]]
        var item:[String:AnyObject] = items[row]
        if tableColumn?.identifier == "parameter_name"{
            item["name"] = object as! String
            item["alias"] = object as! String
        }
        if tableColumn?.identifier == "parameter_type"{
            item["type"] = object as! String
        }
        if tableColumn?.identifier == "parameter_alias"{
            item["alias"] = object as! String
        }
        if tableColumn?.identifier == "parameter_remark"{
            item["remark"] = object as! String
        }
        items[row] = item
        model?.updateValue(items, forKey: "item")
        mcbData?.source[modelIndex] = model!
    }
    
    internal func tableView(tableView: NSTableView, toolTipForCell cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, row: Int, mouseLocation: NSPoint) -> String{
        if tableColumn?.identifier == "parameter_name" {
            return "double click to change parameter name"
        }
        if tableColumn?.identifier == "parameter_type" {
            return "double click to change parameter type"
        }
        if tableColumn?.identifier == "parameter_alias" {
            return "double click to change parameter alias"
        }
        if tableColumn?.identifier == "parameter_remark" {
            return "double click to change parameter remark"
        }
        return "double click to change parameter"
    }

    internal func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool{
        if control == nameTextField{
            var model:[String:AnyObject]? = mcbData?.source[modelIndex]
            model?["name"] = fieldEditor.string!
            mcbData?.source[modelIndex] = model!
        }
        
        return true
    }
    
}
