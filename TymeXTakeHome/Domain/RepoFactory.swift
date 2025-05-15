//
//  RepoFactory.swift
//  123yo
//
//  Created by NguyenNV on 15/11/2023.
//

import Foundation

class RepoFactory {
    
    class func getGithubUserRepo() -> PGithubUserRepo {
        return GitHubUserRepoImpl()
    }
}
