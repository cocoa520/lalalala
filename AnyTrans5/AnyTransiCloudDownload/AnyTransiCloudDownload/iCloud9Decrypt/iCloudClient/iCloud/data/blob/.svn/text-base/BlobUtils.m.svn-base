//
//  BlobUtils.m
//  
//
//  Created by Pallas on 4/13/16.
//
//  Complete

#import "BlobUtils.h"
#import "CategoryExtend.h"

@implementation BlobUtils

+ (int)alignWithIndex:(int)index {
    return index + 3 & 0xFFFFFFFC;
}

+ (void)alignWithDataStream:(DataStream*)blob {
    [blob setPosition:[self alignWithIndex:[blob position]]] ;
}

+ (void)padWithDataStream:(DataStream*)blob {
    for (int i = [blob position]; i < [self alignWithIndex:[blob position]]; i++) {
        [blob put:(Byte) 0x00];
    }
}

+ (int)typeWithDataStream:(DataStream*)blob {
    if ([blob limit] < 8) {
        return -2;
    }
    
    int type = [blob getInt] == [blob limit] ? [blob getInt] : -1;
    
    [blob rewind];
    return type;
}

@end
