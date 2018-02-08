//
//  BlobLists.h
//  
//
//  Created by Pallas on 4/11/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class DataStream;

@interface BlobLists : NSObject {
@private
    NSMutableArray *                        _items;
}

+ (NSMutableArray*)importList:(DataStream*)buffer;
+ (void)exportList:(DataStream*)buffer withDataList:(NSMutableArray*)list;
+ (int)exportListSize:(NSMutableArray*)list;

- (id)init:(DataStream *)buffer;

- (int)size;
- (NSMutableData*)get:(int)index;

@end
