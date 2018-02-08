//
//  RFC6637KDF.m
//  
//
//  Created by Pallas on 7/28/16.
//
//  Complete

#import "RFC6637KDF.h"
#import "CategoryExtend.h"
#import "ECPoint.h"
#import "ECFieldElement.h"
#import "Digest.h"
#import "Hex.h"
#import "ASN1ObjectIdentifier.h"

@interface RFC6637KDF ()

@property (nonatomic, readwrite, retain) Digest *digestFactory;
@property (nonatomic, readwrite, retain) NSMutableData *formattedOid;
@property (nonatomic, readwrite, assign) Byte publicKeyAlgID;
@property (nonatomic, readwrite, assign) Byte symAlgID;
@property (nonatomic, readwrite, assign) Byte kdfHashID;

@end

@implementation RFC6637KDF
@synthesize digestFactory = _digestFactory;
@synthesize formattedOid = _formattedOid;
@synthesize publicKeyAlgID = _publicKeyAlgID;
@synthesize symAlgID = _symAlgID;
@synthesize kdfHashID = _kdfHashID;

+ (NSMutableData*)ANONYMOUS_SENDER {
    static NSMutableData *_anonymous_sender = nil;
    @synchronized(self) {
        if (_anonymous_sender == nil) {
            _anonymous_sender = [[Hex decodeWithString:@"416E6F6E796D6F75732053656E64657220202020"] retain];
        }
    }
    return _anonymous_sender;
}

- (id)initWithDigest:(Digest*)digestFactory withFormattedOid:(NSMutableData*)formattedOid withPublicKeyAlgID:(Byte)publicKeyAlgID withSymAlgID:(Byte)symAlgID withKdfHashID:(Byte)kdfHashID {
    if (self = [super init]) {
        [self setDigestFactory:digestFactory];
        [self setFormattedOid:formattedOid];
        [self setPublicKeyAlgID:publicKeyAlgID];
        [self setSymAlgID:symAlgID];
        [self setKdfHashID:kdfHashID];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithDigest:(Digest*)digestFactory withOid:(ASN1ObjectIdentifier*)oid withPublicKeyAlgID:(Byte)publicKeyAlgID withSymAlgID:(Byte)symAlgID withKdfHashID:(Byte)kdfHashID {
    if (self = [self initWithDigest:digestFactory withFormattedOid:[RFC6637KDF formatOid:oid] withPublicKeyAlgID:publicKeyAlgID withSymAlgID:symAlgID withKdfHashID:kdfHashID]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_digestFactory != nil) [_digestFactory release]; _digestFactory = nil;
    if (_formattedOid != nil) [_formattedOid release]; _formattedOid = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)apply:(ECPoint*)S withFingerprint:(NSMutableData*)fingerprint {
    NSMutableData *hash = nil;
    @try {
        // RFC Sections 7, 8
        NSMutableData *ZB = [[S affineXCoord] getEncoded];
        
        Digest *digest = [self digestFactory];
        
        [digest update:((Byte)0x00)]; // 00
        [digest update:((Byte)0x00)]; // 00
        [digest update:((Byte)0x00)]; // 00
        [digest update:((Byte)0x01)]; // 01
        [digest blockUpdate:ZB withInOff:0 withLength:(int)(ZB.length)]; // ZB
        
        // Params
        [digest blockUpdate:[self formattedOid] withInOff:0 withLength:(int)([self formattedOid].length)]; // curve_OID_len || curve_OID
        [digest update:self.publicKeyAlgID]; // public_key_alg_ID
        [digest update:((Byte)0x03)]; // 03
        [digest update:((Byte)0x01)]; // 01
        [digest update:self.kdfHashID]; // KDF_hash_ID
        [digest update:self.symAlgID]; // KEK_alg_ID for AESKeyWrap
        [digest blockUpdate:[RFC6637KDF ANONYMOUS_SENDER] withInOff:0 withLength:(int)([RFC6637KDF ANONYMOUS_SENDER].length)]; // "Anonymous Sender"
        [digest blockUpdate:fingerprint withInOff:0 withLength:(int)(fingerprint.length)]; // recipient_fingerprint
        
        hash = [[NSMutableData alloc] initWithSize:[digest getDigestSize]];
        [digest doFinal:hash withOutOff:0];
    }
    @catch (NSException *exception) {
    }
    return (hash ? [hash autorelease] : nil);
}

+ (NSMutableData*)formatOid:(ASN1ObjectIdentifier*)oid {
    @try {
        NSMutableData *encodedOid = [oid getEncoded];
        NSMutableData *formattedOid = [[[NSMutableData alloc] initWithSize:((int)(encodedOid.length) - 1)] autorelease];
        [formattedOid copyFromIndex:0 withSource:encodedOid withSourceIndex:1 withLength:(int)(formattedOid.length)];
        return formattedOid;
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"format OID failed" userInfo:nil];
    }
}

@end
