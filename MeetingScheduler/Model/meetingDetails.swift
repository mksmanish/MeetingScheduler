//
//  meetingDetails.swift
//  MeetingScheduler
//
//  Created by manish on 30/07/21.
//

import Foundation

// MARK: - meetingDetails
struct meetingDetails: Codable {
    let startTime, endTime, welcomeDescription: String
    let participants: [String]

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case welcomeDescription = "description"
        case participants
    }
}

typealias meeting = [meetingDetails]

