//
//  ActionDimension.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import Foundation

struct ActionDimension: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let actionTypes: [ActionType]
}

extension ActionDimension {
    static var physical: ActionDimension = {
        .init(name: "Physical",
              description: "Actions that help physical strength, flexibility and endurance, in addition to actions that help improve nutrition.",
              actionTypes: [ActionType(name: "Go to Spin class"),
                            ActionType(name: "Go to the gym"),
                            ActionType(name: "Go to Park Run"),
                            ActionType(name: "Go for a swim"),
                            ActionType(name: "Go for a walk"),
                            ActionType(name: "Have a calorie deficit day")
                           ])
    }()

    static var planning: ActionDimension = {
        .init(name: "Planning",
              description: "Actions that help to improve the home environment, plan activities and improve finances.",
              actionTypes: [ActionType(name: "Plan", nameAsDefault: false)])
    }()

    static var social: ActionDimension = {
        .init(name: "Social",
              description: "Actions that improve relationships with family, friends and colleagues.",
              actionTypes: [ActionType(name: "Meet a friend", nameAsDefault: false),
                            ActionType(name: "Do Family call"),
                            ActionType(name: "Check in on a colleague", nameAsDefault: false)])
    }()

    static var spiritual: ActionDimension = {
        .init(name: "Spiritual",
              description: "Actions that nurture the soul, such as taking time to reflect, to enjoy nature, and listen to music.",
              actionTypes: [ActionType(name: "Meditate"),
                            ActionType(name: "Mindful walk"),
                            ActionType(name: "Go to the park")])
    }()

    static var mental: ActionDimension = {
        .init(name: "Mental",
              description: "Actions that improve knowledge and understanding through mediums such as books, podcasts & TV.",
              actionTypes: [ActionType(name: "Read a book", nameAsDefault: false),
                            ActionType(name: "Listen to a podcase", nameAsDefault: false),
                            ActionType(name: "Watch a TV show", nameAsDefault: false)])
    }()
}
