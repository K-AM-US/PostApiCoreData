//
//  Post.swift
//  PostApiCoreData
//
//  Created by Mauricio Casillas on 13/10/23.
//

import Foundation

struct PostApi: Codable {
    let id: Int?
    let title: String
    let body: String
    let userId: Int
}
