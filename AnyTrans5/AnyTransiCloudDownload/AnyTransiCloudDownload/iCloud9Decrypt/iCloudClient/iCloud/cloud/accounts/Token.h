//
//  Token.h
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

typedef enum Token {
    MMEAUTHTOKEN,
    MMEFMFTOKEN,
    MMEFMIPTOKEN,
    MAPSTOKEN,
    MMEFMFAPPTOKEN,
    CLOUDKITTOKEN
} TokenEnum;

@interface Token : NSObject

NSString * const TokenIdentifier(TokenEnum token);

@end
