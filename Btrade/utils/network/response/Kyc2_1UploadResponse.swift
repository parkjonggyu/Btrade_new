//
//  Kyc2_1UploadResponse.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/07/29.
//

import Foundation

struct Kyc2_1UploadResponse{
    let baseResponce: BaseResponse
    
    func getMessage() -> String?{
        let index = "message"
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
    
    func getRnm_no_div() -> String?{
        let index = "rnm_no_div"
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
    
    func getFilePath() -> String?{
        let index = "filePath"
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
    
    func getRequestId() -> String?{
        let index = "requestId"
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
    
    func getPersonalNum_front() -> String?{
        let index = "personalNum_front"
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
    
    func getPersonalNum_back() -> String?{
        let index = "personalNum_back"
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
    
    func getIssueDate_year() -> String?{
        let index = "issueDate_year"
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
    
    func getIssueDate_month() -> String?{
        let index = "issueDate_month"
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
    
    func getIssueDate_day() -> String?{
        let index = "issueDate_day"
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
    
    func getNum() -> String?{
        let index = "num"
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
    
    func getCode() -> String?{
        let index = "code"
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
}
