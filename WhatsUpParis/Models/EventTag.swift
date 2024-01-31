//
//  EventTag.swift
//  WhatsUpParis
//
//  Created by Adrien Cullier on 28/11/2023.
//

import Foundation
import SwiftUI

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

public enum Category: CaseIterable {
    case enfants
    case musique
    case plasticArts
    case theatre
    case cinema
    case sport
    case litterature
    case circus
    case danse
    case gratuit
    
    var id: UUID { UUID() }
    
    var title: String {
        switch self {
        case .enfants:
            return "Enfants"
        case .musique:
            return "Musique"
        case .plasticArts:
            return "Arts"
        case .theatre:
            return "Théâtre"
        case .cinema:
            return "Cinéma"
        case .sport:
            return "Sport"
        case .litterature:
            return "Littérature"
        case .circus:
            return "Cirque"
        case .danse:
            return "Danse"
        case .gratuit:
            return "Gratuit"
        }
    }
    
    var tags: [EventTag] {
        switch self {
        case .enfants:
            return [.kids]
        case .musique:
            return [
                .concert,
                .musique,
                .musicalShow
            ]
        case .plasticArts:
            return [
                .expo,
                .paint,
                .modernArt,
                .photo,
                .streetArt
            ]
        case .theatre:
            return [.theater]
        case .cinema:
            return [.cinema]
        case .sport:
            return [
                .sport,
                .jo2024
            ]
        case .litterature:
            return [
                .bd,
                .litterature
            ]
        case .circus:
            return [.circus]
        case .danse:
            return [.danse]
        case .gratuit:
            return []
        }
    }
    
    var icon: String {
        switch self {
        case .enfants:
            return "figure.and.child.holdinghands"
        case .musique:
            return "music.mic"
        case .plasticArts:
            return "photo.artframe"
        case .theatre:
            return "theatermasks"
        case .cinema:
            return "film"
        case .sport:
            return "football"
        case .litterature:
            return "book"
        case .circus:
            return "pawprint"
        case .danse:
            return "figure.dance"
        case .gratuit:
            return "staroflife"
        }
    }
    
    var color: Color {
        switch self {
        case .enfants:
            return Color("Wblue")
        case .musique:
            return Color("Wpurple")
        case .plasticArts:
            return Color("Wred")
        case .theatre:
            return Color("Waquablue")
        case .cinema:
            return Color("Wgreen")
        case .sport:
            return Color("Worange")
        case .litterature:
            return Color("Wpink")
        case .circus:
            return Color("WdarkGreen")
        case .danse:
            return Color("Wblack")
        case .gratuit:
            return Color("Wblack")
        }
    }
    
    static func getCategories(from tags: [EventTag]) -> [Category] {
        var cats: [Category] = []
        tags.forEach({ tag in
            guard let category = Category.allCases.first(where: { $0.tags.contains(tag) }),
                  !cats.contains(category) else {
                return
            }
            cats.append(category)
        })
        return cats
    }
}

enum EventTag: String {
    case expo = "Expo"
    case kids = "Enfants"
    case concert = "Concert"
    case musique = "Musique"
    case musicalShow = "Spectacle musical"
    case theater = "Théâtre"
    case nature = "Nature"
    case modernArt = "Art contemporain"
    case paint = "Peinture"
    case jo2024 = "Jeux 2024"
    case sport = "Sport"
    case litterature = "Littérature"
    case danse = "Danse"
    case cinema = "Cinéma"
    case bd = "BD"
    case circus = "Cirque"
    case photo = "Photo"
    case streetArt = "Street art"
}
