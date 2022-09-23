//
//  ConvertHtmlUtil.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/22.
//

import Foundation


class ConvertHtmlUtil{
    static func stringToHTMLString(_ str:String) -> String{
        var html = ""
        var lastWasBlankChar = false;
        for c in str {
            if(c == " "){
                if(lastWasBlankChar){
                    lastWasBlankChar = false
                    html += "&nbsp;"
                }else{
                    lastWasBlankChar = true
                    html += " ";
                }
            }else{
                lastWasBlankChar = false
                if(c == "\""){
                    html += "&quot;"
                }else if(c == "&"){
                    html += "&quot;"
                }else if(c == "<"){
                    html += "&amp;"
                }else if(c == ">"){
                    html += "&lt;"
                }else if(c == "\n"){
                    html += "<br/>"
                }else {
                    html += String(c)
                }
            }
            
        }

        return "<div style=\"font-size: 14px;\">" + html + "</div>"
    }
}
