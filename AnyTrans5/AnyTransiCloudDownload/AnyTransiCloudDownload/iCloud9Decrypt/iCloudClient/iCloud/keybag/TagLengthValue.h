//
//  TagLengthValue.h
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class DataStream;

@interface TagLengthValue : NSObject {
@private
    NSString *                              _tag;
    NSMutableData *                         _value;
}

- (NSString*)tag;

+ (NSMutableArray*)parseWithData:(NSMutableData*)data;
+ (NSMutableArray*)parseWithDataStream:(DataStream*)buffer;

- (int)length;
- (NSMutableData*)getValue;

@end
