//
//  SocketIOManager.swift
//  TickTock
//
//  Created by Kevin on 04/06/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import Foundation


class SocketIOManager: NSObject
{
    static let sharedInstance = SocketIOManager()
//    var socket = SocketIOClient(socketURL: URL(string: "http://35.154.46.190:1337")!, config: [.log(true), .forcePolling(true), .connectParams(["__sails_io_sdk_version":"0.11.0"])]) \(appDelegate.arrLoginData[kkeyuser_id]!)
//    var socket = SocketIOClient(socketURL: URL(string: "http://13.59.71.92:9000")!, config: [.log(true), .forcePolling(true),.forceWebsockets(true), .path("/ticktock/socket.io"),.connectParams(["userId":"3"])])

    var socket = SocketIOClient(socketURL: URL(string: "http://18.221.196.29:9000")!, config: [.log(true), .forcePolling(true),.forceWebsockets(true),.nsp("/jackpot"), .path("/ticktock/socket.io"),.connectParams(["userId":"\(appDelegate.arrLoginData[kkeyuser_id]!)"])])
    
    override init()
    {
        super.init()
        
        socket.on("me_joined") { dataArray, ack in
            // print(dataArray)
            //print(dataArray.count)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameJoinedNotification"), object: dataArray[0] as? [String: AnyObject])
        }
       
        //update_home_screen
        socket.on("update_home_screen") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_home_screen"), object: dataArray[0] as? [String: AnyObject])
        }
        
        //Battel Screen
        /*
         export const EVT_EMIT_RESPONSE_BATTLE      						= 'response_battle';
         export const EVT_EMIT_RESPONSE_JOIN_NORMAL_BATTLE_LEVEL 	 	= 'response_join_normal_battle_level';
         export const EVT_EMIT_RESPONSE_PLACE_NORMAL_BATTLE_LEVEL_BID 	= 'response_place_normal_battle_level_bid';
         export const EVT_EMIT_NO_ENOUGH_AVAILABLE_BIDS 					= 'no_enough_available_bids';
         */



        socket.on("response_place_normal_battle_level_bid") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "response_place_normal_battle_level_bid"), object: dataArray[0] as? [String: AnyObject])

        }
        //TYPE 2
        socket.on("response_place_advance_battle_level_bid") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "response_place_normal_battle_level_bid"), object: dataArray[0] as? [String: AnyObject])
        }

        /*
         export const EVT_EMIT_UPDATE_NORMAL_BATTLE_LEVEL_PLAYER_LIST    = 'update_normal_battle_level_player_list';
         export const EVT_EMIT_NORMAL_BATTLE_LEVEL_TIMER                 = 'update_normal_battle_level_timer';
         export const EVT_EMIT_NORMAL_BATTLE_GAME_STARTED                = 'normal_battle_level_game_started';

         */
        socket.on("update_normal_battle_level_player_list") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_normal_battle_level_player_list"), object: dataArray[0] as? [String: AnyObject])
        }
        //TYPE 2
        socket.on("update_advance_battle_level_player_list") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_normal_battle_level_player_list"), object: dataArray[0] as? [String: AnyObject])
        }

        //TYPE 2
        socket.on("update_advance_battle_level_timer") { dataArray, ack in
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_normal_battle_level_timer"), object: dataArray[0] as? [String: AnyObject])
        }

         //TYPE 2
        socket.on("advance_battle_level_game_started") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_level_game_started"), object: dataArray[0] as? [String: AnyObject])
        }

        /*
         export const EVT_EMIT_HIDE_NBL_PLACE_BID_BUTTON                 = 'hide_normal_battle_level_place_bid_button';
         export const EVT_EMIT_SHOW_NBL_PLACE_BID_BUTTON                 = 'show_normal_battle_level_place_bid_button';
         export const EVT_EMIT_NBL_GAME_FINISHED                         = 'normal_battle_level_game_finished';

         */
        //TYPE 2
        
        
        socket.on("normal_battle_main_jackpot_finished") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_main_jackpot_finished"), object: nil)
        }
        //TYPE 2
        socket.on("advance_battle_main_jackpot_finished") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_main_jackpot_finished"), object: nil)
        }

        
        

        //no_jackpot_to_play

        //Battle Quite Methods
        socket.on("battle_quitted")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "battle_quitted"), object: dataArray[0] as? [String: AnyObject])
        }
        
        
        socket.on("jackpot_doomsday_over")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "jackpot_doomsday_over"), object: nil)
        }

        
        //NEW Battle Service
        socket.on("update_level_screen")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_level_screen"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("update_battle_game_screen")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_battle_screen"), object: dataArray[0] as? [String: AnyObject])
        }
//        socket.on("game_updates") { dataArray, ack in
//           
//            print("data:>\(dataArray)")
//            NotificationCenter.default
//                .post(name: Notification.Name(rawValue: "callGameUpdateNotification"), object: dataArray[0] as? [String: AnyObject])
//        }
    }
    
    func establishConnection()
    {
        socket.connect()
    }
    
    func closeConnection()
    {
        socket.disconnect()
    }
}
