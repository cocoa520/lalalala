//
//  KeyBagManager.m
//  
//
//  Created by iMobie on 8/1/16.
//
//  Complete

#import "KeyBagManager.h"
#import "AssetEx.h"
#import "CloudKitty.h"
#import "CategoryExtend.h"
#import "ProtectionZone.h"
#import "FileKeyAssistant.h"
#import "KeyBag.h"
#import "KeyBagClient.h"

@interface KeyBagManager ()

@property (nonatomic, readwrite, retain) CloudKitty *kitty;
@property (nonatomic, readwrite, retain) ProtectionZone *mbksync;
@property (nonatomic, readwrite, retain) NSMutableDictionary *keyBagDict;

@end

@implementation KeyBagManager
@synthesize kitty = _kitty;
@synthesize mbksync = _mbksync;
@synthesize keyBagDict = _keyBagDict;

+ (KeyBagManager*)create:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync {
    return [[[KeyBagManager alloc] initWithKitty:kitty withMbksync:mbksync] autorelease];
}

- (KeyBag*)keyBag:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync withUuid:(NSString*)uuid {
    @try {
        return [KeyBagClient keyBag:kitty zone:mbksync keyBagUUID:uuid];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
}

+ (KeyBag*)FAIL {
    static KeyBag *_fail = nil;
    @synchronized(self) {
        if (_fail == nil) {
            NSMutableData *emptyData = [[NSMutableData alloc] init];
            NSMutableDictionary *emptyDict = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *emptyDict1 = [[NSMutableDictionary alloc] init];
            _fail = [[KeyBag alloc] initWithType:BACKUP withUuid:emptyData withPublicKeys:emptyDict withPrivateKeys:emptyDict1];
#if !__has_feature(objc_arc)
            if (emptyData != nil) [emptyData release]; emptyData = nil;
            if (emptyDict != nil) [emptyDict release]; emptyDict = nil;
            if (emptyDict1 != nil) [emptyDict1 release]; emptyDict1 = nil;
#endif
        }
    }
    return _fail;
}

- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync withKeyBagDict:(NSMutableDictionary*)keyBagDict {
    if (self = [super init]) {
        [self setKitty:kitty];
        [self setMbksync:mbksync];
        [self setKeyBagDict:keyBagDict];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithKitty:(CloudKitty*)kitty withMbksync:(ProtectionZone*)mbksync {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    if (self = [self initWithKitty:kitty withMbksync:mbksync withKeyBagDict:tmpDict]) {
#if !__has_feature(objc_arc)
        if (tmpDict != nil) [tmpDict release]; tmpDict = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (tmpDict != nil) [tmpDict release]; tmpDict = nil;
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setKitty:nil];
    [self setMbksync:nil];
    [self setKeyBagDict:nil];
    [super dealloc];
#endif
}

- (KeyBagManager*)addKeyBags:(KeyBag*)keyBag,... {
    va_list argList;
    KeyBag *arg = nil;
    if (keyBag != nil) {
        va_start(argList, keyBag);
        [[self keyBagDict] setObject:keyBag forKey:[keyBag uuidBase64]];
        while((arg = va_arg(argList, KeyBag*))) {
            [[self keyBagDict] setObject:arg forKey:[arg uuidBase64]];
        }
        va_end(argList);
    }
    return self;
}

- (NSMutableArray*)keyBags {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray *allValues = [[self keyBagDict] allValues];
    NSEnumerator *iterator = [allValues objectEnumerator];
    KeyBag *value = nil;
    while (value = [iterator nextObject]) {
        if (value != [KeyBagManager FAIL]) {
            [retArray addObject:value];
        }
    }
    return retArray;
}

- (KeyBag*)keyBag:(NSData*)uuid {
    NSString *encoded = [Base64Codec base64StringFromData:uuid];
    return [self keyBagWithString:encoded];
}

- (KeyBag*)keyBagWithString:(NSString*)uuid {
    KeyBag *keyBag = [[self keyBagDict].allKeys containsObject:uuid] ? [[self keyBagDict] objectForKey:uuid] : [KeyBagManager FAIL];
    if (keyBag == [KeyBagManager FAIL]) {
        NSLog(@"-- keyBag() - no key bag for uuid: %@", uuid);
    }
    
    return keyBag == [KeyBagManager FAIL] ? nil : keyBag;
}

- (KeyBagManager*)update:(NSArray*)assets withCancel:(BOOL*)cancel {
    if (*cancel) {
        return self;
    }
    NSMutableSet *set = [self keyBagUUIDs:assets withCancel:cancel];
    NSEnumerator *iterator = [set objectEnumerator];
    NSString *uuid = nil;
    while (uuid = [iterator nextObject]) {
        if (*cancel) {
            return self;
        }
        if (![[self keyBagDict].allKeys containsObject:uuid]) {
            KeyBag *keyBag = [self fetchKeyBag:uuid];
            if (keyBag != nil) {
                [[self keyBagDict] setObject:keyBag forKey:uuid];
            }
        }
    }
    return self;
}

- (KeyBag*)fetchKeyBag:(NSString*)uuid {
    KeyBag *keyBag = [self keyBag:[self kitty] withMbksync:[self mbksync] withUuid:uuid];
    return keyBag != nil ? keyBag : [KeyBagManager FAIL];
}

- (NSMutableSet*)keyBagUUIDs:(NSArray*)assets withCancel:(BOOL*)cancel {
    NSMutableSet *retSet = [[[NSMutableSet alloc] init] autorelease];
    NSEnumerator *iterator = [assets objectEnumerator];
    AssetEx *asset = nil;
    while (asset = [iterator nextObject]) {
        if (*cancel) {
            break;
        }
        NSMutableData *encKey = [asset getEncryptionKey];
        if (encKey != nil) {
            NSMutableData *uuid = [FileKeyAssistant uuid:encKey];
            if (uuid != nil) {
                NSString *uuidStr = [Base64Codec base64StringFromData:uuid];
                if (![NSString isNilOrEmpty:uuidStr]) {
                    [retSet addObject:uuidStr];
                }
            }
        }
    }
    return retSet;
}

@end
