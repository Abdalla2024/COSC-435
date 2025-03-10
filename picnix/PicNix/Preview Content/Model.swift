//
//  Model.swift
//  PicNix
//
//  Created by Abdalla Abdelmagid on 10/20/24.
//

struct Model: Identifiable, Decodable {
    let id: Int
    let image: String
    let amount: Int
    let createdAt: String
    let businessName: String
    let username: String
    let isPrivate: Bool
    let caption: String?

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case amount
        case createdAt
        case businessName
        case username
        case isPrivate = "private"
        case caption
    }
}

