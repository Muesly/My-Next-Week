//
//  ActionDimension.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import Foundation
import SwiftUI

class ActionDimension: Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let colour: Color
    var actionTypes: [ActionType]
    var defaultActionTypes: [ActionType]
    let userDefaults: UserDefaultsType

    init(id: UUID = UUID(),
         name: String,
         description: String,
         colour: Color,
         defaultActionTypes: [ActionType],
         userDefaults: UserDefaultsType = UserDefaults.standard) {
        self.id = id
        self.name = name
        self.description = description
        self.colour = colour
        self.actionTypes = []
        self.defaultActionTypes = defaultActionTypes
        self.userDefaults = userDefaults
    }

    static func == (lhs: ActionDimension, rhs: ActionDimension) -> Bool {
        lhs.name == rhs.name
    }

    var keyName: String {
        "\(name)-actionTypes"
    }

    func loadActions() {
        if let actionTypesData = userDefaults.value(forKey: keyName) as? Data {
            let decoder = JSONDecoder()
            actionTypes = (try? decoder.decode(Array.self, from: actionTypesData) as [ActionType]) ?? []
        } else {
            actionTypes = defaultActionTypes.map { $0 }
        }
    }

    func saveActions() {
        let encoder = JSONEncoder()
        if let encodedActionTypes = try? encoder.encode(actionTypes){
            UserDefaults.standard.set(encodedActionTypes, forKey: keyName)
        }
    }
}

extension ActionDimension {
    static var physical: ActionDimension = {
        .init(name: "Physical",
              description: "Actions that help physical strength, flexibility and endurance, in addition to actions that help improve nutrition.",
              colour: Color("babyBlue"),
              defaultActionTypes: [ActionType(name: "Go to Spin class"),
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
              colour: Color("blushPink"),
              defaultActionTypes: [ActionType(name: "Plan", prefill: false)])
    }()

    static var social: ActionDimension = {
        .init(name: "Social",
              description: "Actions that improve relationships with family, friends and colleagues.",
              colour: Color("softPeach"),
              defaultActionTypes: [ActionType(name: "Meet a friend", prefill: false),
                            ActionType(name: "Do Family call"),
                            ActionType(name: "Check in on a colleague", prefill: false)])
    }()

    static var spiritual: ActionDimension = {
        .init(name: "Spiritual",
              description: "Actions that nurture the soul, such as taking time to reflect, to enjoy nature, and listen to music.",
              colour: Color("lavendar"),
              defaultActionTypes: [ActionType(name: "Meditate"),
                            ActionType(name: "Mindful walk"),
                            ActionType(name: "Go to the park")])
    }()

    static var mental: ActionDimension = {
        .init(name: "Mental",
              description: "Actions that improve knowledge and understanding through mediums such as books, podcasts & TV.",
              colour: Color("mintGreen"),
              defaultActionTypes: [ActionType(name: "Read a book", prefill: false),
                            ActionType(name: "Listen to a podcase", prefill: false),
                            ActionType(name: "Watch a TV show", prefill: false)])
    }()
}
