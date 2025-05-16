//
//  GetListUserActionTests.swift
//  TymeXTakeHomeTests
//
//  Created by REACT PLUS on 16/5/25.
//

import Base_swift
import XCTest
@testable import TymeXTakeHome

class MockRepoFactory: PFactory {
    
    private var type: Int
    
    init(type: Int) {
        self.type = type
    }
    
    func getGithubUserRepo() -> any TymeXTakeHome.PGithubUserRepo {
        return MockRepo(type: type)
    }
    
}

class MockRepo: PGithubUserRepo {
    
    private var type: Int
    
    init(type: Int) {
        self.type = type
    }
    
    func getListUser(perPage: Int, since: Int) throws -> TymeXTakeHome.DataPage<TymeXTakeHome.GitHubUser> {
        let page = TymeXTakeHome.DataPage<TymeXTakeHome.GitHubUser>()
        
        switch type {
        case -1:
            throw BaseError(code: "404", message: "Not found")
        case 0:
            var users: [GitHubUser] = []
            
            for i in 1...20 {
                let user = GitHubUser()
                user.login = "A_\(i)"
                user.id = i
                user.htmlURL = "abc.com"
                users.append(user)
            }
            
            page.dataList = users
            page.perPage = 100
            page.hasNextPage = true
            
            return page
        case 1:
            
            var users: [GitHubUser] = []
            
            for i in 1...15 {
                let user = GitHubUser()
                user.login = "A_\(i)"
                user.id = i
                user.htmlURL = "abc.com"
                users.append(user)
            }
            
            page.dataList = users
            page.perPage = 100
            page.hasNextPage = false
            return page
        default:
            page.perPage = -1
            page.currentPage = -1
            return page
        }
        
    }
    
    func getUserDetail(userName: String) throws -> TymeXTakeHome.GitHubUser {
        return TymeXTakeHome.GitHubUser()
    }
    
}

final class GetListUserActionTests: XCTestCase {
    
   

    func testFullPage() throws {
        
        let datapage = try GetListUserAction(MockRepoFactory(type: 0)).onExecute(input: GetListUserAction.RV(perPage: 100, since: 20))
        
        XCTAssertEqual(datapage.perPage, 100)
        XCTAssertEqual(datapage.dataList.count, 20)
        XCTAssertEqual(datapage.hasNextPage, true)
    }
    
    func testNotFullPage() throws {
        let datapage = try GetListUserAction(MockRepoFactory(type: 1)).onExecute(input: GetListUserAction.RV(perPage: 100, since: 20))
        
        XCTAssertEqual(datapage.perPage, 100)
        XCTAssertLessThan(datapage.dataList.count, 20)
        XCTAssertEqual(datapage.hasNextPage, false)
    }
    
    func testGetPageFail() throws {
        
        do {
            try? GetListUserAction(MockRepoFactory(type: -1)).onExecute(input: GetListUserAction.RV(perPage: 100, since: 20))
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
