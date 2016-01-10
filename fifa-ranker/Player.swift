//
//  Player.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import Foundation


class Player: Resource, Hashable, CustomStringConvertible {
    let id:Int?
    let slackId:Int
    let slackName:String
    var hashValue: Int {
        return id!
    }
    
    var description: String {
        return slackName
    }
    
    init(SlackId:Int, slackName:String, id:Int) {
        self.id = id
        self.slackId = SlackId
        self.slackName = slackName
    }
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.id == rhs.id
}