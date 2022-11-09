//
//  MemberInfoResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/08.
//

import Foundation

struct MemberInfoResponse{
    let baseResponce: BaseResponse
    
    func getState() -> String?{
        if let modelAndView = baseResponce.data["data"] as? NSDictionary{
            if let state = modelAndView["state"]{
                return state as? String
            }
            if let c = modelAndView["state"] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getCertify_email() -> String?{
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let state = modelAndView["certify_email"]{
                return state as? String
            }
        }
        return nil
    }
    
    func getAml_state() -> String?{
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let state = modelAndView["aml_state"]{
                return state as? String
            }
        }
        return nil
    }
    
    func getCertify_otp() -> String?{
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let state = modelAndView["certify_otp"]{
                return state as? String
            }
        }
        return nil
    }
    
    func getNick_name() -> String?{
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let state = modelAndView["nick_name"]{
                return state as? String
            }
        }
        return nil
    }
    
    func getCertify_nick_name() -> String?{
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let state = modelAndView["certify_nick_name"]{
                return state as? String
            }
        }
        return nil
    }
    
    func getId() -> String?{
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let state = modelAndView["id"]{
                return state as? String
            }
        }
        return nil
    }
    
    func getIdx() -> String?{
        let index = "idx"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getResult_Msg() -> String?{
        let index = "result_msg"
        if let modelAndView = baseResponce.data as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getPhone_no() -> String?{
        let index = "phone_no"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getFull_name() -> String?{
        let index = "full_name"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getBankno() -> String?{
        let index = "bankno"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getBankName() -> String?{
        let index = "bankname"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getMb_new_addr1() -> String?{
        let index = "mb_new_addr1"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getMb_new_addr2() -> String?{
        let index = "mb_new_addr2"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    func getWork_nm() -> String?{
        let index = "work_nm"
        if let modelAndView = baseResponce.data["result"] as? NSDictionary{
            if let code = modelAndView[index] as? String{
                return code
            }
            if let c = modelAndView[index] as? Int64{
                return String(c)
            }
        }
        return nil
    }
    
    
    func getObject() -> MemberInfo{
        let member:MemberInfo = MemberInfo()
        member.setData(res: self)
        return member
    }
    
}



class MemberInfo:Codable {
    var update:Bool? = false
    var mb_idx:String?
    var mb_id:String?
    var nick_name:String?
    var certify_nick_name:String?
    var full_name:String?
    var bankname:String?
    var bankno:String?
    var phone_no:String?
    var mb_new_addr1:String?
    var mb_new_addr2:String?
    var aml_state:String?
    var certify_otp:String?
    var certify_email:String?
    var work_nm:String?
    
    func setData(res:MemberInfoResponse){
        mb_idx = res.getIdx();
        mb_id = res.getId();
        nick_name = res.getNick_name()
        certify_nick_name = res.getNick_name()
        full_name = res.getFull_name()
        bankname = res.getBankName()
        bankno = res.getBankno()
        phone_no = res.getPhone_no()
        mb_new_addr1 = res.getMb_new_addr1()
        mb_new_addr2 = res.getMb_new_addr2()
        aml_state = res.getAml_state()
        certify_otp = res.getCertify_otp()
        certify_email = res.getCertify_email()
        work_nm = res.getWork_nm()
    }
}

