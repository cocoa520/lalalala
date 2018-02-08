//
//  BlobLists.m
//  
//
//  Created by Pallas on 4/11/16.
//
//  Complete

#import "BlobLists.h"
#import "CategoryExtend.h"
#import "BlobUtils.h"

@interface BlobLists ()

@property (nonatomic, readwrite, retain) NSMutableArray *items;

@end

@implementation BlobLists
@synthesize items = _items;

+ (NSMutableArray*)importList:(DataStream*)buffer {
    NSMutableArray *indices = [[NSMutableArray alloc] init];
    
    int index = 0;
    while ((index = [buffer getInt]) + buffer.position != buffer.limit) {
        if (index < 0 || index > buffer.limit) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"bad blob index: %d", index] userInfo:nil];
        }
        [indices addObject:@(index)];
    }
    
    int itemsOffset = buffer.position;
    NSMutableArray *dataArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSNumber *num in indices) {
        index = [num intValue];
        if (index + itemsOffset != buffer.position) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"bad blob data structure" userInfo:nil];
        }
        int itemLength = [buffer getInt];
        NSMutableData *item = [[NSMutableData alloc] initWithSize:itemLength];
        if (item != nil) {
            [buffer getWithMutableData:item];
            [BlobUtils alignWithDataStream:buffer];
            [dataArray addObject:item];
#if !__has_feature(objc_arc)
            [item release]; item = nil;
#endif
        } else {
            @throw [NSException exceptionWithName:@"Alloc" reason:@"alloc NSMutableData failed" userInfo:nil];
        }
    }
#if !__has_feature(objc_arc)
    if (indices) [indices release]; indices = nil;
#endif
    return dataArray;
}

+ (void)exportList:(DataStream*)buffer withDataList:(NSMutableArray*)list {
    int offset = 0;
    for (NSData *data in list) {
        int length = [BlobUtils alignWithIndex:((int)data.length)] + 4;
        [buffer putInt:offset];
        offset += length;
    }
    [buffer putInt:offset];
    
    for (NSData *data in list) {
        [buffer putInt:(int)data.length];
        [buffer putWithData:data];
        [BlobUtils padWithDataStream:buffer];
    }
}

+ (int)exportListSize:(NSMutableArray*)list {
    int sum = 0;
    for (NSData *data in list) {
        int length = (int)data.length;
        sum += [BlobUtils alignWithIndex:length];
    }
    return sum + (int)list.count * 8 + 4;
}

- (id)init:(DataStream *)buffer {
    if (self = [super init]) {
        NSMutableArray *tmpItems = [[NSMutableArray alloc] init];
        [self setItems:tmpItems];
#if !__has_feature(objc_arc)
        [tmpItems release]; tmpItems = nil;
#endif
        
        NSMutableArray *indices = [[NSMutableArray alloc] init];
        
        int index = 0;
        while ((index = [buffer getInt]) + buffer.position != buffer.limit) {
            if (index < 0 || index > buffer.limit) {
                @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"bad blob index: %d", index] userInfo:nil];
            }
            [indices addObject:@(index)];
        }
        
        int itemsOffset = buffer.position;
        for (NSNumber *num in indices) {
            index = [num intValue];
            if (index + itemsOffset != buffer.position) {
                @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"bad blob data structure" userInfo:nil];
            }
            int itemLength = [buffer getInt];
            NSMutableData *item = [[NSMutableData alloc] initWithSize:itemLength];
            if (item != nil) {
                [buffer getWithMutableData:item];
                [BlobUtils alignWithDataStream:buffer];
                [self.items addObject:item];
#if !__has_feature(objc_arc)
                [item release]; item = nil;
#endif
            } else {
                @throw [NSException exceptionWithName:@"Alloc" reason:@"alloc NSMutableData failed" userInfo:nil];
            }
        }
#if !__has_feature(objc_arc)
        if (indices) [indices release]; indices = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_items != nil) [_items release]; _items = nil;
    [super dealloc];
#endif
}

- (int)size {
    return (int)self.items.count;
}

- (NSData*)get:(int)index {
    return [self.items objectAtIndex:index];
}

@end
