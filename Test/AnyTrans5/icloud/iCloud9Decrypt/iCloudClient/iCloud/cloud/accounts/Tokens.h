//
//  Tokens.h
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "Token.h"

@interface Tokens : NSObject {
@private
    NSDictionary *_tokens;
}

- (id)init:(NSDictionary*)tokens_;

- (NSString*)get:(TokenEnum)token;

@end
