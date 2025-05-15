//
//  GithubUserDataToGithubUser.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Base_swift

class GithubUserDetailDataToGithubUserDetail: SimpleConverter<GitHubUserDetailData, GitHubUser> {
    override func convert(input: GitHubUserDetailData) -> GitHubUser {
        let output = GitHubUser()
        
        output.id = input.id
        output.login = input.login
        output.avatarURL = input.avatarURL
        output.htmlURL = input.htmlURL
        output.blog = input.blog
        output.followers = input.followers
        output.following = input.following
        output.location = input.location
        
        return output
    }
}

