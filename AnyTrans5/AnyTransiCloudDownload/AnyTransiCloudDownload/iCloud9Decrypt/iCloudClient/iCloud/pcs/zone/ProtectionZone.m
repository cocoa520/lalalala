//
//  ProtectionZone.m
//
//
//  Created by JGehry on 8/1/16.
//
//  Complete

#import "ProtectionZone.h"
#import "Arrays.h"
#import "CategoryExtend.h"
#import "PZKeyUnwrap.h"
#import "GCMDataA.h"

@interface ProtectionZone ()

@property (nonatomic, readwrite, retain) PZKeyUnwrap *unwrapKey;
@property (nonatomic, readwrite, retain) NSMutableArray *masterKey;
@property (nonatomic, readwrite, retain) NSMutableArray *decryptKey;
@property (nonatomic, readwrite, retain) NSMutableDictionary *keys;
@property (nonatomic, readwrite, retain) NSString *protectionTag;

@end

@implementation ProtectionZone
@synthesize unwrapKey = _unwrapKey;
@synthesize masterKey = _masterKey;
@synthesize decryptKey = _decryptKey;
@synthesize keys = _keys;
@synthesize protectionTag = _protectionTag;

- (id)initWithPZKeyUnwrap:(PZKeyUnwrap*)unwrapKey withMasterKey:(NSMutableArray*)masterKey withDecryptKey:(NSMutableArray*)decryptKey withKeys:(NSMutableDictionary*)keys withProtectionTag:(NSString*)protectionTag {
    if (self = [super init]) {
        if (unwrapKey == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"unwrapKey" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (protectionTag == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"protectionTag" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setUnwrapKey:unwrapKey];
        [self setMasterKey:masterKey];
        [self setDecryptKey:decryptKey];
        [self setKeys:[keys mutableDeepCopy]];
        [self setProtectionTag:protectionTag];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setMasterKey:nil];
    [self setDecryptKey:nil];
    [self setKeys:nil];
    [self setProtectionTag:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getKdk {
    NSMutableData *retData = nil;
    if ([self masterKey]) {
        retData = [Arrays copyOfWithData:[[self masterKey] fillToNSMutableData] withNewLength:(int)[self.masterKey count]];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getDk {
    NSMutableData *retData = nil;
    if ([self decryptKey]) {
        retData = [Arrays copyOfWithData:[[self decryptKey] fillToNSMutableData] withNewLength:(int)[self.decryptKey count]];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)decrypt:(NSMutableData*)data identifierWithString:(NSString*)identifier {
    NSMutableData *tmpData = [[identifier dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSMutableData *retData = [self decrypt:data identifierWithMutableData:tmpData];
#if !__has_feature(objc_arc)
    if (tmpData) [tmpData release]; tmpData = nil;
#endif
    return retData;
}

- (NSMutableData*)decrypt:(NSMutableData*)data identifierWithMutableData:(NSMutableData*)identifier {
    if ([self decryptKey] != nil) {
        NSMutableData *returnData = nil;
        for (NSMutableData *tmpData in [self decryptKey]) {
            returnData = [GCMDataA decrypt:tmpData withData:data withOptional:identifier];
            break;
        }
        return returnData;
    }else {
        return nil;
    }
}

- (NSMutableData*)unwrapKey:(NSMutableData*)wrappedKey {
    if ([self masterKey] != nil && [self unwrapKey] != nil) {
        NSMutableData *returnData = nil;
        for (NSMutableData *tmpData in [self masterKey]) {
            returnData = [[self unwrapKey] apply:tmpData withWrappedKey:wrappedKey];
            break;
        }
        return returnData;
    }
    return nil;
}

- (NSMutableDictionary*)getKeys {
    return [[[NSMutableDictionary alloc] initWithDictionary:[self keys]] autorelease];
}

- (NSMutableArray*)keyList {
    return [[[NSMutableArray alloc] initWithArray:[[self keys] allValues]] autorelease];
}

@end
