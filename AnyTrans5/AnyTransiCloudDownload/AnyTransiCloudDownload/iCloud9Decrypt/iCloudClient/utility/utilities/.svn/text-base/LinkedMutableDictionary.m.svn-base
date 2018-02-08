//
//  LinkedMutableDictionary.m
//  
//
//  Created by iMobie on 8/11/16.
//
//

#import "LinkedMutableDictionary.h"

@interface LinkedMutableDictionary ()

@property (nonatomic, readwrite, retain) NSMutableArray *orderKeys;

@end

@implementation LinkedMutableDictionary
@synthesize orderKeys = _orderKeys;

- (id)init {
    if (self = [super init]) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        [self setOrderKeys:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setOrderKeys:nil];
    [super dealloc];
#endif
}

- (NSArray*)allKeys {
    return [self orderKeys];
}

- (NSArray*)allValues {
    return [super allValues];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    [super setObject:anObject forKeyedSubscript:aKey];
    [[self orderKeys] addObject:aKey];
}

- (void)removeObjectForKey:(id)aKey {
    [super removeObjectForKey:aKey];
    [[self orderKeys] removeObject:aKey];
}

- (void)removeAllObjects {
    [super removeAllObjects];
    [[self orderKeys] removeAllObjects];
}

@end