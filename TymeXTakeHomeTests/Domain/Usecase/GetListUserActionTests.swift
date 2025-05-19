//
//  GetListUserActionTests.swift
//  TymeXTakeHomeTests
//
//  Created by  NguyenNV on 16/5/25.
//

import Base_swift
import XCTest
@testable import TymeXTakeHome

final class GetListUserActionTests: XCTestCase {
    
    func testFullListUser() throws {
        
        let listUser = try GetListUserUsecase(MockRepo(stage: .full)).onExecute(input: GetListUserUsecase.RV(perPage: 100, since: 20))
        XCTAssertEqual(listUser.count, 20)
       
    }
    
    func testNotFullListUser() throws {
        let listUser = try GetListUserUsecase(MockRepo(stage: .notFull)).onExecute(input: GetListUserUsecase.RV(perPage: 100, since: 20))
        
        
        XCTAssertLessThan(listUser.count, 20)
        
    }
    
    func testGetListUserFail() throws {
        
        do {
            _ = try GetListUserUsecase(MockRepo(stage: .fail)).onExecute(input: GetListUserUsecase.RV(perPage: 100, since: 20))
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
