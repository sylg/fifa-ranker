//
//  FifaApi.swift
//  fifa-ranker
//
//  Created by Sylvain Giuliani on 01/01/2016.
//  Copyright © 2016 Sylvain Giuliani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol Endpoint {
    var path:String {get}
    var method:Alamofire.Method {get}
    var resourceName:String {get}
}

protocol Resource {
    var id:Int? {get}
}

public enum APIEndpoint: Endpoint {
    case Players
    case FifaTeams
    case PlayerCombinations
    case Game
    case Games
    
    public var path:String {
        switch self {
        case .Players:
            return "players"
        case .FifaTeams:
            return "fifa_teams"
        case .PlayerCombinations:
            return "player_combinations"
        case .Game, .Games:
            return "games"
        }
    }
    
    public var method:Alamofire.Method {
        switch self {
        case .Players, .FifaTeams, .PlayerCombinations, .Game:
            return .POST
        case .Games:
            return .GET
        }
    }
    
    public var resourceName:String {
        switch self {
        case .Players:
            return "player"
        case .FifaTeams:
            return "fifa_team"
        case .PlayerCombinations:
            return "player_combination"
        case .Game:
            return "games"
        case .Games:
            return "games"
        }
    }
    
}

class FifaAPI {
    var baseUrl:String {
        get {
            let env = NSProcessInfo.processInfo().environment
            if env["environment"] != nil {
                return "http://127.0.0.1:9393/"
            } else {
                return "https://pusher-fifa-api.herokuapp.com/"
            }
        }
    }
    
    func post(resource:APIEndpoint, data:AnyObject, onCompletion:(response:String?, error:NSError?)->Void) {
        let fullURL = self.baseUrl + resource.path
        var validData:[String:AnyObject]?
        
        switch resource {
        case .Game:
            validData = (data as! Dictionary)
        default:
            print("not implemented \(resource)")
        }
        
        
        Alamofire.request(.POST, fullURL, parameters: validData!, encoding: .JSON).responseJSON { response in
            if response.response!.statusCode == 200 {
                switch response.result {
                case .Success:
                    onCompletion(response: "success", error: nil)
                case .Failure(let error):
                    onCompletion(response: nil, error: error)
                }
            }
            else {
                onCompletion(response: nil, error: NSError(domain: "Server returned an error code \(response.response!.statusCode)", code: 0, userInfo: nil))
            }
            
        }
    }
    
    func getAll(resource:APIEndpoint, onCompletion:(response:[Resource]?, error:NSError?)->Void) {
        // TODO: Implement Paginations support
        let fullURL = self.baseUrl + resource.path
        
        Alamofire.request(.GET, fullURL).responseJSON { response in
            var results = [Resource]()
            switch response.result {
                
                case .Success:
                    let json = JSON(data: response.data!)
                    for (_,subJson):(String, JSON) in json["results"] {
                        switch resource {
                        case .Games:
                            let homeTeam = Team(fifaTeam: FifaTeam(teamName: subJson["team_one"]["fifa_team"]["team_name"].string!, teamRating: subJson["team_one"]["fifa_team"]["team_rating"].int!, id: subJson["team_one"]["fifa_team"]["id"].int!), playerCombination: nil, goalsScored: subJson["team_one"]["goals_scored"].int!)

                            let awayTeam = Team(fifaTeam: FifaTeam(teamName: subJson["team_two"]["fifa_team"]["team_name"].string!, teamRating: subJson["team_two"]["fifa_team"]["team_rating"].int!, id: subJson["team_two"]["fifa_team"]["id"].int!), playerCombination: nil, goalsScored: subJson["team_two"]["goals_scored"].int!)
                            
                            var game = Game(home: homeTeam, away: awayTeam)
                            
                            let strDate = subJson["created_at"].string!
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            game.createdAt = dateFormatter.dateFromString( strDate )
                            
                            game.id = subJson["id"].int!
                            
                            results.append(game)
                        case .Players:
                            results.append(Player(SlackId: Int(subJson["slack_id"].string!)!, slackName: subJson["slack_name"].string!, id: subJson["id"].int!))
                        case .FifaTeams:
                            results.append(FifaTeam(teamName: subJson["team_name"].string!, teamRating: subJson["team_rating"].int!, id: subJson["id"].int!))
                        default:
                            print("not implemented for \(resource)")
                        }
                    }
                    onCompletion(response: results , error:nil)
                
                case .Failure(let error):
                    onCompletion(response: nil, error:error)
            }
            
        }
    }
    
    func delete(resource:APIEndpoint,id:Int, onCompletion: (results:Int, error:NSError?)->Void) {
        let fullURL = self.baseUrl + resource.path + "/" + String(id)
        
        Alamofire.request(.DELETE, fullURL).responseString { response in
            let statusCode = response.response!.statusCode
            
            switch statusCode {
            case 200:
                onCompletion(results: statusCode, error:nil)
            default:
                onCompletion(results: statusCode, error: NSError(domain: response.result.value!, code: statusCode, userInfo: nil) )
            }
        }
    }    
}







