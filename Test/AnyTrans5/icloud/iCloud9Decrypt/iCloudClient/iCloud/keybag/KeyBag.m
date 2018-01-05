//
//  KeyBag.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "KeyBag.h"
#import "Arrays.h"
#import "CategoryExtend.h"

@interface KeyBag ()

@property (nonatomic, readwrite, assign) KeyBagTypeEnum type;
@property (nonatomic, readwrite, retain) NSMutableData *uuid;
@property (nonatomic, readwrite, retain) NSString *uuidBase64;
@property (nonatomic, readwrite, retain) NSMutableDictionary *publicKeys;
@property (nonatomic, readwrite, retain) NSMutableDictionary *privateKeys;

@end

@implementation KeyBag
@synthesize type = _type;
@synthesize uuid = _uuid;
@synthesize uuidBase64 = _uuidBase64;
@synthesize publicKeys = _publicKeys;
@synthesize privateKeys = _privateKeys;

- (id)initWithType:(KeyBagTypeEnum)type withUuid:(NSMutableData*)uuid withPublicKeys:(NSMutableDictionary*)publicKeys withPrivateKeys:(NSMutableDictionary*)privateKeys {
    if (self = [super init]) {
        [self setType:type];
        [self setUuid:uuid];
        [self setUuidBase64:[Base64Codec base64StringFromData:uuid]];
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        [self setPublicKeys:tmpDic];
        NSEnumerator *enumerator = [publicKeys keyEnumerator];
        id key = nil;
        while ((key = [enumerator nextObject])) {
            NSMutableData *value = (NSMutableData*)[publicKeys objectForKey:key];
            if (value != nil) {
                NSMutableData *tmpData = [Arrays copyOfWithData:value withNewLength:(int)(value.length)];
                if (tmpData) {
                    [[self publicKeys] setObject:tmpData forKey:key];
#if !__has_feature(objc_arc)
                    if (tmpData) [tmpData release]; tmpData = nil;
#endif
                }
            }
        }
#if !__has_feature(objc_arc)
        if (tmpDic != nil) [tmpDic release]; tmpDic = nil;
#endif
        
        tmpDic = [[NSMutableDictionary alloc] init];
        [self setPrivateKeys:tmpDic];
        enumerator = [privateKeys keyEnumerator];
        key = nil;
        while ((key = [enumerator nextObject])) {
            NSMutableData *value = (NSMutableData*)[privateKeys objectForKey:key];
            if (value != nil) {
                NSMutableData *tmpData = [Arrays copyOfWithData:value withNewLength:(int)(value.length)];
                [[self privateKeys] setObject:tmpData forKey:key];
#if !__has_feature(objc_arc)
                if (tmpData) [tmpData release]; tmpData = nil;
#endif
            }
        }
#if !__has_feature(objc_arc)
        if (tmpDic != nil) [tmpDic release]; tmpDic = nil;
#endif
        
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_uuid != nil) [_uuid release]; _uuid = nil;
    if (_uuidBase64 != nil) [_uuidBase64 release]; _uuidBase64 = nil;
    if (_publicKeys != nil) [_publicKeys release]; _publicKeys = nil;
    if (_privateKeys != nil) [_privateKeys release]; _privateKeys = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)publicKey:(int)protectionClass {
    NSString *protectionClassStr = [NSString stringWithFormat:@"%d", protectionClass];
    if ([[self publicKeys].allKeys containsObject:protectionClassStr]) {
        NSMutableData *value = (NSMutableData*)[[self publicKeys] objectForKey:protectionClassStr];
        if (value != nil) {
            NSMutableData *retData = [Arrays copyOfWithData:value withNewLength:(int)(value.length)];
            return (retData ? [retData autorelease] : nil);
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSMutableData*)privateKey:(int)protectionClass {
    NSString *protectionClassStr = [NSString stringWithFormat:@"%d", protectionClass];
    if ([[self privateKeys].allKeys containsObject:protectionClassStr]) {
        NSMutableData *value = (NSMutableData*)[[self privateKeys] objectForKey:protectionClassStr];
        if (value != nil) {
            NSMutableData *retData = [Arrays copyOfWithData:value withNewLength:(int)(value.length)];
            return (retData ? [retData autorelease] : nil);
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSMutableData*)getUuid {
    NSMutableData *retData = nil;
    if ([self uuid]) {
        retData = [Arrays copyOfWithData:[self uuid] withNewLength:(int)([self uuid].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

@end
