//
//  PZAssistant.m
//
//
//  Created by JGehry on 8/1/16.
//
//
//  Complete

#import "PZAssistant.h"
#import "DERUtils.h"
#import "ECAssistant.h"
#import "EncryptedKeyEx.h"
#import "EncryptedKeys.h"
#import "ECPrivateKeyEx.h"
#import "ECurves.h"
#import "GCMDataA.h"
#import "Key.h"
#import "KeyImports.h"
#import "KeySet.h"
#import "NOS.h"
#import "PZDataUnwrap.h"
#import "ProtectionInfoEx.h"
#import "ProtectionObject.h"
#import "ServiceKeySet.h"
#import "ServiceKeySetBuilder.h"
#import <objc/runtime.h>

@interface PZAssistant ()

@property (nonatomic, readwrite, retain) NSArray *fieldLengthToCurveName;
@property (nonatomic, readwrite, retain) PZDataUnwrap *dataUnwrap;
@property (nonatomic, assign) BOOL useCompactKeys;

@end

@implementation PZAssistant
@synthesize fieldLengthToCurveName = _fieldLengthToCurveName;
@synthesize dataUnwrap = _dataUnwrap;
@synthesize useCompactKeys = _useCompactKeys;

+ (PZAssistant *)instance {
    static PZAssistant *_instance = nil;
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[PZAssistant alloc] initWithfFieldLengthToCurveName:[ECurves defaults] withDataUnwrap:[PZDataUnwrap instance] withUseCompactKeys:YES];
        }
    }
    return _instance;
}

- (id)initWithfFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName withDataUnwrap:(PZDataUnwrap *)dataUnwrap withUseCompactKeys:(BOOL)useCompactKeys {
    self = [super init];
    if (self) {
        if (fieldLengthToCurveName == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"fieldLengthToCurveName" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (dataUnwrap == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"dataUnwrap" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setFieldLengthToCurveName:fieldLengthToCurveName];
        [self setDataUnwrap:dataUnwrap];
        [self setUseCompactKeys:useCompactKeys];
        return self;
    }else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setFieldLengthToCurveName:nil];
    [self setDataUnwrap:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)masterKey:(ProtectionInfoEx*)protectionInfo withKeys:(NSMutableDictionary*)keys {
    return [self masterKeyWithEncryptedKeySet:[[protectionInfo encryptedKeys] getEncryptedKeySet] withKeys:keys];
}

- (NSMutableData*)masterKeyWithEncryptedKeySet:(NSMutableSet*)encryptedKeySet withKeys:(NSMutableDictionary*)keys {
    EncryptedKeyEx *encryptedKey = [self encryptedKey:encryptedKeySet];
    if (encryptedKey != nil) {
        return [self unwrapKey:encryptedKey withKeys:keys];
    }
    return nil;
}

- (EncryptedKeyEx*)encryptedKey:(NSMutableSet*)encryptedKeySet {
    if (encryptedKeySet != nil && encryptedKeySet.count > 0) {
        return [[encryptedKeySet allObjects] objectAtIndex:0];
    }
    return nil;
}

- (NSMutableData*)unwrapKey:(EncryptedKeyEx*)encryptedKey withKeys:(NSMutableDictionary*)keys {
    Key *key = [self importPublicKey:[[encryptedKey getMasterKey] getKey]];
    if (key != nil) {
        Key *privateKey = [keys objectForKey:[key keyID]];
        ECPrivateKeyEx *ecprivateKey = [privateKey keyData];
        return [[self dataUnwrap] apply:[encryptedKey getWrappedKey] withD:[ecprivateKey d]];
    } else {
        return nil;
    }
}

- (Key*)importPublicKey:(NSMutableData*)keyData {
    return [KeyImports importPublicKey:keyData withFieldLengthToCurveName:[self fieldLengthToCurveName] withUseCompactKeys:self.useCompactKeys];
}

- (NSMutableArray*)keysWithProtectionInfo:(ProtectionInfoEx*)protectionInfo withKey:(NSMutableData*)key {
    NSMutableData *data = [protectionInfo getData];
    if (data != nil) {
        return [self keysWithEncryptedProtectionInfoData:data withKey:key];
    }else {
        return nil;
    }
}

- (NSMutableArray*)keysWithEncryptedProtectionInfoData:(NSMutableData*)encryptedProtectionInfoData withKey:(NSMutableData*)key {
    return [self keysWithProtectionInfoData:[GCMDataA decrypt:key withData:encryptedProtectionInfoData]];
}

- (NSMutableArray*)keysWithProtectionInfoData:(NSMutableData*)protectionInfoData {
    SEL selector = @selector(initWithASN1Primitive:);
    Class classType = [ProtectionObject class];
    IMP imp = class_getMethodImplementation(classType, selector);
    id localObject = [DERUtils parseWithData:protectionInfoData withClassType:classType withSel:selector withFunction:imp];
    if (localObject != nil && [localObject isKindOfClass:classType]) {
        ProtectionObject *protectionObject = (ProtectionObject *)localObject;
        return [self keysMasterKeySet:[protectionObject getMasterKeySet]];
    }else {
        return nil;
    }
}

- (NSMutableArray*)keysMasterKeySet:(NSMutableSet*)masterKeySet {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *iterator = [masterKeySet objectEnumerator];
    NOS *nos = nil;
    while (nos = [iterator nextObject]) {
        NSMutableArray *keyArray= [self keys:nos];
        if (keyArray != nil) {
            [returnAry addObjectsFromArray:keyArray];
        }
    }
    return returnAry;
}

- (NSMutableArray*)keys:(NOS*)masterKey {
    NSMutableArray *returnAry = [[[NSMutableArray alloc] init] autorelease];
    SEL selector = @selector(initWithASN1Primitive:);
    Class classType = [KeySet class];
    IMP imp = class_getMethodImplementation(classType, selector);
    id keySet = [DERUtils parseWithData:[masterKey getKey] withClassType:classType withSel:selector withFunction:imp];
    if (keySet && [keySet isKindOfClass:classType]) {
        KeySet *keySets = (KeySet*)keySet;
        [returnAry addObjectsFromArray:[[[ServiceKeySetBuilder buildWithKeySet:keySets] services] allValues]];
    }
    return returnAry;
}

@end
