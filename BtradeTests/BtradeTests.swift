//
//  BtradeTests.swift
//  BtradeTests
//
//  Created by 블록체인컴퍼니 on 2022/06/30.
//

import XCTest
@testable import Btrade

class BtradeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var string:String = """
            지금은 테스트 중입니다.
            지금도
            
            테스트
            
            중입니다.
            """
        print(ConvertHtmlUtil.stringToHTMLString(string))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
