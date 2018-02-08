//
//  ProtectionInfo.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ProtectionInfoEx.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"
#import "DERApplicationSpecific.h"
#import "EncryptedKeys.h"
#import "TypeData.h"

@interface ProtectionInfoEx ()

@property (nonatomic, readwrite, retain) EncryptedKeys *encryptedKeys;
@property (nonatomic, readwrite, retain) NSMutableData *data;
@property (nonatomic, readwrite, retain) TypeData *signature;
@property (nonatomic, readwrite, retain) NSMutableData *hmac;
@property (nonatomic, readwrite, retain) NSMutableData *tag;
@property (nonatomic, readwrite, retain) NSMutableData *cont3;
@property (nonatomic, readwrite, retain) NSMutableData *cont4;

@end

@implementation ProtectionInfoEx
@synthesize encryptedKeys = _encryptedKeys;
@synthesize data = _data;
@synthesize signature = _signature;
@synthesize hmac = _hmac;
@synthesize tag = _tag;
@synthesize cont3 = _cont3;
@synthesize cont4 = _cont4;

static int ProtectionInfo_DATA = 0;
static int ProtectionInfo_SIGNATURE = 1;
static int ProtectionInfo_TAG = 2;
static int ProtectionInfo_CONT3 = 3;
static int ProtectionInfo_CONT4 = 4;

- (id)initWithEncryptedKeys:(EncryptedKeys*)encryptedKeys withData:(NSMutableData*)data withSignature:(TypeData*)signature withHmac:(NSMutableData*)hmac withTag:(NSMutableData*)tag withCont3:(NSMutableData*)cont3 withCont4:(NSMutableData*)cont4 {
    if (self = [super init]) {
        [self setEncryptedKeys:encryptedKeys];
        [self setData:data];
        [self setSignature:signature];
        [self setHmac:hmac];
        [self setTag:tag];
        [self setCont3:cont3];
        [self setCont4:cont4];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        ASN1Primitive *app = [DER asApplicationSpecific:ProtectionInfo_APPLICATION_TAG withEncodable:primitive];
        DERIterator *i = [DER asSequence:app];
        
        NSMutableDictionary *tagged = [i getDerTaggedObjects];
        
        EncryptedKeys *encKeys = [[EncryptedKeys alloc] initWithASN1Primitive:[i next]];
        [self setEncryptedKeys:encKeys];
#if !__has_feature(objc_arc)
        if (encKeys != nil) [encKeys release]; encKeys = nil;
#endif
        
        [self setHmac:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        NSArray *allkeys = tagged.allKeys;
        NSString *dataStr = [NSString stringWithFormat:@"%d", ProtectionInfo_DATA];
        if (allkeys != nil && [allkeys containsObject:dataStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:dataStr];
            if (asn1Obj != nil) {
                [self setData:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:asn1Obj] getOctets]];
            } else {
                [self setData:nil];
            }
        } else {
            [self setData:nil];
        }
        NSString *signatureStr = [NSString stringWithFormat:@"%d", ProtectionInfo_SIGNATURE];
        if (allkeys != nil && [allkeys containsObject:signatureStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:signatureStr];
            if (asn1Obj != nil) {
                TypeData *tmpTD = [[TypeData alloc] initWithASN1Primitive:asn1Obj];
                [self setSignature:tmpTD];
#if !__has_feature(objc_arc)
                if (tmpTD != nil) [tmpTD release]; tmpTD = nil;
#endif
            } else {
                [self setSignature:nil];
            }
        } else {
            [self setSignature:nil];
        }
        NSString *tagStr = [NSString stringWithFormat:@"%d", ProtectionInfo_TAG];
        if (allkeys != nil && [allkeys containsObject:tagStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:tagStr];
            if (asn1Obj != nil) {
                [self setTag:[(ASN1OctetString*)[DER as:[DEROctetString class] withEncodable:asn1Obj] getOctets]];
            } else {
                [self setTag:nil];
            }
        } else {
            [self setTag:nil];
        }
        NSString *cont3Str = [NSString stringWithFormat:@"%d", ProtectionInfo_CONT3];
        if (allkeys != nil && [allkeys containsObject:cont3Str]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:cont3Str];
            if (asn1Obj != nil) {
                [self setCont3:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:asn1Obj] getOctets]];
            } else {
                [self setCont3:nil];
            }
        } else {
            [self setCont3:nil];
        }
        NSString *cont4Str = [NSString stringWithFormat:@"%d", ProtectionInfo_CONT4];
        if (allkeys != nil && [allkeys containsObject:cont4Str]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:cont4Str];
            if (asn1Obj != nil) {
                [self setCont4:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:asn1Obj] getOctets]];
            } else {
                [self setCont4:nil];
            }
        } else {
            [self setCont4:nil];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_encryptedKeys != nil) [_encryptedKeys release]; _encryptedKeys = nil;
    if (_data != nil) [_data release]; _data = nil;
    if (_signature != nil) [_signature release]; _signature = nil;
    if (_hmac != nil) [_hmac release]; _hmac = nil;
    if (_tag != nil) [_tag release]; _tag = nil;
    if (_cont3 != nil) [_cont3 release]; _cont3 = nil;
    if (_cont4 != nil) [_cont4 release]; _cont4 = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)getData {
    NSMutableData *retData = nil;
    if ([self data]) {
        retData = [Arrays copyOfWithData:[self data] withNewLength:(int)([self data].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getHmac {
    NSMutableData *retData = nil;
    if ([self hmac]) {
        retData = [Arrays copyOfWithData:[self hmac] withNewLength:(int)([self hmac].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getTag {
    NSMutableData *retData = nil;
    if ([self tag]) {
        retData = [Arrays copyOfWithData:[self tag] withNewLength:(int)([self tag].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getCont3 {
    NSMutableData *retData = nil;
    if ([self cont3]) {
        retData = [Arrays copyOfWithData:[self cont3] withNewLength:(int)([self cont3].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getCont4 {
    NSMutableData *retData = nil;
    if ([self cont4]) {
        retData = [Arrays copyOfWithData:[self cont4] withNewLength:(int)([self cont4].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[self encryptedKeys]];
    DERTaggedObject *dataEncodable = nil;
    if ([self data] != nil) {
        DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self data]];
        dataEncodable = [[DERTaggedObject alloc] initParamInt:ProtectionInfo_DATA paramASN1Encodable:derOctet];
        if (dataEncodable != nil) {
            [array addObject:dataEncodable];
        }
#if !__has_feature(objc_arc)
        if (derOctet != nil) [derOctet release]; derOctet = nil;
        if (dataEncodable != nil) [dataEncodable release]; dataEncodable = nil;
#endif
    }
    
    DERTaggedObject *signatureEncodable = nil;
    if ([self signature] != nil) {
        signatureEncodable = [[DERTaggedObject alloc] initParamInt:ProtectionInfo_SIGNATURE paramASN1Encodable:[self signature]];
        if (signatureEncodable != nil) {
            [array addObject:signatureEncodable];
        }
#if !__has_feature(objc_arc)
    if (signatureEncodable) [signatureEncodable release]; signatureEncodable = nil;
#endif
    }
    
    DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self getHmac]];
    if (derOctet != nil) {
        [array addObject:derOctet];
    }
#if !__has_feature(objc_arc)
    if (derOctet != nil) [derOctet release]; derOctet = nil;
#endif
    
    DERTaggedObject *tagEncodable = nil;
    if ([self tag] != nil) {
        DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self tag]];
        tagEncodable = [[DERTaggedObject alloc] initParamInt:ProtectionInfo_TAG paramASN1Encodable:derOctet];
        if (tagEncodable != nil) {
            [array addObject:tagEncodable];
        }
#if !__has_feature(objc_arc)
        if (derOctet != nil) [derOctet release]; derOctet = nil;
        if (tagEncodable != nil) [tagEncodable release]; tagEncodable = nil;
#endif
    }
    
    DERTaggedObject *cont3Encodable = nil;
    if ([self cont3] != nil) {
        DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self cont3]];
        cont3Encodable = [[DERTaggedObject alloc] initParamInt:ProtectionInfo_CONT3 paramASN1Encodable:derOctet];
        if (cont3Encodable != nil) {
            [array addObject:cont3Encodable];
        }
#if !__has_feature(objc_arc)
        if (derOctet != nil) [derOctet release]; derOctet = nil;
        if (cont3Encodable != nil) [cont3Encodable release]; cont3Encodable = nil;
#endif
    }

    DERTaggedObject *cont4Encodable = nil;
    if ([self cont4] != nil) {
        DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self cont4]];
        cont4Encodable = [[DERTaggedObject alloc] initParamInt:ProtectionInfo_CONT4 paramASN1Encodable:derOctet];
        if (cont4Encodable != nil) {
            [array addObject:cont4Encodable];
        }
#if !__has_feature(objc_arc)
        if (derOctet != nil) [derOctet release]; derOctet = nil;
        if (cont4Encodable != nil) [cont4Encodable release]; cont4Encodable = nil;
#endif
    }
    
    ASN1EncodableVector *vector = [DER vectorWithArray:array];
    DERSequence *sequence = [[DERSequence alloc] initParamASN1EncodableVector:vector];
    DERApplicationSpecific *retVal = [DER toApplicationSpecific:ProtectionInfo_APPLICATION_TAG withEncodable:sequence];
#if !__has_feature(objc_arc)
    if (array != nil) [array release]; array = nil;
    if (sequence != nil) [sequence release]; sequence = nil;
#endif
    return retVal;
}

@end
