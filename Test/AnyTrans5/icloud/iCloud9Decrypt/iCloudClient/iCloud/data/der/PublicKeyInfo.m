//
//  PublicKeyInfo.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "PublicKeyInfo.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "BigInteger.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "DERApplicationSpecific.h"
#import "Hex.h"
#import "SignatureInfo.h"
#import "SignatureEx.h"
#import "ObjectSignature.h"

@interface PublicKeyInfo ()

@property (nonatomic, readwrite, assign) int service;
@property (nonatomic, readwrite, assign) int type;
@property (nonatomic, readwrite, retain) NSMutableData *key;
@property (nonatomic, readwrite, retain) SignatureInfo *signatureInfo;
@property (nonatomic, readwrite, retain) SignatureEx *signature;
@property (nonatomic, readwrite, retain) ObjectSignature *extendedSignature;

@end

@implementation PublicKeyInfo
@synthesize service = _service;
@synthesize type = _type;
@synthesize key = _key;
@synthesize signatureInfo = _signatureInfo;
@synthesize signature = _signature;
@synthesize extendedSignature = _extendedSignature;

static int PublicKeyInfo_SIGNATURE_INFO = 0;
static int PublicKeyInfo_SIGNATURE = 1;
static int PublicKeyInfo_EXTENDED_SIGNATURE = 2;

- (id)initWithService:(int)service withType:(int)type withKey:(NSMutableData*)key withSignatureInfo:(SignatureInfo*)signatureInfo withSignature:(SignatureEx*)signature withExtendedSignature:(ObjectSignature*)extendedSignature {
    if (self = [super init]) {
        [self setService:service];
        [self setType:type];
        [self setKey:key];
        [self setSignatureInfo:signatureInfo];
        [self setSignature:signature];
        [self setExtendedSignature:extendedSignature];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        ASN1Primitive *app = [DER asApplicationSpecific:PublicKeyInfo_APPLICATION_TAG withEncodable:primitive];
        
        DERIterator *i = [DER asSequence:app];
        NSMutableDictionary *tagged = [i getDerTaggedObjects];
        
        [self setService:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        [self setType:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        [self setKey:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        NSArray *allkeys = tagged.allKeys;
        NSString *infoStr = [NSString stringWithFormat:@"%d", PublicKeyInfo_SIGNATURE_INFO];
        if ([allkeys containsObject:infoStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:infoStr];
            if (asn1Obj != nil) {
                SignatureInfo *tmpSI = [[SignatureInfo alloc] initWithASN1Primitive:asn1Obj];
                [self setSignatureInfo:tmpSI];
#if !__has_feature(objc_arc)
                if (tmpSI != nil) [tmpSI release]; tmpSI = nil;
#endif
            } else {
                [self setSignatureInfo:nil];
            }
        } else {
            [self setSignatureInfo:nil];
        }
        NSString *signatureStr = [NSString stringWithFormat:@"%d", PublicKeyInfo_SIGNATURE];
        if ([allkeys containsObject:signatureStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:signatureStr];
            if (asn1Obj != nil) {
                SignatureEx *tmpS = [[SignatureEx alloc] initWithASN1Primitive:asn1Obj];
                [self setSignature:tmpS];
#if !__has_feature(objc_arc)
                if (tmpS != nil) [tmpS release]; tmpS = nil;
#endif
            } else {
                [self setSignature:nil];
            }
        } else {
            [self setSignature:nil];
        }
        NSString *extendedSignatureStr = [NSString stringWithFormat:@"%d", PublicKeyInfo_EXTENDED_SIGNATURE];
        if ([allkeys containsObject:extendedSignatureStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:extendedSignatureStr];
            if (asn1Obj != nil) {
                ObjectSignature *tmpOS = [[ObjectSignature alloc] initWithASN1Primitive:asn1Obj];
                [self setExtendedSignature:tmpOS];
#if !__has_feature(objc_arc)
                if (tmpOS != nil) [tmpOS release]; tmpOS = nil;
#endif
            } else {
                [self setExtendedSignature:nil];
            }
        } else {
            [self setExtendedSignature:nil];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_key != nil) [_key release]; _key = nil;
    if (_signatureInfo != nil) [_signatureInfo release]; _signatureInfo = nil;
    if (_signature != nil) [_signature release]; _signature = nil;
    if (_extendedSignature != nil) [_extendedSignature release]; _extendedSignature = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)getKey {
    NSMutableData *retData = nil;
    if ([self key]) {
        retData = [Arrays copyOfWithData:[self key] withNewLength:(int)([self key].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (SignatureInfo*)buildAndTime {
    return [self signatureInfo];
}

- (ASN1Primitive*)toASN1Primitive {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ASN1Integer *serviceASN1Integer = [[ASN1Integer alloc] initLong:self.service];
    if (serviceASN1Integer != nil) {
        [array addObject:serviceASN1Integer];
    }
#if !__has_feature(objc_arc)
    if (serviceASN1Integer != nil) [serviceASN1Integer release]; serviceASN1Integer = nil;
#endif
    ASN1Integer *typeASN1Integer = [[ASN1Integer alloc] initLong:self.type];
    if (typeASN1Integer != nil) {
        [array addObject:typeASN1Integer];
    }
#if !__has_feature(objc_arc)
    if (typeASN1Integer != nil) [typeASN1Integer release]; typeASN1Integer = nil;
#endif
    DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self getKey]];
    if (derOctet != nil) {
        [array addObject:derOctet];
    }
#if !__has_feature(objc_arc)
    if (derOctet != nil) [derOctet release]; derOctet = nil;
#endif
    DERTaggedObject *signatureInfoEncodable = nil;
    if ([self signatureInfo] != nil) {
        signatureInfoEncodable = [[DERTaggedObject alloc] initParamInt:PublicKeyInfo_SIGNATURE_INFO paramASN1Encodable:[self signatureInfo]];
        if (signatureInfoEncodable != nil) {
            [array addObject:signatureInfoEncodable];
        }
#if !__has_feature(objc_arc)
        if (signatureInfoEncodable != nil) [signatureInfoEncodable release]; signatureInfoEncodable = nil;
#endif
    }
    
    DERTaggedObject *signatureEncodable = nil;
    if ([self signature] != nil) {
        signatureEncodable = [[DERTaggedObject alloc] initParamInt:PublicKeyInfo_SIGNATURE paramASN1Encodable:[self signature]];
        if (signatureEncodable != nil) {
            [array addObject:signatureEncodable];
        }
#if !__has_feature(objc_arc)
        if (signatureEncodable != nil) [signatureEncodable release]; signatureEncodable = nil;
#endif
    }
    
    DERTaggedObject *extendedSignatureEncodable = nil;
    if ([self extendedSignature] != nil) {
        extendedSignatureEncodable = [[DERTaggedObject alloc] initParamInt:PublicKeyInfo_EXTENDED_SIGNATURE paramASN1Encodable:[self extendedSignature]];
        if (extendedSignatureEncodable != nil) {
            [array addObject:extendedSignatureEncodable];
        }
#if !__has_feature(objc_arc)
        if (extendedSignatureEncodable != nil) [extendedSignatureEncodable release]; extendedSignatureEncodable = nil;
#endif
    }
    
    ASN1EncodableVector *vector = [DER vectorWithArray:array];
    DERSequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:vector];
    DERApplicationSpecific *retVal = [DER toApplicationSpecific:PublicKeyInfo_APPLICATION_TAG withEncodable:sequence];
#if !__has_feature(objc_arc)
    if (array != nil) [array release]; array = nil;
    if (sequence != nil) [sequence release]; sequence = nil;
#endif
    return retVal;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"PublicKeyInfo{ id = %d, type = %d, key = %@, buildAndTime = %@, signature = %@, extendedSignature = %@ }", self.service, self.type, [NSString dataToHex:[self key]], [[self signatureInfo] description], [[self signature] description], [[self extendedSignature] description]];
}

@end
