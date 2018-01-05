//
//  Token.m
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import "Token.h"

@implementation Token

NSString * const TokenIdentifier(TokenEnum token) {
    switch (token) {
        case MMEAUTHTOKEN:
            return @"mmeAuthToken";
        case MMEFMFTOKEN:
            return @"mmeFMFToken";
        case MMEFMIPTOKEN:
            return @"mmeFMIPToken";
        case MAPSTOKEN:
            return @"mapsToken";
        case MMEFMFAPPTOKEN:
            return @"mmeFMFAppToken";
        case CLOUDKITTOKEN:
            return @"cloudKitToken";
        default:
            return @"";
    }
}

@end
