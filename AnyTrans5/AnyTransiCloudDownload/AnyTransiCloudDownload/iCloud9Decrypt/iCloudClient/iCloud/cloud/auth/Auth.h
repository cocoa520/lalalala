//
//  Auth.h
//  
//
//  Created by Pallas on 1/7/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface Auth : NSObject {
@private
    NSString *                          _dsPrsID;
    NSString *                          _mmeAuthToken;
}

- (id)init:(NSString*)token;
- (id)init:(NSString*)dsPrsID withMmeAuthToken:(NSString*)mmeAuthToken;

- (NSString*)dsPrsID;
- (NSString *)mmeAuthToken;

@end
