//
//  MapAssistant.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "MapAssistant.h"

@implementation MapAssistant

+ (NSMutableDictionary*)invertDictionary:(NSDictionary*)dictionary {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = [dictionary keyEnumerator];
    id key = nil;
    while (key = [iterator nextObject]) {
        id value = [dictionary objectForKey:key];
        for (id obj in value) {
            [retDict setObject:key forKey:obj];
        }
    }
    return retDict;
}

@end
