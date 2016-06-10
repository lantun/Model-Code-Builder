//
//  LTModelCodeViewCtroller.swift
//  Model Code Builder
//
//  Created by Tun Lan on 6/4/16.
//  Copyright © 2016 Tun Lan. All rights reserved.
//

import Cocoa

class LTModelCodeViewCtroller: NSViewController {

    @IBOutlet var codeTextView: NSTextView!
    
    weak var mcbData:Global?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func typeValueCode(tyepName:String) -> String {
        var value:String = "\"\""
        switch tyepName {
        case "String":
            value = "\"\""
            break
        case "NSDate":
            value = "NSDate()"
            break
        case "Bool":
            value = "false"
            break
        default:
            value = "\"\""
        }
        return value
    }
    
    override func viewWillAppear() {
        
        var code = "import Foundation\n"
        var body = "\n"
        
        for model:[String:AnyObject] in (mcbData?.source)! {
            let modelRemark:String = model["remark"] as! String
            let modelName:String = model["name"] as! String
            var modelCode:String = "// \(modelRemark)\n"
            modelCode += "class \(modelName):NSObject{\n"
            let parameters:[[String:AnyObject]] = model["item"] as! [[String:AnyObject]]
            for parameter:[String:AnyObject] in parameters{
                let parameterName:String = parameter["name"] as! String
                let parameterType:String = parameter["type"] as! String
//                let parameterAlias:String = parameter["alias"] as! String
                let parameterRemark:String = parameter["remark"] as! String
                let typeValue = typeValueCode(parameterType)
                modelCode += "\tvar \(parameterName):\(parameterType) = \(typeValue)\t//\(parameterRemark)\n"
                
            }
            
            modelCode += "\toverride init() {}\n"
            modelCode += "\tstatic func parseWithDic(dic:[String:AnyObject])->\(modelName) {\n"
            modelCode += "\t\tlet new_\(modelName) = \(modelName)()\n"
            for parameter:[String:AnyObject] in parameters{
                let parameterName:String = parameter["name"] as! String
                let parameterType:String = parameter["type"] as! String
                let parameterAlias:String = parameter["alias"] as! String
//                let parameterRemark:String = parameter["remark"] as! String
//                let typeValue = typeValueCode(parameterType)
                modelCode += "\t\tnew_\(modelName).\(parameterName) = dic[\"\(parameterAlias)\"] as! \(parameterType)\n"
                
            }
            modelCode += "\t\treturn new_\(modelName)\n"
            modelCode += "\t}\n"
            
            modelCode += "\t@objc internal func encodeWithCoder(aCoder: NSCoder){\n"
            for parameter:[String:AnyObject] in parameters{
                let parameterName:String = parameter["name"] as! String
//                let parameterType:String = parameter["type"] as! String
//                let parameterAlias:String = parameter["alias"] as! String
//                let parameterRemark:String = parameter["remark"] as! String
//                let typeValue = typeValueCode(parameterType)
                modelCode += "\t\taCoder.encodeObject(\(parameterName), forKey: \"\(parameterName)\")\n"
                
            }
            modelCode += "\t}\n"
            
            modelCode += "\t@objc internal required init?(coder aDecoder: NSCoder){\n"
            for parameter:[String:AnyObject] in parameters{
                let parameterName:String = parameter["name"] as! String
                let parameterType:String = parameter["type"] as! String
//                let parameterAlias:String = parameter["alias"] as! String
//                let parameterRemark:String = parameter["remark"] as! String
//                let typeValue = typeValueCode(parameterType)
                modelCode += "\t\t\(parameterName) = aDecoder.decodeObjectForKey(\"\(parameterName)\") as! \(parameterType)\n"
                
            }
            modelCode += "\t}\n"
            
            modelCode += "}\n"
            body += modelCode
        }
        code += body
        
        
        codeTextView.string = code
    }
}
