//
//  ObjectSignature.m
//  
//
//  Created by Pallas on 7/30/16.
//
//  Complete

#import "ObjectSignature.h"
#import "ASN1Primitive.h"
#import "DER.h"
#import "DERIterator.h"
#import "DERTaggedObject.h"
#import "SignatureInfo.h"
#import "SignatureEx.h"
#import "DERSequence.h"

@interface ObjectSignature ()

@property (nonatomic, readwrite, retain) SignatureInfo *signatureInfo;
@property (nonatomic, readwrite, retain) SignatureEx *signature;

@end

@implementation ObjectSignature
@synthesize signatureInfo = _signatureInfo;
@synthesize signature = _signature;

static int ObjectSignature_SIGNATURE_INFO = 0;
static int ObjectSignature_SIGNATURE = 1;

- (id)initWithSignatureInfo:(SignatureInfo*)signatureInfo withSignature:(SignatureEx*)signature {
    if (self = [super init]) {
        [self setSignatureInfo:signatureInfo];
        [self setSignature:signature];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        NSMutableDictionary *tagged = [i getDerTaggedObjects];
        NSString *infoStr = [NSString stringWithFormat:@"%d", ObjectSignature_SIGNATURE_INFO];
        if ([tagged.allKeys containsObject:infoStr]) {
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
        NSString *signatureStr = [NSString stringWithFormat:@"%d", ObjectSignature_SIGNATURE];
        if ([tagged.allKeys containsObject:signatureStr]) {
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
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_signatureInfo != nil) [_signatureInfo release]; _signatureInfo = nil;
    if (_signature != nil) [_signature release]; _signature = nil;
    [super dealloc];
#endif
}

- (ASN1Primitive*)toASN1Primitive {
    DERTaggedObject *signatureInfoEncodable = nil;
    if ([self signatureInfo] != nil) {
        signatureInfoEncodable = [[DERTaggedObject alloc] initParamInt:ObjectSignature_SIGNATURE_INFO paramASN1Encodable:[self signatureInfo]];
    }
    
    DERTaggedObject *signatureEncodable = nil;
    if ([self signature] != nil) {
        signatureEncodable = [[DERTaggedObject alloc] initParamInt:ObjectSignature_SIGNATURE paramASN1Encodable:[self signature]];
    }
    
    ASN1EncodableVector *vector = nil;
    if (signatureInfoEncodable != nil && signatureEncodable != nil) {
        vector = [DER vector:signatureInfoEncodable, signatureEncodable, nil];
    } else if (signatureInfoEncodable != nil) {
        vector = [DER vector:signatureInfoEncodable, nil];
    } else if (signatureEncodable != nil) {
        vector = [DER vector:signatureEncodable, nil];
    }
    
    DERSequence *retVal = nil;
    if (vector != nil) {
        retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];

    }
#if !__has_feature(objc_arc)
    if (signatureInfoEncodable != nil) [signatureInfoEncodable release]; signatureInfoEncodable = nil;
    if (signatureEncodable != nil) [signatureEncodable release]; signatureEncodable = nil;
#endif
    
    return retVal;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DeviceTimestampSignature{ timestamp = %@, signature = %@ }", [[self signatureInfo] description], [[self signature] description]];
}

@end
