//
//  KycVo.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/08/02.
//

import Foundation

struct KycVo{
    struct SMAP{
        var key:String
        var value:String
        var temp:String?
        
        init(key:String, value:String, temp:String? = nil){
            self.key = key
            self.value = value
            self.temp = temp
        }
    }
    
    func makeJob() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "직장인", value: "1"))
        data.append(SMAP(key: "개인사업자", value: "2"))
        data.append(SMAP(key: "무직", value: "3"))
        data.append(SMAP(key: "학생", value: "4"))
        data.append(SMAP(key: "전업주부", value: "5"))
        return data
    }
    
    func makeJob2() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "도매 및 소매업", value: "03"))
        data.append(SMAP(key: "제조 및 건설업", value: "02"))
        data.append(SMAP(key: "숙박 및 음식점업", value: "05"))
        data.append(SMAP(key: "운수 및 창고업", value: "04"))
        data.append(SMAP(key: "농업/임업/어업/광업", value: "01"))
        data.append(SMAP(key: "공공/국방/사회보장 행정", value: "06"))
        data.append(SMAP(key: "공무원", value: "17"))
        data.append(SMAP(key: "부동산업", value: "07"))
        data.append(SMAP(key: "편의점", value: "09"))
        data.append(SMAP(key: "인터넷 쇼핑몰", value: "10"))
        data.append(SMAP(key: "무역업", value: "11"))
        data.append(SMAP(key: "금융투자업", value: "14"))
        data.append(SMAP(key: "신탁업", value: "24"))
        data.append(SMAP(key: "청취/고위관리/경영", value: "08"))
        data.append(SMAP(key: "의료 전문직", value: "16"))
        data.append(SMAP(key: "세무사/회계사/변호사/비의료 전문직", value: "15"))
        data.append(SMAP(key: "보건 및 사회복지 서비스업", value: "13"))
        data.append(SMAP(key: "비영리 단체 및 종교단체", value: "12"))
        data.append(SMAP(key: "카지노", value: "19"))
        data.append(SMAP(key: "대부업", value: "20"))
        data.append(SMAP(key: "환전영업", value: "21"))
        data.append(SMAP(key: "소액해외송금업", value: "22"))
        data.append(SMAP(key: "귀금속판매", value: "23"))
        data.append(SMAP(key: "가상자산사업", value: "25"))
        return data
    }
    
    func makeJob3() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "도매 및 소매업", value: "12"))
        data.append(SMAP(key: "제조 및 건설업", value: "11"))
        data.append(SMAP(key: "숙박 및 음식점업", value: "14"))
        data.append(SMAP(key: "정보통신업", value: "15"))
        data.append(SMAP(key: "투자중개 및 자문", value: "08"))
        data.append(SMAP(key: "신탁", value: "09"))
        data.append(SMAP(key: "금융 및 보험업", value: "16"))
        data.append(SMAP(key: "부동산업", value: "17"))
        data.append(SMAP(key: "법률 및 회계", value: "06"))
        data.append(SMAP(key: "의료", value: "07"))
        data.append(SMAP(key: "농업/임업/어업/광업", value: "10"))
        data.append(SMAP(key: "운수 및 창고업", value: "13"))
        data.append(SMAP(key: "전문 과학 및 기술 서비스업", value: "18"))
        data.append(SMAP(key: "사업시설 관리 사업 지원 및 임대 서비스업", value: "19"))
        data.append(SMAP(key: "공공/국방/사회보장 행정", value: "20"))
        data.append(SMAP(key: "교육 서비스업", value: "21"))
        data.append(SMAP(key: "보건 및 사회복지 서비스업", value: "22"))
        data.append(SMAP(key: "카지노", value: "01"))
        data.append(SMAP(key: "대부업/전당포", value: "02"))
        data.append(SMAP(key: "환전영업/소액해외송금업", value: "03"))
        data.append(SMAP(key: "귀금속", value: "04"))
        data.append(SMAP(key: "가상자산사업자", value: "05"))
        return data
    }
    
    func makePorpose() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "가상자산 투자", value: "01"))
        data.append(SMAP(key: "가상자산 보관/송금/교환", value: "02"))
        return data
    }
    
    func makeSource() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "근로 및 연금소득", value: "01"))
        data.append(SMAP(key: "퇴직소득", value: "02"))
        data.append(SMAP(key: "대출금", value: "03"))
        data.append(SMAP(key: "용돈/생활비", value: "04"))
        data.append(SMAP(key: "상속/증여", value: "05"))
        data.append(SMAP(key: "일시 재산양도로 인한 소득", value: "06"))
        data.append(SMAP(key: "사업소득", value: "51"))
        data.append(SMAP(key: "부동산임대소득", value: "52"))
        data.append(SMAP(key: "부동산양도소득", value: "53"))
        data.append(SMAP(key: "금융소득(이자 및 배당)", value: "54"))
        data.append(SMAP(key: "가상자산, 유가증권 등 투자자산처분", value: "56"))
        return data
    }
    
    func makeBank() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "산업", value: "002"))
        data.append(SMAP(key: "기업", value: "003"))
        data.append(SMAP(key: "국민", value: "004"))
        data.append(SMAP(key: "외환", value: "081"))
        data.append(SMAP(key: "수협", value: "007"))
        data.append(SMAP(key: "농협", value: "010"))
        data.append(SMAP(key: "우리", value: "020"))
        data.append(SMAP(key: "SC제일", value: "023"))
        data.append(SMAP(key: "하나", value: "005"))
        data.append(SMAP(key: "한국씨티", value: "027"))
        data.append(SMAP(key: "대구", value: "031"))
        data.append(SMAP(key: "부산", value: "032"))
        data.append(SMAP(key: "광주", value: "034"))
        data.append(SMAP(key: "제주", value: "035"))
        data.append(SMAP(key: "전북", value: "037"))
        data.append(SMAP(key: "경남", value: "039"))
        data.append(SMAP(key: "새마을금고", value: "045"))
        data.append(SMAP(key: "신협", value: "048"))
        data.append(SMAP(key: "우체국", value: "071"))
        return data
    }
    
    func makeQna() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "◉ 보이스피싱 등 사고 접수 관련", value: "CA01"))
        data.append(SMAP(key: "◉ 회원가입/탈퇴/로그인 등 계정 관련", value: "CA02"))
        data.append(SMAP(key: "◉ 입출금 및 거래 관련", value: "CA03"))
        data.append(SMAP(key: "◉ 레벨 및 정보 변경 관련", value: "CA04"))
        data.append(SMAP(key: "◉ 홈페이지 관련 문의", value: "CA05"))
        data.append(SMAP(key: "◉ 기타 문의", value: "CA06"))
        return data
    }
}
