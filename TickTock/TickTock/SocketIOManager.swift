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

    var socket = SocketIOClient(socketURL: URL(string: "http://13.59.71.92:9000")!, config: [.log(true), .forcePolling(true),.forceWebsockets(true),.nsp("/jackpot"), .path("/ticktock/socket.io"),.connectParams(["userId":"\(appDelegate.arrLoginData[kkeyuser_id]!)"])])
    
    override init()
    {
        super.init()
        
        socket.on("me_joined") { dataArray, ack in
            print(dataArray)
            print(dataArray.count)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameJoinedNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    
        socket.on("update_jackpot_timer") { dataArray, ack in
            print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameUpdateTimerNotification"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("updated_jackpot_data") { dataArray, ack in
            print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameJackpotDataNotification"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("can_i_bid") { dataArray, ack in
            print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameCanPlacedBidNotification"), object: dataArray[0] as? [String: AnyObject])
        }
        
        
        socket.on("my_bid_placed") { dataArray, ack in
            print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameMyPlacedBidNotification"), object: dataArray[0] as? [String: AnyObject])
        }
        
        socket.on("show_quit_button") { dataArray, ack in
            print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameQuitNotification"), object: dataArray[0] as? [String: AnyObject])
        }

        socket.on("game_finished") { dataArray, ack in
            print(dataArray)
            
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "callGameFinishNotification"), object: dataArray[0] as? [String: AnyObject])
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
