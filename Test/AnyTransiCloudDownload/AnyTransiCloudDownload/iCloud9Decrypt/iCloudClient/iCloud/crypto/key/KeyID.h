//
//  KeyID.h
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import <Foundation/Foundation.h>

@interface KeyID : NSObject <NSCopying> {
@private
    NSMutableData *                             _kID;
}

+ (KeyID*)importKeyID:(NSMutableData*)data;
+ (KeyID*)of:(NSMutableData*)publicExportData;

- (NSMutableData*)bytes;

@end
