//
//  MobileMe.h
//  
//
//  Created by Pallas on 4/11/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface MobileMe : NSObject {
@private
    NSDictionary *                  _mobileMe;
}

- (id)init:(NSDictionary*)mobileMe_;

- (id)get:(NSString*)domain withKey:(NSString*)key;

@end
