//
//  KeyBagFactory.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "KeyBagFactory.h"
#import "BigInteger.h"
#import "KeyBag.h"
#import "TagLengthValue.h"
#import "PBKDF2.h"
#import "RFC3394Wrap.h"

@implementation KeyBagFactory

static int KeyBagFactory_WRAP_DEVICE = 1;
static int KeyBagFactory_WRAP_PASSCODE = 2;
static int KeyBagFactory_KEK_BITLENGTH = 256;

+ (KeyBag*)createWithData:(NSMutableData*)data withPasscode:(NSMutableData*)passcode {
    return [KeyBagFactory createWithArray:[TagLengthValue parseWithData:data] withPassCode:passcode];
}

+ (KeyBag*)createWithArray:(NSMutableArray*)list withPassCode:(NSMutableData*)passCode {
    if (list.count < 3) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"list too small" userInfo:nil];
    }
    
    NSEnumerator *iterator = [list objectEnumerator];
    TagLengthValue *version = [iterator nextObject];
    if (![[version tag] isEqualToString:@"VERS"] || [KeyBagFactory integer:[version getValue]] != 3) {
        NSLog(@"-- create() - unexpected VERS: %@", version);
    }
    
    TagLengthValue *type = [iterator nextObject];
    if (![[type tag] isEqualToString:@"TYPE"]) {
        NSLog(@"-- create() - unexpected TYPE: %@", type);
    }
    
    KeyBagTypeEnum keyBagType = (KeyBagTypeEnum)[KeyBagFactory integer:[type getValue]];
    if (keyBagType != BACKUP && keyBagType != OTA) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"not a backup keybag" userInfo:nil];
    }
    
    NSMutableArray *blocks = [KeyBagFactory block:iterator];
    NSMutableDictionary *header = (NSMutableDictionary*)[blocks objectAtIndex:0];
    
    NSMutableData *uuid = [header objectForKey:@"UUID"];
    // NSMutableData *hmck = [header objectForKey:@"HMCK"];
    // NSMutableData *wrap = [header objectForKey:@"WRAP"];
    NSMutableData *salt = [header objectForKey:@"SALT"];
    NSMutableData *iter = [header objectForKey:@"ITER"];
    
    NSMutableData *kek = [KeyBagFactory kek:passCode withSalt:salt withIterations:iter];
    
    NSMutableDictionary *publicKeys = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *privateKeys = [[NSMutableDictionary alloc] init];
    
    for (NSMutableDictionary *b in blocks) {
        [KeyBagFactory unlockBlock:kek withBlock:b withPrivateKeys:privateKeys withPublicKeys:publicKeys];
    }
    
    KeyBag *retKB = [[[KeyBag alloc] initWithType:keyBagType withUuid:uuid withPublicKeys:publicKeys withPrivateKeys:privateKeys] autorelease];
#if !__has_feature(objc_arc)
    if (publicKeys != nil) [publicKeys release]; publicKeys = nil;
    if (privateKeys != nil) [privateKeys release]; privateKeys = nil;
#endif
    return retKB;
}

+ (NSMutableArray*)block:(NSEnumerator*)iterator {
    TagLengthValue *uuid = [iterator nextObject];
    if (![[uuid tag] isEqualToString:@"UUID"]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"bad format" userInfo:nil];
    }
    
    NSMutableArray *blocks = [[[NSMutableArray alloc] init] autorelease];
    [KeyBagFactory block:uuid withIterator:iterator withBlocks:blocks];
    return blocks;
}

+ (void)block:(TagLengthValue*)uuid withIterator:(NSEnumerator*)iterator withBlocks:(NSMutableArray*)blocks {
    NSMutableDictionary *tagValues = [[NSMutableDictionary alloc] init];
    [tagValues setObject:[uuid getValue] forKey:[uuid tag]];
    
    TagLengthValue *value = nil;
    while (value = [iterator nextObject]) {
        if ([[value tag] isEqualToString:@"UUID"]) {
            [blocks addObject:tagValues];
            [KeyBagFactory block:value withIterator:iterator withBlocks:blocks];
#if !__has_feature(objc_arc)
            if (tagValues != nil) [tagValues release]; tagValues = nil;
#endif
            return;
        }
        
        [tagValues setObject:[value getValue] forKey:[value tag]];
    }
    [blocks addObject:tagValues];
#if !__has_feature(objc_arc)
    if (tagValues != nil) [tagValues release]; tagValues = nil;
#endif
}

+ (NSMutableData*)kek:(NSMutableData*)passCode withSalt:(NSMutableData*)salt withIterations:(NSMutableData*)iterations {
    NSMutableData *kek = [PBKDF2 generate:passCode withSalt:salt withIterations:[KeyBagFactory integer:iterations] withLengthBits:KeyBagFactory_KEK_BITLENGTH];
    return kek;
}

+ (void)unlockBlock:(NSMutableData*)kek withBlock:(NSMutableDictionary*)block withPrivateKeys:(NSMutableDictionary*)privateKeys withPublicKeys:(NSMutableDictionary*)publicKeys {
    if (![block.allKeys containsObject:@"CLAS"]) {
        return;
    }
    
    int wrap = [KeyBagFactory integer:((NSMutableData*)[block objectForKey:@"WRAP"])];
    int clas = [KeyBagFactory integer:((NSMutableData*)[block objectForKey:@"CLAS"])];
    NSMutableData *wpky = (NSMutableData*)[block objectForKey:@"WPKY"];
    NSMutableData *pbky = (NSMutableData*)[block objectForKey:@"PBKY"];
    
    NSMutableData *key = [KeyBagFactory unwrap:wrap withKek:kek withWpky:wpky];
    if (key != nil && key.length > 0) {
        [privateKeys setObject:key forKey:[NSString stringWithFormat:@"%d", clas]];
    }
    
    [publicKeys setObject:pbky forKey:[NSString stringWithFormat:@"%d", clas]];
}

+ (NSMutableData*)unwrap:(int)wrap withKek:(NSMutableData*)kek withWpky:(NSMutableData*)wpky {
    if ((wrap & KeyBagFactory_WRAP_DEVICE) != 0 || (wrap & KeyBagFactory_WRAP_PASSCODE) == 0) {
        return nil;
    }
    
    NSMutableData *key = [RFC3394Wrap unwrap:kek withWrappedKey:wpky];
    return key;
}

+ (int)integer:(NSMutableData*)bytes {
    BigInteger *bi = [[BigInteger alloc] initWithData:bytes];
    int retVal = [bi intValue];
#if !__has_feature(objc_arc)
    if (bi != nil) [bi release]; bi = nil;
#endif
    return retVal;
}

@end
