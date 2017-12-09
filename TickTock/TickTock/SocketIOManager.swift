//
//  SocketIOManager.swift
//  TickTock
//
//  Created by Yash on 04/06/17.
//  Copyright © 2017 Niyati. All rights reserved.
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
    
        socket.on("update_jackpot_timer") { dataArray, ack in
           // print(dataArray)
            
            if appDelegate.bisHomeScreen == true
            {
                NotificationCenter.default
                    .post(name: Notification.Name(rawValue: "callGameUpdateTimerNotification"), object: dataArray[0] as? [String: AnyObject])
            }
            else
            {
                NotificationCenter.default
                    .post(name: Notification.Name(rawValue: "callGameUpdateTimerofBattle"), object: dataArray[0] as? [String: AnyObject])
            }
        }
        
        
        socket.on("something_went_wrong") { dataArray, ack in
            // print(dataArray)
            
            if appDelegate.bisHomeScreen == true
            {
                NotificationCenter.default
                    .post(name: Notification.Name(rawValue: "something_went_wrong_home"), object: dataArray[0] as? [String: AnyObject])
            }
            else
            {
                NotificationCenter.default
                    .post(name: Notification.Name(rawValue: "something_went_wrong_battle"), object: dataArray[0] as? [String: AnyObject])
            }
        }

        socket.on("place_bid_error") { dataArray, ack in
            // print(dataArray)
            //print(dataArray.count)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "place_bid_error"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("jackpot_my_info_changed") { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "jackpot_my_info_changed"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("updated_jackpot_data") { dataArray, ack in
           // print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameJackpotDataNotification"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("can_i_bid") { dataArray, ack in
          //  print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameCanPlacedBidNotification"), object: dataArray[0] as? [String: AnyObject])
        }
        
        
        socket.on("my_bid_placed") { dataArray, ack in
           // print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameMyPlacedBidNotification"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("show_quit_button") { dataArray, ack in
            //print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameQuitNotification"), object: nil)
        }

        socket.on("game_quitted") { dataArray, ack in
            //print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "game_quitted"), object: nil)
        }

        
        
        
        socket.on("game_finished") { dataArray, ack in
           // print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameFinishNotification"), object: dataArray[0] as? [String: AnyObject])
        }
                
        socket.on("update_available_bid_after_battle_win") { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_available_bid_after_battle_win"), object: dataArray[0] as? [String: AnyObject])
        }

        //Battel Screen
        /*
         export const EVT_EMIT_RESPONSE_BATTLE      						= 'response_battle';
         export const EVT_EMIT_RESPONSE_JOIN_NORMAL_BATTLE_LEVEL 	 	= 'response_join_normal_battle_level';
         export const EVT_EMIT_RESPONSE_PLACE_NORMAL_BATTLE_LEVEL_BID 	= 'response_place_normal_battle_level_bid';
         export const EVT_EMIT_NO_ENOUGH_AVAILABLE_BIDS 					= 'no_enough_available_bids';
         */
        socket.on("response_battle") { dataArray, ack in
            print("response_battle:>\(dataArray)")
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "response_battle"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("response_join_normal_battle_level") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "response_join_normal_battle_level"), object: dataArray[0] as? [String: AnyObject])
        }
        
        //TYPE 2
        socket.on("response_join_advance_battle_level") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "response_join_normal_battle_level"), object: dataArray[0] as? [String: AnyObject])
        }


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

        socket.on("update_home_jackpot_battle_info") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_home_jackpot_battle_info"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("no_enough_available_bids") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "no_enough_available_bids"), object: nil)
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

        socket.on("update_normal_battle_level_timer") { dataArray, ack in
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_normal_battle_level_timer"), object: dataArray[0] as? [String: AnyObject])
        }
        //TYPE 2
        socket.on("update_advance_battle_level_timer") { dataArray, ack in
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_normal_battle_level_timer"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("normal_battle_level_game_started") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_level_game_started"), object: dataArray[0] as? [String: AnyObject])
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
        socket.on("hide_normal_battle_level_place_bid_button") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "hide_normal_battle_level_place_bid_button"), object: nil)
        }
        //TYPE 2
        socket.on("hide_advance_battle_level_place_bid_button") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "hide_normal_battle_level_place_bid_button"), object: nil)
        }


        socket.on("show_normal_battle_level_place_bid_button") { dataArray, ack in
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "show_normal_battle_level_place_bid_button"), object: nil)
            
        }
        //TYPE 2
        socket.on("show_advance_battle_level_place_bid_button") { dataArray, ack in
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "show_normal_battle_level_place_bid_button"), object: nil)
            
        }

        socket.on("normal_battle_level_game_finished") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_level_game_finished"), object: dataArray[0] as? [String: AnyObject])
        }
        //TYPE 2
        socket.on("advance_battle_level_game_finished") { dataArray, ack in
            // print(dataArray)
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_level_game_finished"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("update_jackpot_amount") { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_jackpot_amount"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("update_normal_battle_jackpot_amount")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_normal_battle_jackpot_amount"), object: dataArray[0] as? [String: AnyObject])
        }
        //TYPE 2
        socket.on("update_advance_battle_jackpot_amount")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "update_normal_battle_jackpot_amount"), object: dataArray[0] as? [String: AnyObject])
        }

        
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

        
       // normal_battle_game_about_to_start
        socket.on("normal_battle_game_about_to_start")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_game_about_to_start"), object: dataArray[0] as? [String: AnyObject])
        }
        //TYPE 2
        socket.on("advance_battle_game_about_to_start")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_game_about_to_start"), object: dataArray[0] as? [String: AnyObject])
        }
        
        //game_finished
        socket.on("game_finished")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "game_finished"), object: dataArray[0] as? [String: AnyObject])
        }

        //no_jackpot_to_play
        socket.on("no_jackpot_to_play")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "no_jackpot_to_play"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("advance_battle_not_eligible_to_join")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "advance_battle_not_eligible_to_join"), object: dataArray[0] as? [String: AnyObject])
        }

        //Battle Quite Methods
        socket.on("show_normal_battle_quit_button")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "show_normal_battle_quit_button"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("hide_normal_battle_quit_button")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "hide_normal_battle_quit_button"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("show_advance_battle_quit_button")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "show_normal_battle_quit_button"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("hide_advance_battle_quit_button")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "hide_normal_battle_quit_button"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("normal_battle_game_quitted")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_game_quitted"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("advance_battle_game_quitted")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "normal_battle_game_quitted"), object: dataArray[0] as? [String: AnyObject])
        }
        
        
        socket.on("jackpot_doomsday_over")
        { dataArray, ack in
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "jackpot_doomsday_over"), object: nil)
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
