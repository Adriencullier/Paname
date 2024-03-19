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

enum Category: CaseIterable {
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
    case solidarity
    case history
    case atelier
    case inovation
    case gourmand
    case humour
    case conference
    case brocante
    case clubbing
    
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
        case .solidarity:
            return "Solidarité"
        case .history:
            return "Histoire"
        case .atelier:
            return "Atelier"
        case .inovation:
            return "Innovation"
        case .gourmand:
            return "Gourmand"
        case .humour:
            return "Humour"
        case .conference:
            return "Conférence"
        case .brocante:
            return "Brocante"
        case .clubbing:
            return "Clubbing"
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
        case .solidarity:
            return [.solidarity]
        case .history:
            return [.history]
        case .atelier:
            return [.atelier]
        case .inovation:
            return [.inovation]
        case .gourmand:
            return [.gourmand]
        case .humour:
            return [.humour]
        case .conference:
            return [.conference]
        case .brocante:
            return [.brocante]
        case .clubbing:
            return [.clubbing]
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
        case .solidarity:
            return "heart"
        case .history:
            return "flag"
        case .atelier:
            return "house"
        case .inovation:
            return "lightbulb"
        case .gourmand:
            return "fork.knife"
        case .humour:
            return "theatermasks"
        case .conference:
            return "ellipsis.message"
        case .brocante:
            return "chair.lounge"
        case .clubbing:
            return "figure.socialdance"
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
        case .solidarity:
            return Color("Wblue")
        case .history:
            return Color("Wpurple")
        case .atelier:
            return Color("Wred")
        case .inovation:
            return Color("Waquablue")
        case .gourmand:
            return Color("Wgreen")
        case .humour:
            return Color("Worange")
        case .conference:
            return Color("Wpink")
        case .brocante:
            return Color("WdarkGreen")
        case .clubbing:
            return Color("Worange")
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
    case expo = "expo"
    case kids = "enfants"
    case concert = "concert"
    case musique = "musique"
    case musicalShow = "spectacle musical"
    case theater = "théâtre"
    case nature = "nature"
    case modernArt = "art contemporain"
    case paint = "peinture"
    case jo2024 = "jeux 2024"
    case sport = "sport"
    case litterature = "littérature"
    case danse = "danse"
    case cinema = "cinéma"
    case bd = "bd"
    case circus = "cirque"
    case photo = "photo"
    case streetArt = "street art"
    case solidarity = "solidarité"
    case history = "histoire"
    case atelier = "atelier"
    case inovation = "innovation"
    case gourmand = "gourmand"
    case humour = "humour"
    case conference = "conférence"
    case brocante = "brocante"
    case clubbing = "clubbing"
}
