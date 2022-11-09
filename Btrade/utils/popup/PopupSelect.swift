//
//  PopupDate.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/12.
//

import Foundation
import UIKit
import DropDown

class PopupSelect:UIViewController , SpinnerSelectorInterface{
    
    var mTitle:String?
    var mSpinner1:Array<KycVo.SMAP>?
    var selectSpinner1Data:KycVo.SMAP?
    var mSpinner2:Array<KycVo.SMAP>?
    var selectSpinner2Data:KycVo.SMAP?
    var startDate:Date?
    var endDate:Date?
    var selectDateBtn = "직접입력"
    
    var okListener:(([String:String]) -> ())?
    
    @IBOutlet weak var popupLayout: UIView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var selectSpinner1: UIView!
    @IBOutlet weak var selectSpinner1Text: UILabel!
    
    @IBOutlet weak var selectSpinner2: UIView!
    @IBOutlet weak var selectSpinner2Text: UILabel!
    
    @IBOutlet weak var dateBtnLayout: UIStackView!
    @IBOutlet weak var dateBtn1: UILabel!
    @IBOutlet weak var dateBtn2: UILabel!
    @IBOutlet weak var dateBtn3: UILabel!
    @IBOutlet weak var dateBtn4: UILabel!
    @IBOutlet weak var dateBtn5: UILabel!
    
    @IBOutlet weak var dateSpinner1: UIView!
    @IBOutlet weak var dateSpinner1Text: UILabel!
    @IBOutlet weak var dateSpinner2: UIView!
    @IBOutlet weak var dateSpinner2Text: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    var assetDelegate:((String, String, Date, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(startDate == nil){startDate = Date()}
        if(endDate == nil){endDate = Date()}
        setLayout()
        setValue()
    }
    
    fileprivate func setValue(){
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        titleText.text = mTitle ?? "검색 조건"
        
        selectSpinner1Text.text = ""
        if let s = mSpinner1{
            selectSpinner1Data = s[0]
            selectSpinner1Text.text = s[0].key
            selectSpinner1.isUserInteractionEnabled = true
            selectSpinner1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        }
        
        selectSpinner2Text.text = ""
        if let s = mSpinner2{
            selectSpinner2Data = s[0]
            selectSpinner2Text.text = s[0].key
            selectSpinner2.isUserInteractionEnabled = true
            selectSpinner2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        }
        
        dateBtn1.isUserInteractionEnabled = true
        dateBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        dateBtn2.isUserInteractionEnabled = true
        dateBtn2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        dateBtn3.isUserInteractionEnabled = true
        dateBtn3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        dateBtn4.isUserInteractionEnabled = true
        dateBtn4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        dateBtn5.isUserInteractionEnabled = true
        dateBtn5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        
        dateSpinner1Text.text = ""
        dateSpinner2Text.text = ""
        
        setDate()
        
        
        dateSpinner1.isUserInteractionEnabled = true
        dateSpinner1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        dateSpinner2.isUserInteractionEnabled = true
        dateSpinner2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        
        okBtn.isUserInteractionEnabled = true
        okBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goNext)))
    }
    
    @objc func selectedTab(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            self.dismiss(animated: true)
        }else if(sender.view == selectSpinner1){
            startDropDown(selectSpinner1, mSpinner1!, 0)
        }else if(sender.view == selectSpinner2){
            startDropDown(selectSpinner2, mSpinner2!, 1)
        }else if(sender.view == dateBtn1){
            calcDate(dateBtn1)
            dateBtnSelect(dateBtn1)
        }else if(sender.view == dateBtn2){
            calcDate(dateBtn2)
            dateBtnSelect(dateBtn2)
        }else if(sender.view == dateBtn3){
            calcDate(dateBtn3)
            dateBtnSelect(dateBtn3)
        }else if(sender.view == dateBtn4){
            calcDate(dateBtn4)
            dateBtnSelect(dateBtn4)
        }else if(sender.view == dateBtn5){
            calcDate(dateBtn5)
            dateBtnSelect(dateBtn5)
        }else if(sender.view == dateSpinner1){
            if(dateBtn5.text! == selectDateBtn){
                showDatePopup(1)
            }
        }else if(sender.view == dateSpinner2){
            if(dateBtn5.text! == selectDateBtn){
                showDatePopup(2)
            }
        }
    }
    
    fileprivate func calcDate(_ btn:UILabel){
        endDate = Date()
        if(btn == dateBtn1){
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate!)
        }else if(btn == dateBtn2){
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate!)
        }else if(btn == dateBtn3){
            startDate = Calendar.current.date(byAdding: .month, value: -3, to: endDate!)
        }else if(btn == dateBtn4){
            startDate = Calendar.current.date(byAdding: .month, value: -6, to: endDate!)
        }else if(btn == dateBtn5){
            startDate = Date()
        }
        
        setDate()
    }
    
    fileprivate func setDate(){
        if let date = startDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            dateSpinner1Text.text = formatter.string(from: date)
        }
        
        if let date = endDate{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            dateSpinner2Text.text = formatter.string(from: date)
        }
    }
    
    fileprivate func startDropDown(_ textField: AnchorView,_ array:Array<KycVo.SMAP>,_ WHERE:Int){
        SpinnerSelector(self, textField, array, WHERE, positionY: "UP").start()
    }
    
    func onSelect(_ item: KycVo.SMAP, _ CATE: Int) {
        if(CATE == 0){
            selectSpinner1Data = item
            selectSpinner1Text.text = item.key
        }else{
            selectSpinner2Data = item
            selectSpinner2Text.text = item.key
        }
    }
    @objc func goNext(_ sender: Any) {
        self.dismiss(animated: true){ [self] in
            if let c = self.assetDelegate{
                c(self.selectSpinner1Data?.value ?? "all" , self.selectSpinner2Data?.value ?? "all" , self.startDate!, self.endDate!)
            }
        }
    }
    
    fileprivate func showDatePopup(_ WHERE:Int){
        let sb = UIStoryboard.init(name:"Popup", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "PopupDate") as? PopupDate else {
            return
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        if(WHERE == 1){
            vc.delegate = {[weak self] date in
                self?.startDate = date
                self?.setDate()
            }
        }else{
            vc.delegate = {[weak self] date in
                self?.endDate = date
                self?.setDate()
            }
        }
        
        self.present(vc, animated: true);
    }
    
    fileprivate func dateBtnSelect(_ btn:UILabel){
        dateBtnInit()
        activeDateBtn(btn)
    }
    
    fileprivate func setLayout(){
        popupLayout.clipsToBounds = true
        popupLayout.layer.cornerRadius = 30
        popupLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        
        selectSpinner1.layer.cornerRadius = 5
        selectSpinner1.layer.borderWidth = 1
        selectSpinner1.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        selectSpinner2.layer.cornerRadius = 5
        selectSpinner2.layer.borderWidth = 1
        selectSpinner2.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        dateSpinner1.layer.cornerRadius = 5
        dateSpinner1.layer.borderWidth = 1
        dateSpinner1.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        dateSpinner2.layer.cornerRadius = 5
        dateSpinner2.layer.borderWidth = 1
        dateSpinner2.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        
        dateBtn1.clipsToBounds = true
        dateBtn5.clipsToBounds = true
        
        dateBtn1.layer.cornerRadius = 5
        dateBtn1.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        
        
        dateBtn5.layer.cornerRadius = 5
        
        dateBtn5.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
        
        dateBtnInit()
        activeDateBtn(dateBtn5)
    }
    
    fileprivate func activeDateBtn(_ btn:UILabel){
        selectDateBtn = btn.text!
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "CoinSortActive")?.cgColor
        btn.textColor = UIColor(named: "CoinSortActive")
    }
    
    
    fileprivate func dateBtnInit(){
        
        dateBtn1.layer.borderWidth = 1
        dateBtn1.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        dateBtn1.textColor = UIColor(named: "C707070")
        
        dateBtn2.layer.borderWidth = 1
        dateBtn2.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        dateBtn2.textColor = UIColor(named: "C707070")
        
        dateBtn3.layer.borderWidth = 1
        dateBtn3.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        dateBtn3.textColor = UIColor(named: "C707070")
        
        dateBtn4.layer.borderWidth = 1
        dateBtn4.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        dateBtn4.textColor = UIColor(named: "C707070")
        
        dateBtn5.layer.borderWidth = 1
        dateBtn5.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
        dateBtn5.textColor = UIColor(named: "C707070")
    }
}
