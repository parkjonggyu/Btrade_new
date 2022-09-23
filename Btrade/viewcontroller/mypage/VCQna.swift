//
//  VCQna.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/19.
//

import Foundation
import Alamofire


class VCQna: VCBase , SpinnerSelectorInterface, UITextViewDelegate{
    
    @IBOutlet weak var backBtn: UIImageView!
    
    @IBOutlet weak var bodyText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var categorySelectorText: UITextField!
    @IBOutlet weak var bodyTextSize: UILabel!
    
    var bq_category:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
     
        categorySelectorText.delegate = self
        bodyText.delegate = self
        titleText.delegate = self
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        stop()
    }
    
    fileprivate func stop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let error = error()
        if let msg = error{
            showErrorDialog(msg)
            return
        }
        
        let request = MypageQNARequest()
        request.bq_category = bq_category
        request.bq_title = titleText.text!
        request.bq_contents = ConvertHtmlUtil.stringToHTMLString(bodyText.text!)
        ApiFactory(apiResult: self, request: request).newThread()
    }
    
    override func onResult(response: BaseResponse) {
        
        if let _ = response.request as? MypageQNARequest{
            DispatchQueue.main.async{
                let data = MypageQNAResponse(baseResponce: response)
                if let status = data.getHttpStatus() {
                    if(status == "OK"){
                        self.showErrorDialog("문의해 주셔서 감사합니다. 가능한 빨리 답변을 드리겠습니다."){_ in
                            self.qnaRefresh()
                        }
                        return
                    }
                }
                self.showErrorDialog("문의하기에 실패했습니다. 다시 시도해 주세요.")
            }
        }
    }
    
    fileprivate func qnaRefresh(){
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if let view = vc as? VCQnaHistory{
                view.refresh = true
                _ = self.navigationController?.popToViewController(view, animated: true)
                return
            }
        }
        self.navigationController?.dismiss(animated: true)
    }
    
    fileprivate func error() -> String?{
        if bq_category == "" {
            return "문의 유형을 선택해 주세요."
        }
        
        if titleText.text! == "" {
            return "제목을 입력해 주세요."
        }
        
        if bodyText.text! == "" {
            return "문의 내용을 입력해 주세요."
        }
        
        return nil
    }
    
    func onSelect(_ item:KycVo.SMAP,_ CATE: Int) {
        categorySelectorText.text = item.key
        bq_category = item.value
    }
    
    fileprivate func calcBodyTextSize(){
        var size = 0
        size = bodyText.text?.count ?? 0
        bodyTextSize.text = "" + String(size) + "/200"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let id = textView.restorationIdentifier{
            if(id == "bodytext"){
                calcBodyTextSize()
                guard textView.text!.count < 200 else { return false }
            }
        }
        return true
    }
}



extension VCQna: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let id = textField.restorationIdentifier{
            if(id == "titletext"){
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if isBackSpace == -92 {
                        return true
                    }
                }
                guard textField.text!.count < 100 else { return false }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let id = textField.restorationIdentifier{
            if(id == "categoryselect"){
                startDropDown(textField, KycVo().makeQna(), 1)
                return
            }
            
            textField.background = UIImage(named: "text_field_active.png")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = textField.restorationIdentifier{
            textField.background = UIImage(named: "text_field_inactive.png")
        }
    }
    
    fileprivate func startDropDown(_ textField: UITextField,_ array:Array<KycVo.SMAP>,_ WHERE:Int){
        textField.endEditing(true)
        SpinnerSelector(self, textField, array, WHERE).start()
    }
}
