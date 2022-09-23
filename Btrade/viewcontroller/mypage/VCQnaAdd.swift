//
//  VCQnaAdd.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/23.
//

import Foundation
import Alamofire


class VCQnaAdd: VCBase , UITextViewDelegate{
    
    var bq_idx:String = ""
    
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var bodyText: UITextView!
    @IBOutlet weak var bodyTextSize: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bq_idx == "" {
            stop()
            return
        }
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
     
        bodyText.delegate = self
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
        
        let request = MypageQNAAddRequest()
        request.bq_idx = bq_idx
        request.bq_contents = ConvertHtmlUtil.stringToHTMLString(bodyText.text!)
        ApiFactory(apiResult: self, request: request).netThread()
    }
    
    
    override func onResult(response: BaseResponse) {
        
        if let _ = response.request as? MypageQNAAddRequest{
            DispatchQueue.main.async{
                let data = MypageQNAAddResponse(baseResponce: response)
                if let code = data.getCode() {
                    if(code == "200"){
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
        if bodyText.text! == "" {
            return "문의 내용을 입력해 주세요."
        }
        
        return nil
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

