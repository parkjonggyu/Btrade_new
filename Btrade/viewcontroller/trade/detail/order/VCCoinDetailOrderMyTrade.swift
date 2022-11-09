//
//  VCCoinDetailOrderMyTrade.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/02.
//

import Foundation
import UIKit
class VCCoinDetailOrderMyTrade: VCBase{
    let SIZE = 20.0
    
    var emptyText:UILabel = {
       var label = UILabel()
        label.text = "미체결 내역이 없습니다."
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let HISTORY = "contract"
    let CONTRACT = "pending"
    var MAINCATEGORY:String = ""
    var SUBCATEGORY:Int = 0
    var mArray:Array<MyTradeItem> = Array<MyTradeItem>()
    var pageNo = 0
    
    @IBOutlet weak var historyText: UILabel!
    @IBOutlet weak var contractText: UILabel!
    @IBOutlet weak var optionText: UILabel!
    @IBOutlet weak var tableViewLayout: UIView!
    @IBOutlet weak var mList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initLayout()
    }
    
    fileprivate func initLayout(){
        MAINCATEGORY = CONTRACT
        SUBCATEGORY = 0

        contractText.isUserInteractionEnabled = true
        contractText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        historyText.isUserInteractionEnabled = true
        historyText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        optionText.isUserInteractionEnabled = true
        optionText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedOption)))
        
        contractText.layer.cornerRadius = 5
        contractText.layer.borderWidth = 1
        contractText.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        historyText.layer.cornerRadius = 5
        historyText.layer.borderWidth = 1
        historyText.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
        optionText.layer.cornerRadius = 5
        optionText.layer.borderWidth = 1
        
        emptyText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emptyText)
        emptyText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        emptyText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        emptyText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10).isActive = true
            
        
        self.mList.register(UINib(nibName: "MyTradeHistoryCell", bundle: nil), forCellReuseIdentifier: "MyTradeHistoryCell")
        self.mList.dataSource = self
        self.mList.delegate = self
        self.mList.separatorInset.left = 0
        
        drawLayoutTap()
    }
    
    fileprivate func drawLayoutTap(){
        contractText.clipsToBounds = true
        historyText.clipsToBounds = true
        optionText.clipsToBounds = true
        emptyText.text = ""
        SUBCATEGORY = 0
        pageNo = 1
        mArray.removeAll()
        if(MAINCATEGORY == CONTRACT){
            contractText.layer.borderColor = UIColor(named: "CoinSortActive")?.cgColor
            contractText.textColor = UIColor(named: "CoinSortActive")
            historyText.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
            historyText.textColor = UIColor(named: "C9499A8")
            optionText.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
            optionText.textColor = UIColor(named: "C9499A8")
            optionText.text = "전체선택"
            getList(pageNo, MAINCATEGORY)
        }else{
            contractText.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
            contractText.textColor = UIColor(named: "C9499A8")
            historyText.layer.borderColor = UIColor(named: "CoinSortActive")?.cgColor
            historyText.textColor = UIColor(named: "CoinSortActive")
            optionText.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
            optionText.textColor = UIColor(named: "C9499A8")
            optionText.text = "전체 ▼"
            getList(pageNo, MAINCATEGORY)
        }
    }
    
    fileprivate func drawLayoutOption(){
        optionText.clipsToBounds = true
        if(SUBCATEGORY == 0 && MAINCATEGORY == CONTRACT){
            optionText.layer.borderColor = UIColor(named: "C9499A8")?.cgColor
            optionText.textColor = UIColor(named: "C9499A8")
            optionText.text = "전체선택"
        }else if(SUBCATEGORY == 1 && MAINCATEGORY == CONTRACT){
            optionText.layer.borderColor = UIColor(named: "HogaPriceRed")?.cgColor
            optionText.textColor = UIColor(named: "HogaPriceRed")
            optionText.text = "선택해제"
        }
        DispatchQueue.main.async {
            self.mList.reloadData()
        }
    }
    
    
    @objc func selectedTab(sender:UITapGestureRecognizer){
        if(sender.view == contractText){
            if(MAINCATEGORY == CONTRACT){return}
            MAINCATEGORY = CONTRACT
            drawLayoutTap()
        }else if(sender.view == historyText){
            if(MAINCATEGORY == HISTORY){return}
            MAINCATEGORY = HISTORY
            drawLayoutTap()
        }
    }
    
    
    @objc func selectedOption(sender:UITapGestureRecognizer){
        if(sender.view == optionText){
            if(MAINCATEGORY == CONTRACT){
                if(SUBCATEGORY == 0){
                    SUBCATEGORY = 1
                    selectAll()
                }else{
                    SUBCATEGORY = 0
                    deleteItem()
                }
                drawLayoutOption()
            }else{
                startDropDown()
            }
        }
    }
    
    override func onResult(response: BaseResponse) {
        if let _ = response.request as? TradeHistoryRequest{
            let data = TradeHistoryResponse(baseResponce: response)
            if let list = data.getList() {
                for (_, item) in list.enumerated(){
                    let temp = MyTradeItem(data: item ,last:false)
                    if(MAINCATEGORY == HISTORY){
                        if let type = temp.getTrdType(){
                            if SUBCATEGORY == 1 && type != "B"{
                                continue
                            }
                            if SUBCATEGORY == 2 && type != "S"{
                                continue
                            }
                        }
                    }
                    mArray.append(temp)
                }
            }
            setList(data)
        }
        
        DispatchQueue.main.async{
            if let request = response.request as? OrderRequest{
                let response = OrderResponse(baseResponce: response)
                if let status = response.getStatus(){
                    if(status == "201"){
                        // 거래비밀번호 등록 팝업 - 삭제됨
                        return
                    }else if(status == "202"){
                        // 거래비밀번호 등록 팝업 - 삭제됨
                        return
                    }else if(status == "203"){
                        // 거래비밀번호 4회 틀림 찾기 팝업 - 삭제됨
                        return
                    }else if(status == "204"){
                        // 거래비밀번호 저장 팝업 - 삭제됨
                        return
                    }else if(status == "205"){
                        // 거래비밀번호 잠금 팝업 - 삭제됨
                        return
                    }else if(status == "206"){
                        DialogUtils().makeDialog(
                        uiVC: self,
                        title: "고객확인제도",
                        message:"고객확인 인증 절차를 완료한 후, 모든 거래서비스, 입출금 이용이 가능합니다.",
                        BtradeAlertAction(title: "고객확인제도 인증", style: .default) { (action) in
                            self.appInfo.isKycVisible = true
                            UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
                        },
                        BtradeAlertAction(title: "다음에 하기", style: .destructive) { (action) in
                        })
                        return
                    }else if(status == "0001" || status == "0003" || status == "0006"){
                        if let message = response.getMessage(){// 주문 수량, 주문 가격 , 최소 주문 수량 오류
                            self.showErrorDialog(message)
                        }
                        return
                    }else if(status == "9999"){// 마켓코드 미기입 오류
                        if let message = response.getMessage(){
                            self.showErrorDialog(message)
                        }
                        return
                    }else if(status == "0009"){
                        self.showErrorDialog("처리 진행중인 주문이 있습니다. 잠시 후 다시 시도해 주세요.")
                        return
                    }else if(status == "0000"){
                        self.deleteOK(request.deleteIdx)
                        return
                    }
                }
            }
        }
    }
    
    fileprivate func deleteOK(_ idx:Int?){
        if let i = idx{
            print("parent : " ,type(of: self.parent))
            
            if let vc = self.parent as? VCBase{
                vc.showToast("선택하신 주문이 취소되었습니다.")
            }
            mArray.remove(at: i)
            updateDeleteCheckBnt()
        }
    }
    
    fileprivate func updateDeleteCheckBnt(){
        SUBCATEGORY = 0
        if(mArray.count == 0){
            self.emptyText.text = "미체결 내역이 없습니다."
        }
        
        for (i, item) in mArray.enumerated(){
            if(mArray[i].delete){
                SUBCATEGORY = 1
                break
            }
        }
        
        drawLayoutOption()
    }
    
    fileprivate func setList(_ response:TradeHistoryResponse){
        DispatchQueue.main.async {
            if self.mArray.count == 0{
                if(self.MAINCATEGORY == self.CONTRACT){
                    self.emptyText.text = "미체결 내역이 없습니다."
                }else{
                    self.emptyText.text = "체결 내역이 없습니다."
                }
            }else{
                self.emptyText.text = ""
                self.pageNo = response.getpageNo() + 1
                if(response.getTotalCount() > 30){
                    if(self.pageNo <= response.getFinalPageNum()){
                        self.mArray[self.mArray.endIndex - 1].setLast(true)
                    }
                }
                self.mList.reloadData()
            }
        }
    }
    
    fileprivate func getList(_ pageNo:Int,_ what:String){
        self.mList.reloadData()
        let request = TradeHistoryRequest()
        request.page_num = pageNo
        request.market_code = VCCoinDetail.MARKETTYPE
        request.sortType = "desc"
        request.serviceType = what
        request.sortColumnName = "reg_date"
        request.coin_code = VCCoinDetail.coin?.coin_code
        ApiFactory(apiResult: self, request: request).newThread()
    }
}


//MARK: - Contract List
extension VCCoinDetailOrderMyTrade{
    fileprivate func selectAll(){
        for (idx, item) in mArray.enumerated(){
            mArray[idx].setDelete(true)
        }
    }
    
    fileprivate func deleteItem(){
        for (idx, item) in mArray.enumerated(){
            mArray[idx].setDelete(false)
        }
    }
    
    fileprivate func setChecke(_ idx:Int){
        mArray[idx].setDelete(!mArray[idx].delete)
        updateDeleteCheckBnt()
    }
    fileprivate func setDelete(_ idx:Int){
        if let error = orderValidation(){
            if(error != ""){
                showErrorDialog(error)
                return
            }else{
                return
            }
        }
        
        if let item = mArray[idx] as? MyTradeItem{
            DialogUtils().makeDialog(
            uiVC: self,
            title: "주문 취소",
            message:"미체결 거래를 취소하시겠습니까?.",
            BtradeAlertAction(title: "확인", style: .default) { (action) in
                self.executeOrder(idx)
            },
            BtradeAlertAction(title: "취소", style: .destructive) { (action) in
            })
        }
    }
    
    
    fileprivate func orderValidation() -> String?{
        guard let _ = appInfo.getMemberInfo() else {
            UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
            return ""
        }
        
        let info = appInfo.getMemberInfo()!
        if let aml = info.aml_state{
            if aml == "N" || CoinUtils.getlevel(info) == 1 {
                DialogUtils().makeDialog(
                uiVC: self,
                title: "고객확인제도",
                message:"고객확인 인증 절차를 완료한 후, 모든 거래서비스, 입출금 이용이 가능합니다.",
                BtradeAlertAction(title: "고객확인제도 인증", style: .default) { (action) in
                    self.appInfo.isKycVisible = true
                    UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.dismiss(animated: true)
                },
                BtradeAlertAction(title: "다음에 하기", style: .destructive) { (action) in
                })
                return ""
            }
            
            if aml != "cc"{
                return "고객확인 인증을 진행중입니다."
            }
            
            return nil
        }
        
        return "오류가 발생했습니다."
    }
    
    fileprivate func executeOrder(_ idx:Int){
        if let item = mArray[idx] as? MyTradeItem{
            let request = OrderRequest()
            request.coin_code = VCCoinDetail.coin?.coin_code
            request.market_code = VCCoinDetail.MARKETTYPE
            request.trd_type = "C"
            request.tradePw = "1111".toBase64()
            request.trade_pw_check = "N"
            request.amtCancel = String(item.getCoinQty() ?? 0)
            request.org_ord_no = item.getOrdNo()
            request.deleteIdx = idx // 통신에 사용되진 않음.
            ApiFactory(apiResult: self, request: request).newThread()
        }
    }
}


//MARK: - History List
extension VCCoinDetailOrderMyTrade: SpinnerSelectorInterface{
    fileprivate func startDropDown(){
        var mArray = Array<KycVo.SMAP>()
        mArray.append(KycVo.SMAP(key: "전체", value: "0"));
        mArray.append(KycVo.SMAP(key: "매수", value: "1"));
        mArray.append(KycVo.SMAP(key: "매도", value: "2"));
        SpinnerSelector(self, optionText, mArray, 0, positionY: "UP").start()
    }
    
    func onSelect(_ item: KycVo.SMAP, _ CATE: Int) {
        optionText.text = item.key + " ▼"
        if(SUBCATEGORY == Int(item.value)!){return}
        SUBCATEGORY = Int(item.value)!
        pageNo = 1
        mArray.removeAll()
        getList(pageNo, MAINCATEGORY)
    }
}

//MARK: - TableView
extension VCCoinDetailOrderMyTrade: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTradeHistoryCell", for: indexPath) as? MyTradeHistoryCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        if var item = mArray[indexPath.row] as? MyTradeItem{
            if(item.last){
                mArray[indexPath.row].setLast(false)
                getList(pageNo, MAINCATEGORY)
            }
            
            if(MAINCATEGORY == CONTRACT){
                cell.typeOsdText.text = "미체결량"
                cell.leftLayoutWidth.constant = self.SIZE
            }else{
                cell.typeOsdText.text = "체결량"
                cell.leftLayoutWidth.constant = 0.1
            }
            
            if(item.delete){
                cell.checkBtn.image = UIImage(named: "mytrade_check_active")
                cell.deleteLayoutHeight.constant = self.SIZE
            }else{
                cell.checkBtn.image = UIImage(named: "mytrade_check_deactive")
                cell.deleteLayoutHeight.constant = 0.1
            }
            
            cell.setBtnDelegate(indexPath.row, self)
            
            cell.coinCodeText.text = ""
            if let c = item.getCoinCode(), let m = item.getMarketCode(){
                cell.coinCodeText.text = c + "/" + m
            }
            
            let type = item.getTrdType()
            if(type == "B"){
                cell.typeText.text = "매수"
                cell.typeText.textColor = UIColor(named: "HogaPriceRed")
            }else{
                cell.typeText.text = "매도"
                cell.typeText.textColor = UIColor(named: "HogaPriceBlue")
            }
            
            cell.dateText.text = ""
            if let v = item.getRegDate(){
                if let date = v.toDate(){
                    cell.dateText.text = date.toString()
                }
            }
            
            cell.coinPriceText.text = ""
            if let v = item.getCoinPrice(){
                cell.coinPriceText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(v)))
            }
            
            cell.volumeText.text = ""
            if let v = item.getCoinQty(){
                cell.volumeText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(v)))
            }
            
            
            cell.osdCoinText.text = ""
            if let v = item.getOsdCoinQty(){
                cell.osdCoinText.text = DoubleDecimalUtils.removeLastZero(CoinUtils.currency(DoubleDecimalUtils.withoutExp(v))) 
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "qnadetailvc") as? VCQnaDetail{
//            vc.bq_idx = String(mArray[indexPath.row].bq_idx)
//            if mArray[indexPath.row].bq_confirm == "Y"{
//                vc.isHidden = false
//            }else{
//                vc.isHidden = true
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//            return
//        }
        
    }
}


class MyTradeHistoryCell: UITableViewCell{
    @IBOutlet weak var leftLayoutWidth: NSLayoutConstraint!
    @IBOutlet weak var deleteLayoutHeight: NSLayoutConstraint!
    @IBOutlet weak var checkBtn: UIImageView!
    @IBOutlet weak var detetBtn: UIImageView!
    
    @IBOutlet weak var typeOsdText: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var coinCodeText: UILabel!
    @IBOutlet weak var coinPriceText: UILabel!
    @IBOutlet weak var volumeText: UILabel!
    @IBOutlet weak var osdCoinText: UILabel!
    
    var checkDelegate:DeleteDelegate?
    var DeleteDelegate:DeleteDelegate?
    
    func setBtnDelegate(_ idx:Int,_ delegate:DeleteDelegate){
        checkDelegate = delegate
        checkBtn.tag = idx
        checkBtn.isUserInteractionEnabled = true
        checkBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAndDeleteBtn)))
        
        DeleteDelegate = delegate
        detetBtn.tag = idx
        detetBtn.isUserInteractionEnabled = true
        detetBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAndDeleteBtn)))
    }
    
    @objc func selectAndDeleteBtn(sender:UITapGestureRecognizer){
        if(sender.view == checkBtn){
            if let i = sender.view?.tag{
                checkDelegate?.checkBntClick(i)
            }
        }
        if(sender.view == detetBtn){
            if let i = sender.view?.tag{
                checkDelegate?.deleteBntClick(i)
            }
        }
    }
}

extension VCCoinDetailOrderMyTrade:DeleteDelegate{
    func checkBntClick(_ idx:Int) {
        setChecke(idx)
    }
    func deleteBntClick(_ idx:Int) {
        setDelete(idx)
    }
}

protocol DeleteDelegate{
    func checkBntClick(_ idx:Int)
    func deleteBntClick(_ idx:Int)
}

struct MyTradeItem{
    var data:Dictionary<String, Any>
    var delete = false
    var last:Bool
    
    mutating func setLast(_ bool:Bool){
        last = bool
    }
    
    mutating func setDelete(_ bool:Bool){
        delete = bool
    }
    
    func getCoinCode() -> String?{
        let index = "coin_code"
        if let a = data[index] as? String{
            return a
        }
        return nil
    }
    
    func getMarketCode() -> String?{
        let index = "market_code"
        if let a = data[index] as? String{
            return a
        }
        return nil
    }
    
    func getTrdType() -> String?{
        let index = "trd_type"
        if let a = data[index] as? String{
            return a
        }
        return nil
    }
    
    func getCoinPrice() -> Double?{
        let index = "coin_price"
        if let b = data[index] as? Double{
            return b
        }
        if let a = data[index] as? Int64{
            return Double(a)
        }
        return nil
    }
    
    func getCoinQty() -> Double?{
        let index = "coin_qty"
        if let b = data[index] as? Double{
            return b
        }
        if let a = data[index] as? Int64{
            return Double(a)
        }
        return nil
    }
    
    func getOsdCoinQty() -> Double?{
        if let b = data["osd_coin_qty"] as? Double{
            return b
        }
        if let a = data["ccs_coin_qty"] as? Double{
            return a
        }
        if let b = data["osd_coin_qty"] as? Int64{
            return Double(b)
        }
        if let a = data["ccs_coin_qty"] as? Int64{
            return Double(a)
        }
        return nil
    }
    
    func getOrdNo() -> String?{
        let index = "ord_no"
        if let a = data[index] as? String{
            return a
        }
        return nil
    }
    
    func getRegDate() -> String?{
        let index = "reg_date"
        if let a = data[index] as? String{
            return a
        }
        return nil
    }
}

extension String {
    fileprivate func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    fileprivate func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension Date {
    fileprivate func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
