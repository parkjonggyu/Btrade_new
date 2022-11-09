//
//  VCSignupText.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/12.
//

import Foundation
import UIKit

class VCSignupText:VCBase, SpinnerSelectorInterface{
    
 
    var TITLE: String?
    var DETAIL: String?
    
    @IBOutlet weak var mDetailText: UILabel!
    @IBOutlet weak var mTitleText: UILabel!
    @IBOutlet weak var dateLayout: UIView!
    @IBOutlet weak var dateText: UILabel!
    
    var mArray1 = Array<String>()
    var mArray2 = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(TITLE == nil || DETAIL == nil){
            goBack()
            return
        }
        initLayout()
        mTitleText.text = TITLE!
        getData()
    }
    
    fileprivate func initLayout(){
        dateLayout.layer.cornerRadius = 10
        dateLayout.layer.borderWidth = 1
        dateLayout.layer.borderColor = UIColor(named: "C707070")?.cgColor
        
        dateText.isUserInteractionEnabled = true
        dateText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onClicked)))
    }
    
    @objc func onClicked(sender:UITapGestureRecognizer){
        if mArray1.count == 0{
            return
        }
        var data = Array<KycVo.SMAP>()
        let size = mArray1.count
        for idx in 0 ..< size{
            data.append(KycVo.SMAP(key: mArray1[idx], value: mArray2[idx]))
        }
        SpinnerSelector(self, dateLayout, data, 0, positionY: "UP").start()
    }
    
    func onSelect(_ item: KycVo.SMAP, _ CATE: Int) {
        dateText.text = item.key
        setDetail(item.value)
    }
    
    fileprivate func setDetail(_ contents:String){
        let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)!
        mDetailText.attributedText = contents.htmlEscaped(font: font, colorHex: "#515251", lineSpacing: 1.5)
    }
    
    fileprivate func initData(){
        dateText.text = mArray1[0]
        setDetail(mArray2[0])
    }
    
    fileprivate func getData(){
        let request = TermsInfoRequest()
        request.bc_channel = DETAIL!
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? TermsInfoRequest{
            let data = TermsInfoResponse(baseResponce: response)
            
            if let array = data.getArray(){
                for item in array{
                    if let data = item as? NSDictionary{
                        if let conetnts = data["bc_contents"] as? String , let date = data["date"] as? String {
                            mArray1.append(date)
                            mArray2.append(conetnts)
                        }
                    }
                }
            }
            
            if mArray1.count > 0{
                DispatchQueue.main.async{
                    self.initData()
                }
                return
            }
            
            showErrorDialog("데이터를 받지 못했습니다.")
        }
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        goBack()
    }
    
    fileprivate func goBack(){
        self.navigationController?.popViewController(animated: true)
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
