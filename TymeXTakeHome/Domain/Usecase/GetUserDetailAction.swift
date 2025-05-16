//
//  GetUserDetailAction.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 15/5/25.
//

import Foundation
import Base_swift

class GetUserDetailAction: Action<GetUserDetailAction.RV, GitHubUser> {
    
    override func onExecute(input: RV) throws -> GitHubUser? {
        return try RepoFactory().getGithubUserRepo().getUserDetail(userName: input.userName)
    }
    
    struct RV {
        let userName: String
    }
}
