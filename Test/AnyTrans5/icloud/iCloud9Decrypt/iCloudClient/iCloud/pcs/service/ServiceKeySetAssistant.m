//
//  ServiceKeySetAssistant.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "ServiceKeySetAssistant.h"
#import "Key.h"
#import "KeyID.h"
#import "KeyImports.h"
#import "PrivateKey.h"
#import "PublicKeyInfo.h"

@implementation ServiceKeySetAssistant

+ (NSMutableDictionary*)importPrivateKeys:(NSArray*)keys withFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withUseCompactKeys:(BOOL)useCompactKeys {
    NSMutableDictionary *importedKeys = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = keys.objectEnumerator;
    PrivateKey *value = nil;
    @autoreleasepool {
        while (value = [iterator nextObject]) {
            Key *key = [KeyImports importPrivateKey:value withFieldLengthToCurveName:fieldLengthToCurveName withUseCompactKeys:useCompactKeys];
            if (key != nil) {
                [importedKeys setObject:key forKey:[key keyID]];
            }
        }
    }
    return importedKeys;
}

+ (NSMutableDictionary*)verifyKeys:(NSArray*)privateKeys withMasterKey:(Key*)masterKey {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    if (![masterKey isTrusted]) {
        return retDict;
    }
    NSEnumerator *iterator = [privateKeys objectEnumerator];
    Key *value = nil;
    while (value = [iterator nextObject]) {
        Key *key = nil;
        if ([[value keyID] isEqual:[masterKey keyID]]) {
            key = masterKey;
        } else {
            key = [value verify:masterKey];
        }
        if ([key isTrusted]) {
            [retDict setObject:key forKey:[key keyID]];
        }
    }
    return retDict;
}

+ (NSMutableArray*)untrustedKeys:(NSArray*)privateKeys {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *iterator = [privateKeys objectEnumerator];
    Key *value = nil;
    while (value = [iterator nextObject]) {
        if (![value isTrusted]) {
            [retArray addObject:[value keyID]];
        }
    }
    return retArray;
}

+ (Key*)keyForService:(NSArray*)privateKeys withService:(int)service {
    NSEnumerator *iterator = [privateKeys objectEnumerator];
    Key *value = nil;
    while (value = [iterator nextObject]) {
        NSNumber *num = [value service];
        if (num != nil && [num intValue] == service) {
            return value;
        }
    }
    return nil;
}

+ (NSMutableArray*)unreferencedKeys:(NSDictionary*)serviceKeyIDs withPrivateKeys:(NSDictionary*)privateKeys {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSSet *keyIDs = [NSSet setWithArray:[serviceKeyIDs allValues]];
    NSEnumerator *enumerator = [privateKeys keyEnumerator];
    KeyID *key = nil;
    while ((key = [enumerator nextObject])) {
        if (![keyIDs containsObject:key]) {
            [retArray addObject:[privateKeys objectForKey:key]];
        }
    }
    return retArray;
}

+ (NSMutableDictionary*)serviceKeys:(NSDictionary*)serviceKeyIDs withPrivateKeys:(NSDictionary*)privateKeys {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray *privAllKeys = privateKeys.allKeys;
    NSEnumerator *enumerator = [serviceKeyIDs keyEnumerator];
    NSString *key = nil;
    while ((key = [enumerator nextObject])) {
        KeyID *value = [serviceKeyIDs objectForKey:key];
        for (id obj in  privAllKeys) {
            if ([value isEqual:obj]) {
                [retDict setObject:[privateKeys objectForKey:obj] forKey:key];
                break;
            }
        }
    }
    return retDict;
}

+ (NSMutableDictionary*)incongruentKeys:(NSDictionary*)serviceKeys {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *enumerator = [serviceKeys keyEnumerator];
    NSNumber *key = nil;
    while ((key = [enumerator nextObject])) {
        Key *value = [serviceKeys objectForKey:key];
        int service = [[value publicKeyInfo] service];
        if ([key intValue] != service) {
            [retDict setObject:value forKey:key];
        }
    }
    return retDict;
}

@end
