//
//  ECDSASignature.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ECDSASignature.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "ASN1EncodableVector.h"
#import "BigInteger.h"
#import "DERIterator.h"
#import "DER.h"
#import "DERSequence.h"

@interface ECDSASignature ()

@property (nonatomic, readwrite, retain) BigInteger *r;
@property (nonatomic, readwrite, retain) BigInteger *s;

@end

@implementation ECDSASignature
@synthesize r = _r;
@synthesize s = _s;

- (id)initWithR:(BigInteger*)r withS:(BigInteger*)s {
    if (self = [super init]) {
        [self setR:r];
        [self setS:s];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        
        [self setR:[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue]];
        
        [self setS:[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_r != nil) [_r release]; _r = nil;
    if (_s != nil) [_s release]; _s = nil;
    [super dealloc];
#endif
}

- (BigInteger*)getR {
    return [self r];
}

- (BigInteger*)getS {
    return [self s];
}

- (ASN1Primitive*)toASN1Primitive {
    ASN1Integer *rASN1Integer = [[ASN1Integer alloc] initBI:[self getR]];
    ASN1Integer *sASN1Integer = [[ASN1Integer alloc] initBI:[self getS]];
    ASN1EncodableVector *vector = [DER vector:rASN1Integer, sASN1Integer, nil];
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (rASN1Integer != nil) [rASN1Integer release]; rASN1Integer = nil;
    if (sASN1Integer != nil) [sASN1Integer release]; sASN1Integer = nil;
#endif
    return retVal;
}

@end
