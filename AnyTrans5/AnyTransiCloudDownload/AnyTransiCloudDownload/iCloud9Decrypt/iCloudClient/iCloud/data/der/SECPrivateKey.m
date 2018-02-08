//
//  SECPrivateKey.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "SECPrivateKey.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "BigInteger.h"
#import "DER.h"
#import "DERIterator.h"
#import "DERBitString.h"
#import "DEROctetString.h"
#import "DERTaggedObject.h"
#import "DERSequence.h"

@interface SECPrivateKey ()

@property (nonatomic, readwrite, assign) int version;
@property (nonatomic, readwrite, retain) NSMutableData *privateKey;
@property (nonatomic, readwrite, retain) NSMutableData *parameters;
@property (nonatomic, readwrite, retain) NSMutableData *publicKey;

@end

@implementation SECPrivateKey
@synthesize version = _version;
@synthesize privateKey = _privateKey;
@synthesize parameters = _parameters;
@synthesize publicKey = _publicKey;

static int SECPrivateKey_PARAMETERS = 0;
static int SECPrivateKey_PUBLIC_KEY = 0;

- (id)initWithVersion:(int)version withPrivateKey:(NSMutableData*)privateKey withParameters:(NSMutableData*)parameters withPublicKey:(NSMutableData*)publicKey {
    if (self = [super init]) {
        [self setVersion:version];
        [self setPrivateKey:privateKey];
        [self setParameters:parameters];
        [self setPublicKey:publicKey];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        NSMutableDictionary *tagged = [i getDerTaggedObjects];
        
        [self setVersion:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        [self setPrivateKey:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        NSArray *allkeys = tagged.allKeys;
        NSString *parametersStr = [NSString stringWithFormat:@"%d", SECPrivateKey_PARAMETERS];
        if ([allkeys containsObject:parametersStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:parametersStr];
            if (asn1Obj != nil) {
                [self setParameters:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:asn1Obj] getOctets]];
            } else {
                [self setParameters:nil];
            }
        } else {
            [self setParameters:nil];
        }
        NSString *keyStr = [NSString stringWithFormat:@"%d", SECPrivateKey_PUBLIC_KEY];
        if ([allkeys containsObject:keyStr]) {
            ASN1Primitive *asn1Obj = (ASN1Primitive*)[tagged objectForKey:keyStr];
            if (asn1Obj != nil) {
                [self setPublicKey:[(DERBitString*)[DER as:[DERBitString class] withEncodable:asn1Obj] getBytes]];
            } else {
                [self setPublicKey:nil];
            }
        } else {
            [self setPublicKey:nil];
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_privateKey != nil) [_privateKey release]; _privateKey = nil;
    if (_parameters != nil) [_parameters release]; _parameters = nil;
    if (_publicKey != nil) [_publicKey release]; _publicKey = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)getPrivateKey {
    NSMutableData *retData = nil;
    if ([self privateKey]) {
        retData = [Arrays copyOfWithData:[self privateKey] withNewLength:(int)([self privateKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getParameters {
    NSMutableData *retData = nil;
    if ([self parameters]) {
        retData = [Arrays copyOfWithData:[self parameters] withNewLength:(int)([self parameters].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getPublicKey {
    NSMutableData *retData = nil;
    if ([self publicKey]) {
        retData = [Arrays copyOfWithData:[self publicKey] withNewLength:(int)([self publicKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ASN1Integer *versionASN1Integer = [[ASN1Integer alloc] initLong:self.version];
    if (versionASN1Integer != nil) {
        [array addObject:versionASN1Integer];
    }
#if !__has_feature(objc_arc)
    if (versionASN1Integer) [versionASN1Integer release]; versionASN1Integer = nil;
#endif
    DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:[self privateKey]];
    if (derOctet != nil) {
        [array addObject:derOctet];
    }
#if !__has_feature(objc_arc)
    if (derOctet != nil) [derOctet release]; derOctet = nil;
#endif
    DERTaggedObject *parametersEncodable = nil;
    NSMutableData *paramData = [self getParameters];
    if (paramData != nil) {
        DEROctetString *derOctet = [[DEROctetString alloc] initDEROctetString:paramData];
        parametersEncodable = [[DERTaggedObject alloc] initParamInt:SECPrivateKey_PARAMETERS paramASN1Encodable:derOctet];
        if (parametersEncodable != nil) {
            [array addObject:parametersEncodable];
        }
#if !__has_feature(objc_arc)
        if (derOctet != nil) [derOctet release]; derOctet = nil;
        if (parametersEncodable != nil) [parametersEncodable release]; parametersEncodable = nil;
#endif
    }
    
    DERTaggedObject *publicKeyEncodable = nil;
    NSMutableData *pubKeyData = [self getPublicKey];
    if (pubKeyData != nil) {
        DERBitString *derBit = [[DERBitString alloc] initDERBitString:pubKeyData];
        publicKeyEncodable = [[DERTaggedObject alloc] initParamInt:SECPrivateKey_PUBLIC_KEY paramASN1Encodable:derBit];
        if (publicKeyEncodable != nil) {
            [array addObject:publicKeyEncodable];
        }
#if !__has_feature(objc_arc)
        if (derBit != nil) [derBit release]; derBit = nil;
        if (publicKeyEncodable != nil) [publicKeyEncodable release]; publicKeyEncodable = nil;
#endif
    }
    
    ASN1EncodableVector *vector = [DER vectorWithArray:array];
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (array != nil) [array release]; array = nil;
#endif
    return retVal;
}

@end
