//
//  BlogModel.swift
//  Blog
//
//  Created by Sandesh on 29/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//
import Foundation

// MARK: - BlogElement
struct BlogElement: Codable {
    let id, createdAt, content: String
    let comments, likes: Int
    let media: [Media]
    let user: [User]
}

// MARK: - Media
struct Media: Codable {
    let id, blogID, createdAt: String
    let image: String
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id
        case blogID = "blogId"
        case createdAt, image, title, url
    }
}

// MARK: - User
struct User: Codable {
    let id, blogID, createdAt, name: String
    let avatar: String
    let lastname, city, designation, about: String

    enum CodingKeys: String, CodingKey {
        case id
        case blogID = "blogId"
        case createdAt, name, avatar, lastname, city, designation, about
    }
}

typealias Blog = [BlogElement]

