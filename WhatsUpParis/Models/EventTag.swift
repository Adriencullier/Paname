//
//  EventTag.swift
//  WhatsUpParis
//
//  Created by Adrien Cullier on 28/11/2023.
//

import Foundation
enum Accessibility: String, Codable {
    case pmr = "pmr"
    case blind = "blind"
    case deaf = "deaf"
    
    var icon: String {
        switch self {
        case .pmr:
            return "figure.roll"
        case .blind:
            return "eye"
        case .deaf:
            return "hearingdevice.ear"
        }
    }
}
enum EventTag: CaseIterable {
    case expo
    case kids
    case concert
    case musique
    case musicalShow
    case theater
    case nature
    case workshop
    case modernArt
    case hobbies
    case paint
    case jo2024
    case sport
    case innovation
    case conference
    case literature
    case danse
    case cinema
    case bd
    case walk
    case circus
    case history
    case photo
    case brocante
    case solidarity
    case streetArt
    case other(value: String)
    
    static var allCases: [EventTag] {
        return [
            .expo,
            .kids,
            .concert,
            .musique,
            .musicalShow,
            .theater,
            .nature,
            .workshop,
            .modernArt,
            .hobbies,
            .paint,
            .jo2024,
            .sport,
            .innovation,
            .concert,
            .literature,
            .danse,
            .cinema,
            .bd,
            .walk,
            .circus,
            .history,
            .photo,
            .brocante,
            .solidarity,
            .streetArt
        ]
    }
    
    var id: UUID {
        return UUID()
    }
    
    var rawValue: String? {
        switch self {
        case .expo:
            return "expo"
        case .kids:
            return "enfants"
        case .concert:
            return "concert"
        case .musique:
            return "musique"
        case .musicalShow:
            return "spectacle musical"
        case .theater:
            return "théâtre"
        case .nature:
            return "nature"
        case .workshop:
            return "atelier"
        case .modernArt:
            return "art contemporain"
        case .hobbies:
            return "loisirs"
        case .paint:
            return "peinture"
        case .jo2024:
            return "jeux 2024"
        case .sport:
            return "sport"
        case .innovation:
            return "innovation"
        case .conference:
            return "conférence"
        case .literature:
            return "littérature"
        case .danse:
            return "danse"
        case .cinema:
            return "cinéma"
        case .bd:
            return "bd"
        case .walk:
            return "ballade"
        case .circus:
            return "cirque"
        case .history:
            return "histoire"
        case .photo:
            return "photo"
        case .brocante:
            return "brocante"
        case .solidarity:
            return "solidarité"
        case .streetArt:
            return "street art"
        case .other:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .expo:
            return "expo"
        case .kids:
            return "enfants"
        case .concert:
            return "concert"
        case .musique, .musicalShow:
            return "musique"
        case .theater:
            return "théâtre"
        case .nature:
            return "nature"
        case .workshop:
            return "atelier"
        case .modernArt:
            return "art contemporain"
        case .hobbies:
            return "loisirs"
        case .paint:
            return "peinture"
        case .jo2024:
            return "JO 2024"
        case .sport:
            return "sport"
        case .innovation:
            return "innovation"
        case .conference:
            return "conférence"
        case .literature:
            return "littérature"
        case .danse:
            return "danse"
        case .cinema:
            return "cinéma"
        case .bd:
            return "BD"
        case .walk:
            return "ballade"
        case .circus:
            return "cirque"
        case .history:
            return "histoire"
        case .photo:
            return "photo"
        case .brocante:
            return "brocante"
        case .solidarity:
            return "solidarité"
        case .streetArt:
            return "street art"
        case .other(let value):
            return value
        }
    }
    
    var icon: String {
        switch self {
        case .expo:
            "photo.artframe"
        case .kids:
            "figure.and.child.holdinghands"
        case .concert, .musicalShow, .musique:
            "music.mic"
        case .theater:
            "theatermasks"
        case .nature:
            "leaf"
        case .workshop, .conference:
            "house"
        case .modernArt:
            "photo.artframe"
        case .paint, .streetArt:
            "paintpalette"
        case .jo2024:
            "flame"
        case .sport:
            "football"
        case .innovation:
            "lightbulb"
        case .literature, .bd:
            "book"
        case .danse:
            "figure.dance"
        case .cinema:
            "film"
        case .walk, .brocante, .solidarity, .hobbies, .history:
            "person"
        case .circus:
            "pawprint"
        case .photo:
            "camera"
        case .other:
            "questionmark"
        }
    }
    
    init(rawValue: String) {
        guard let tag = Self.allCases.first(where: { $0.rawValue == rawValue }) else {
            self = .other(value: rawValue)
            return
        }
        self = tag
    }
    
}
