//
//  Service.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

typedef enum Service {
    EMPTY = 0,                  // Unspecified
    MASTER = 1,                 // MasterKey
    BLADERUNNER = 2,            // iCloudDrive
    HYPERION = 3,               // Photos
    LIVERPOOL = 4,              // CloudKit
    IMESSAGE = 5,               // iMessage
    FDE = 6,                    // FDE
    PIANOMOVER = 7,             // Maildrop
    LUMPYMATTRESS = 8,          // placeholder
    FURIOUSPOTATO = 9,          // placeholder
    BROKENCOCONUT = 10,         // placeholder
    DRIEDWATER = 11,            // placeholder
    BURNTCOOKIE = 12,           // placeholder
    WOBBLYQUARK = 13,           // placeholder
    MIDNIGHTBLUE = 14,          // placeholder
    MISSINGBUTTON = 15,         // placeholder
    ELECTRICSHEEP = 16,         // placeholder
    EXMACHINA = 17              // placeholder
} ServiceEnum;