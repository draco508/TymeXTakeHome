//
//  GithubUserDataToGithubUser.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Base_swift

class GithubUserDataToGithubUser: SimpleConverter<GitHubUserData, GitHubUser> {
    override func convert(input: GitHubUserData) -> GitHubUser? {
        let output = GitHubUser()
        
        output.id = input.id
        output.login = input.login
        output.avatarURL = input.avatarURL
        output.htmlURL = input.htmlURL
        
        return output
    }
}

