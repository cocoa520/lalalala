//
//  KeyBags.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "KeyBags.h"
#import "KeyBag.h"
#import "CategoryExtend.h"

@interface KeyBags ()

@property (nonatomic, readwrite, retain) NSMutableDictionary *keyBags;

@end

@implementation KeyBags
@synthesize keyBags = _keyBags;

+ (NSMutableDictionary*)keyBags:(NSArray*)keyBags {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    for (KeyBag *keybag in keyBags) {
        [retDict setObject:keybag forKey:[NSString dataToHex:[keybag getUuid]]];
    }
    return retDict;
}

- (id)initWithDictionary:(NSDictionary*)keyBags {
    if (self = [super init]) {
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithDictionary:keyBags];
        [self setKeyBags:tmpDict];
#if !__has_feature(objc_arc)
        if (tmpDict != nil) [tmpDict release]; tmpDict = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (id)initWithArray:(NSArray*)keyBags {
    NSMutableDictionary *tmpkeybags = [KeyBags keyBags:keyBags];
    if (tmpkeybags == nil) {
        return nil;
    }
    if (self = [self initWithDictionary:tmpkeybags]) {
        return self;
    } else {
        return nil;
    }
}

- (id)initWithKeybag:(KeyBag*)keyBag,... {
    NSMutableArray *argArray = [[NSMutableArray alloc] init];
    va_list argList;
    KeyBag *arg = nil;
    if (keyBag != nil) {
        va_start(argList, keyBag);
        [argArray addObject:keyBag];
        while((arg = va_arg(argList, KeyBag*))) {
            [argArray addObject:arg];
        }
        va_end(argList);
    }

    if (self = [self initWithArray:argArray]) {
#if !__has_feature(objc_arc)
        if (argArray != nil) [argArray release]; argArray = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (argArray != nil) [argArray release]; argArray = nil;
#endif
        return nil;
    }
}

- (KeyBag*)keybag:(NSData*)uuid {
    if ([[self keyBags].allKeys containsObject:uuid]) {
        return [[self keyBags] objectForKey:uuid];
    } else {
        return nil;
    }
}

- (NSMutableArray*)getKeyBags {
    return [[[NSMutableArray alloc] initWithArray:[[self keyBags] allValues]] autorelease];
}

@end
