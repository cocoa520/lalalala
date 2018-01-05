//
//  CKContainer.h
//  
//
//  Created by Pallas on 4/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface CKContainer : NSObject{
@private
    NSString *                  _name;
    NSString *                  _env;
    NSString *                  _ckDeviceUrl;
    NSString *                  _url;
}

- (id)initWithName:(NSString*)name withEnv:(NSString*)env withCkDeviceUrl:(NSString*)ckDeviceUrl withUrl:(NSString*)url;

- (NSString*)name;
- (NSString*)env;
- (NSString*)ckDeviceUrl;
- (NSString*)url;

@end