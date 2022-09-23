//
//  VCSecurityCerti.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/24.
//

import Foundation
import Alamofire


class VCSecurityCerti: VCBase {
    
    var allList:Array<SecurityCertiItem> = Array<SecurityCertiItem>()
    var refresh:(() -> Void)?
    
    @IBOutlet weak var stepImage: UIImageView!
    
    @IBOutlet weak var nickNameText: UILabel!
    
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var roundLayout: UIView!
    @IBOutlet weak var tradeText: UILabel!
    @IBOutlet weak var depositText: UILabel!
    
    @IBOutlet weak var optionLayout: UIView!
    
    @IBOutlet weak var optionText1: UILabel!
    @IBOutlet weak var optionText2: UILabel!
    @IBOutlet weak var optionText3: UILabel!
    
    @IBOutlet weak var loginBorder1: UIView!
    @IBOutlet weak var loginBorder2: UIView!
    @IBOutlet weak var loginBorder3: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionLayout.layer.borderWidth = 2
        optionLayout.layer.borderColor = UIColor.gray.cgColor
        optionLayout.layer.cornerRadius = 10
        
        
        loginBorder1.layer.borderWidth = 2
        loginBorder1.layer.borderColor = UIColor.gray.cgColor
        loginBorder2.layer.borderWidth = 2
        loginBorder2.layer.borderColor = UIColor.gray.cgColor
        loginBorder3.layer.borderWidth = 2
        loginBorder3.layer.borderColor = UIColor.gray.cgColor
        
        
        roundLayout.layer.cornerRadius = roundLayout.frame.height / 2
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.stop1)))
        
        optionLayout.isUserInteractionEnabled = true
        optionLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedOption)))
     
        if appInfo.getMemberInfo() == nil{
            stop()
            return
        }
        
        checkLevel()
        
        ApiFactory(apiResult: LoginHistory(self), request: LoginHistoryRequest()).netThread()
    }
    
    class LoginHistory:ApiResult{
        weak var parent: VCSecurityCerti! = nil
        
        init(_ a: VCSecurityCerti) {
            self.parent = a
        }
        
        func onResult(response: BaseResponse) {
            if let _ = response.request as? LoginHistoryRequest{
                let data = LoginHistoryResponse(baseResponce: response)
                let list = data.getHistoryList()
                if(list != nil){
                    for item in list!{
                        let item = SecurityCertiItem(reg_date: item["reg_date"] as? String ?? "", agent_ip: item["agent_ip"] as? String ?? "", agent_location: item["agent_location"] as? String ?? "", agent_type: item["agent_type"] as? String ?? "", agent_browser: item["agent_browser"] as? String ?? "")
                        print(item)
                        self.parent.allList.append(item)
                    }
                    
                    let nibName = UINib(nibName: "SecurityCertiCell", bundle: nil)
                    self.parent.tableView.register(nibName, forCellReuseIdentifier: "securitycerticell")
                    self.parent.tableView.rowHeight = UITableView.automaticDimension
                    self.parent.tableView.estimatedRowHeight = 120
                    self.parent.tableView.dataSource = self.parent
                    self.parent.tableView.delegate = self.parent
                    self.parent.tableView.separatorInset.left = 0
                    
                }
            }
        }
        
        func onError(e: AFError, method: String) {}
    }
    
    fileprivate func checkLevel(){
        if let nick = appInfo.getMemberInfo()?.nick_name{
            nickNameText.text = nick
        }else{
            nickNameText.text = "회원"
        }
        
        let level = CoinUtils.getlevel(appInfo.getMemberInfo()!);
        if level == 1{
            stepImage.image = UIImage(named: "certi_icon_1.png")
            optionText1.text = "고객확인 인증을 완료하고"
            optionText2.text = "코인 거래와 입출금 이용"
            optionText3.text = "을 시작하세요."
        }else if level == 2{
            stepImage.image = UIImage(named: "certi_icon_2.png")
            optionText1.text = "OPT 인증을 완료하면"
            optionText2.text = "출금 서비스"
            optionText3.text = "를 이용할 수 있어요."
            tradeText.text = "가능"
            tradeText.textColor = hexStringToUIColor(hex: "#314A9B")
        }else{
            stepImage.image = UIImage(named: "certi_icon_3.png")
            optionText1.text = "고객확인 인증이 완료되어"
            optionText2.text = "모든 서비스"
            optionText3.text = "를 이용할 수 있어요."
            tradeText.text = "가능"
            depositText.text = "가능"
            tradeText.textColor = hexStringToUIColor(hex: "#314A9B")
            depositText.textColor = hexStringToUIColor(hex: "#314A9B")
        }
    }
    
    @objc func clickedOption(sender:UITapGestureRecognizer){
        let level = CoinUtils.getlevel(appInfo.getMemberInfo()!);
        if level == 1{
            goOTP()//goKYC()
        }else if level == 2{
            goOTP()
        }
    }
    
    @objc func stop1(sender:UITapGestureRecognizer){
        stop()
    }
    
    fileprivate func stop(){
        self.dismiss(animated: true)
    }
    
    func goKYC(){
        let sb = UIStoryboard.init(name:"Kyc", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "kycnavivc") as? UINavigationController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    func goOTP(){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "otpregistervc") as? VCOtpRegister else {
            return
        }
        vc.finish = {() -> Void in
            self.stop()
            if let r = self.refresh{r()}
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true);
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension VCSecurityCerti: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "securitycerticell", for: indexPath) as? SecurityCertiCell else {
            return UITableViewCell()
        }
        let item = allList[indexPath.row]
        
        cell.viewLayout1.layer.borderWidth = 1
        cell.viewLayout1.layer.borderColor = UIColor.gray.cgColor
        cell.viewLayout2.layer.borderWidth = 1
        cell.viewLayout2.layer.borderColor = UIColor.gray.cgColor
        cell.viewLayout3.layer.borderWidth = 1
        cell.viewLayout3.layer.borderColor = UIColor.gray.cgColor
        
        if item.reg_date == "" {
            cell.dateText.text = ""
            cell.timeText.text = ""
        }else{
            let datetime = item.reg_date.components(separatedBy: "<br>")
            if datetime.count == 2{
                cell.dateText.text = datetime[0]
                cell.timeText.text = datetime[1]
            }else{
                cell.dateText.text = ""
                cell.timeText.text = ""
            }
        }
        
        cell.ipText.text = item.agent_ip
        cell.locationText.text = item.agent_location
        cell.pmText.text = item.agent_type
        cell.osText.text = item.agent_browser
        
        return cell
    }
}

class SecurityCertiCell: UITableViewCell{
    @IBOutlet weak var viewLayout1: UIView!
    @IBOutlet weak var viewLayout2: UIView!
    @IBOutlet weak var viewLayout3: UIView!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var ipText: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var pmText: UILabel!
    @IBOutlet weak var osText: UILabel!
}

struct SecurityCertiItem{
    var reg_date:String
    var agent_ip:String
    var agent_location:String
    var agent_type:String
    var agent_browser:String
    
}
