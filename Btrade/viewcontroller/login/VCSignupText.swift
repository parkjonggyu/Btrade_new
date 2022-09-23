//
//  VCSignupText.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/12.
//

import Foundation
import UIKit

class VCSignupText:VCBase{
 
    var TITLE: String?
    var DETAIL: String?
    
    @IBOutlet weak var mDetailText: UILabel!
    @IBOutlet weak var mTitleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(TITLE == nil || DETAIL == nil){
            goBack()
            return
        }
        
        mTitleText.text = TITLE!
        getData()
    }
    
    func getData(){
        let request = TermsInfoRequest()
        request.bc_channel = DETAIL!
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? TermsInfoRequest{
            let data = TermsInfoResponse(baseResponce: response)
            if let html = data.getFirstData(){
                let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)!
                mDetailText.attributedText = html.htmlEscaped(font: font, colorHex: "#515251", lineSpacing: 1.5)
                return
            }
            
            showErrorDialog("아이디 혹은 패스워드가 잘못되었습니다.")
        }
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        goBack()
    }
    
    func goBack(){
        func prePage(){
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is VCLogin {
                    _ = self.navigationController?.popToViewController(vc as! VCLogin, animated: true)
                    return
                }
            }
            self.navigationController?.dismiss(animated: true)
        }
    }
}

extension String {
    func htmlEscaped(font: UIFont, colorHex: String, lineSpacing: CGFloat) -> NSAttributedString {
        let style = """
                    <style>
                    p.normal {
                      line-height: \(lineSpacing);
                      font-size: \(font.pointSize)px;
                      font-family: \(font.familyName);
                      color: \(colorHex);
                    }
                    </style>
        """
        let modified = String(format:"\(style)<p class=normal>%@</p>", self)
        do {
            guard let data = modified.data(using: .unicode) else {
                return NSAttributedString(string: self)
            }
            let attributed = try NSAttributedString(data: data,
                                                    options: [.documentType: NSAttributedString.DocumentType.html],
                                                    documentAttributes: nil)
            return attributed
        } catch {
            return NSAttributedString(string: self)
        }
    }
}
