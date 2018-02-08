//
//  PZFactory.m
//
//
//  Created by JGehry on 8/2/16.
//
//  Complete

#import "PZFactory.h"
#import "CloudKit.pb.h"
#import "DERUtils.h"
#import "Key.h"
#import "KeyID.h"
#import "ProtectionZone.h"
#import "ProtectionInfoEx.h"
#import "PZAssistant.h"
#import "PZAssistantLight.h"
#import "PZKeyDerivationFunction.h"
#import "PZKeyUnwrap.h"
#import "ProtectionZone.h"
#import "ProtectionInfoEx.h"
#import "CategoryExtend.h"

#import <objc/runtime.h>

@interface PZFactory ()

@property (nonatomic, readwrite, retain) PZKeyDerivationFunction *kdf;
@property (nonatomic, readwrite, retain) PZKeyUnwrap *unwrapKey;
@property (nonatomic, readwrite, retain) PZAssistant *assistant;
@property (nonatomic, readwrite, retain) PZAssistantLight *assistantLight;

@end

@implementation PZFactory
@synthesize kdf = _kdf;
@synthesize unwrapKey = _unwrapKey;
@synthesize assistant = _assistant;
@synthesize assistantLight = _assistantLight;

+ (PZFactory*)instance {
    static PZFactory *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[PZFactory alloc] initWithKdf:[PZKeyDerivationFunction instance] withUnwrapKey:[PZKeyUnwrap instance] withAssistant:[PZAssistant instance] withAssistantLight:[PZAssistantLight instance]];
        }
    }
    return _instance;
}

- (id)initWithKdf:(PZKeyDerivationFunction*)kdf withUnwrapKey:(PZKeyUnwrap*)unwrapKey withAssistant:(PZAssistant*)assistant withAssistantLight:(PZAssistantLight*)assistantLight {
    if (self = [super init]) {
        if (kdf == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"kdf" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (unwrapKey == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"unwrapKey" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (assistant == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"assistant" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (assistantLight == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"assistantLight" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setKdf:kdf];
        [self setUnwrapKey:unwrapKey];
        [self setAssistant:assistant];
        [self setAssistantLight:assistantLight];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setKdf:nil];
    [self setUnwrapKey:nil];
    [self setAssistant:nil];
    [self setAssistantLight:nil];
    [super dealloc];
#endif
}

- (ProtectionZone*)create:(NSMutableArray*)keys {
    return [[[ProtectionZone alloc] initWithPZKeyUnwrap:[self unwrapKey] withMasterKey:nil withDecryptKey:nil withKeys:[self keys:keys] withProtectionTag:@""] autorelease];
}

- (ProtectionZone*)createWithBase:(ProtectionZone*)base withProtectionInfo:(ProtectionInfo*)protectionInfo {
    if ([protectionInfo hasProtectionInfo] && [protectionInfo hasProtectionInfoTag]) {
        NSMutableData *tmpData = [[protectionInfo protectionInfo] mutableCopy];
        ProtectionZone *retPZ = [self createWithKeys:[base getKeys] withProtectionInfoTag:[protectionInfo protectionInfoTag] withProtectionInfoData:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return retPZ;
    }else {
        return nil;
    }
}

- (ProtectionZone*)createWithKeys:(NSMutableDictionary*)keys withProtectionInfoTag:(NSString*)protectionInfoTag withProtectionInfoData:(NSMutableData*)protectionInfoData {
    if ([protectionInfoData length] == 0) {
        return nil;
    }
    return (SignedByte)(((Byte*)(protectionInfoData.bytes))[0]) == -1 ? [self protectionZoneLight:keys withProtectionInfoTag:protectionInfoTag withProtectionInfoData:protectionInfoData] : [self protectionZoneDER:keys withProtectionInfoTag:protectionInfoTag withProtectionInfo:protectionInfoData];
}

- (ProtectionZone*)protectionZoneDER:(NSMutableDictionary*)keys withProtectionInfoTag:(NSString*)protectionInfoTag withProtectionInfo:(NSMutableData*)protectionInfo {
    SEL selector = @selector(initWithASN1Primitive:);
    Class classType = [ProtectionInfoEx class];
    IMP imp = class_getMethodImplementation(classType, selector);
    id pi = [DERUtils parseWithData:protectionInfo withClassType:classType withSel:selector withFunction:imp];
    if (pi && [pi isKindOfClass:classType]) {
        return [self protectionZoneWithKeys:keys withProtectionInfoTag:protectionInfoTag withProtectionInfo:(ProtectionInfoEx*)pi];
    }else {
        return nil;
    }
}

- (ProtectionZone*)protectionZoneWithKeys:(NSMutableDictionary*)keys withProtectionInfoTag:(NSString*)protectionInfoTag withProtectionInfo:(ProtectionInfoEx*)protectionInfo {
    ProtectionZone *retObj = nil;
    @autoreleasepool {
        NSMutableData *masterKey = [[self assistant] masterKey:protectionInfo withKeys:keys];
        NSMutableData *decryptKey = nil;
        if (masterKey != nil) {
            decryptKey = [self.kdf apply:masterKey];
        }
        
        NSMutableDictionary *newKeys = nil;
        BOOL isAlloc = NO;
        if (decryptKey != nil) {
            NSMutableArray *keyArray = [[self assistant] keysWithProtectionInfo:protectionInfo withKey:decryptKey];
            newKeys = [self keys:keyArray];
            if (newKeys == nil) {
                newKeys = [[NSMutableDictionary alloc] init];
                isAlloc = YES;
            }
            [newKeys setValuesForKeysWithDictionary:keys];
        }
        retObj = [[ProtectionZone alloc] initWithPZKeyUnwrap:[self unwrapKey] withMasterKey:[masterKey dataToMutableArray] withDecryptKey:[decryptKey dataToMutableArray] withKeys:newKeys withProtectionTag:protectionInfoTag];
#if !__has_feature(objc_arc)
        if (newKeys != nil && isAlloc) [newKeys release]; newKeys = nil;
#endif
    }
    return (retObj ? [retObj autorelease] : nil);
}

- (ProtectionZone*)protectionZoneLight:(NSMutableDictionary*)keys withProtectionInfoTag:(NSString*)protectionInfoTag withProtectionInfoData:(NSMutableData*)protectionInfoData {
    ProtectionZone *retObj = nil;
    @autoreleasepool {
        NSMutableArray * tmpArray = [[keys allValues] mutableCopy];
        NSMutableData *masterKey = [[self assistantLight] masterKey:protectionInfoData withKeys:tmpArray];
#if !__has_feature(objc_arc)
        if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
        NSMutableData *decryptKey  = nil;
        if (masterKey != nil) {
            decryptKey = [[self kdf] apply:masterKey];
        }
        NSMutableArray *masterKeys = [masterKey dataToMutableArray];
        NSMutableArray *decryptKeys = [decryptKey dataToMutableArray];
        retObj = [[ProtectionZone alloc] initWithPZKeyUnwrap:[self unwrapKey] withMasterKey:masterKeys withDecryptKey:decryptKeys withKeys:keys withProtectionTag:protectionInfoTag];
    }
    return [retObj autorelease];
}

- (NSMutableDictionary*)keys:(NSArray*)keys {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = [keys objectEnumerator];
    Key *key = nil;
    while (key = [iterator nextObject]) {
        [retDict setObject:key forKey:[key keyID]];
    }
    return retDict;
}

@end
