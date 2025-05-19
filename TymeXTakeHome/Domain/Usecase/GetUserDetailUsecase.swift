//
//  GetUserDetailAction.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 15/5/25.
//

import Foundation
import Base_swift

class GetUserDetailUsecase: Action<GetUserDetailUsecase.RV, GitHubUser> {
    
    private var repository: PGithubUserRepo
    
    init(_ repository: PGithubUserRepo = GitHubUserRepoImpl()) {
        self.repository = repository
    }
    
    override func onExecute(input: RV) throws -> GitHubUser? {
        return try repository.getUserDetail(userName: input.userName)
    }
    
    struct RV {
        let userName: String
    }
}
