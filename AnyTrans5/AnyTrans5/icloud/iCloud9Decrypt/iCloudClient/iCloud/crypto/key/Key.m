//
//  Key.m
//  
//
//  Created by Pallas on 4/27/16.
//
//  Complete

#import "Key.h"
#import "Arrays.h"
#import "KeyID.h"
#import "PublicKeyInfo.h"

@interface Key ()

@property (nonatomic, readwrite, retain) KeyID *keyID;
@property (nonatomic, readwrite, retain) id keyData;
@property (nonatomic, readwrite, retain) NSMutableData *publicExportData;
@property (nonatomic, readwrite, retain) PublicKeyInfo *publicKeyInfo;
@property (nonatomic, readwrite, assign) BOOL isCompact;
@property (nonatomic, readwrite, assign) BOOL isTrusted;

@end

@implementation Key
@synthesize keyID = _keyID;
@synthesize keyData = _keyData;
@synthesize publicExportData = _publicExportData;
@synthesize publicKeyInfo = _publicKeyInfo;
@synthesize isCompact = _isCompact;
@synthesize isTrusted = _isTrusted;

- (id)initWithKeyID:(KeyID*)keyID withKeyData:(id)keyData withPublicExportData:(NSMutableData*)publicExportData withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact withIsTrusted:(BOOL)isTrusted {
    if (self = [super init]) {
        [self setKeyID:keyID];
        [self setKeyData:keyData];
        [self setPublicExportData:publicExportData];
        [self setPublicKeyInfo:publicKeyInfo];
        [self setIsCompact:isCompact];
        [self setIsTrusted:isTrusted];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithKeyID:(KeyID*)keyID withKeyData:(id)keyData withPublicExportData:(NSMutableData*)publicExportData withPublicKeyInfo:(PublicKeyInfo*)publicKeyInfo withIsCompact:(BOOL)isCompact {
    if (self = [self initWithKeyID:keyID withKeyData:keyData withPublicExportData:publicExportData withPublicKeyInfo:publicKeyInfo withIsCompact:isCompact withIsTrusted:NO]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_keyID != nil) [_keyID release]; _keyID = nil;
    if (_keyData != nil) [_keyData release]; _keyData = nil;
    if (_publicExportData != nil) [_publicExportData release]; _publicExportData = nil;
    if (_publicKeyInfo != nil) [_publicKeyInfo release]; _publicKeyInfo = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)exportPublicData {
    NSMutableData *retData = nil;
    if ([self publicExportData]) {
        retData = [Arrays copyOfWithData:[self publicExportData] withNewLength:(int)([self publicExportData].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSNumber*)service {
    if ([self publicKeyInfo] != nil) {
        return @([[self publicKeyInfo] service]);
    } else {
        return nil;
    }
}

- (Key*)selfVerify {
    return [self verify:self];
}

- (Key*)verify:(Key*)masterKey {
    return [[[Key alloc] initWithKeyID:[self keyID] withKeyData:[self keyData] withPublicExportData:[self publicExportData] withPublicKeyInfo:[self publicKeyInfo] withIsCompact:[self isCompact] withIsTrusted:YES] autorelease];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self retain];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self retain];
}

@end
