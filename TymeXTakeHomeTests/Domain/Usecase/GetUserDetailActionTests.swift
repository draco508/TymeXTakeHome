//
//  GetUserDetailActionTests.swift
//  TymeXTakeHomeTests
//
//  Created by  NguyenNV on 19/5/25.
//

import Base_swift
import XCTest
@testable import TymeXTakeHome


final class GetUserDetailActionTests: XCTestCase {

   
    func testGetUserDetailSuccess() throws {
        let user = try GetUserDetailUsecase(MockRepo(stage: .full)).onExecute(input: GetUserDetailUsecase.RV(userName: "freeformz"))
        XCTAssertEqual(user?.login, "freeformz")
    }
    
    func testGetUserDetailFailure() throws {
        do {
            _ = try GetUserDetailUsecase(MockRepo(stage: .fail)).onExecute(input: GetUserDetailUsecase.RV(userName: "freeformz"))
        } catch {
            
            XCTAssertTrue(error is BaseError)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
