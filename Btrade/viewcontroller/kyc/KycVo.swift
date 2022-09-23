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
    }
    
    func makeJob() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "농림/축수산/광업 근로자", value: "01"))
        data.append(SMAP(key: "제조/건설/서비스업 근로자", value: "02"))
        data.append(SMAP(key: "개인사업자/자영업자", value: "03"))
        data.append(SMAP(key: "자유직/프리랜서", value: "04"))
        data.append(SMAP(key: "일반전문직", value: "05"))
        data.append(SMAP(key: "기타회사원", value: "06"))
        data.append(SMAP(key: "공무원", value: "07"))
        data.append(SMAP(key: "의료/법조/금융업 근로자", value: "08"))
        data.append(SMAP(key: "카지노/대부/귀금속/환전업 근로자", value: "09"))
        data.append(SMAP(key: "가상통화거래업 근로자", value: "10"))
        data.append(SMAP(key: "비금융전문직", value: "11"))
        data.append(SMAP(key: "종교인", value: "12"))
        data.append(SMAP(key: "군인", value: "13"))
        data.append(SMAP(key: "전업주부", value: "14"))
        data.append(SMAP(key: "무직", value: "15"))
        data.append(SMAP(key: "학생", value: "16"))
        return data
    }
    
    func makePorpose() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "급여 및 생활비", value: "01"))
        data.append(SMAP(key: "저축 및 투자", value: "02"))
        data.append(SMAP(key: "보험료납부 결제", value: "03"))
        data.append(SMAP(key: "공과금납부 결제", value: "04"))
        data.append(SMAP(key: "카드대금 결제", value: "05"))
        data.append(SMAP(key: "대출원리금 상환 결제", value: "06"))
        data.append(SMAP(key: "사업상거래", value: "07"))
        data.append(SMAP(key: "보상", value: "08"))
        data.append(SMAP(key: "상속/증여", value: "09"))
        return data
    }
    
    func makeSource() -> Array<SMAP>{
        var data:Array<SMAP> = Array<SMAP>()
        data.append(SMAP(key: "근로 및 연금소득", value: "A01"))
        data.append(SMAP(key: "퇴직소득", value: "A02"))
        data.append(SMAP(key: "사업소득", value: "A03"))
        data.append(SMAP(key: "부동산임대소득", value: "A04"))
        data.append(SMAP(key: "부동산양도소득", value: "A05"))
        data.append(SMAP(key: "금융소득", value: "A06"))
        data.append(SMAP(key: "상속/증여", value: "A07"))
        data.append(SMAP(key: "일시 재산양도로 인한 소득", value: "A08"))
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
