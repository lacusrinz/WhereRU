//
//  CommonConstant.swift
//  WhereRU
//
//  Created by RInz on 15/1/30.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

let loginURL:String = "http://54.255.168.161/auth/login"
let meURL:String = "http://54.255.168.161/auth/me"
let registrURL:String = "http://54.255.168.161/auth/register"

let friendsURL:String = "http://54.255.168.161/friends/"
let friendByIdURL:String = "http://54.255.168.161/friends/%d"

let inviteURL = "http://54.255.168.161/events/invite/"
let invitedURL = "http://54.255.168.161/events/invited/"

let createEventURL:String = "http://54.255.168.161/events/"
let updateEventURL:String = "http://54.255.168.161/events/%d/"
let eventStatusURL:String = "http://54.255.168.161/participants/my_event_status/?eventid=%d"
let updateEventStatusURL:String = "http://54.255.168.161/participants/%d/"

let participantsInEventURL:String = "http://54.255.168.161/participants/by_event/?eventid=%d"
let addParticipantsToEventURL:String = "http://54.255.168.161/events/%d/set_participants/"

