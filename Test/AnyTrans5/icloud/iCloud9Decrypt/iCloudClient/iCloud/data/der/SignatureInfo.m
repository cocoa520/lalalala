//
//  SignatureInfo.m
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "SignatureInfo.h"
#import "Arrays.h"
#import "ASN1Integer.h"
#import "ASN1Primitive.h"
#import "ASN1EncodableVector.h"
#import "DERIterator.h"
#import "DER.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "Hex.h"

@interface SignatureInfo ()

@property (nonatomic, readwrite, assign) int version;
@property (nonatomic, readwrite, retain) NSMutableData *info;

@end

@implementation SignatureInfo
@synthesize version = _version;
@synthesize info = _info;

- (id)initWithVersion:(int)version withInfo:(NSMutableData*)info {
    if (self = [super init]) {
        [self setVersion:version];
        NSMutableData *tmpData = [Arrays copyOfWithData:info withNewLength:(int)(info.length)];
        [self setInfo:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        DERIterator *i = [DER asSequence:primitive];
        
        DERIterator *j = [DER asSequence:i];
        
        [self setVersion:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:j] getValue] intValue]];
        [self setInfo:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:j] getOctets]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_info != nil) [_info release]; _info = nil;
    [super dealloc];
#endif
}

- (int)getVersion {
    return _version;
}

- (NSMutableData*)getInfo {
    NSMutableData *retData = nil;
    if ([self info]) {
        retData = [Arrays copyOfWithData:[self info] withNewLength:(int)([self info].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:self.version];
    DEROctetString *infoString = [[DEROctetString alloc] initDEROctetString:[self info]];
    
    ASN1EncodableVector *inner = [DER vector:versionInteger, infoString, nil];
    DERSequence *derSeq = [[DERSequence alloc] initDERParamASN1EncodableVector:inner];
    ASN1EncodableVector *outer = [DER vector:derSeq, nil];
    
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:outer] autorelease];
#if !__has_feature(objc_arc)
    if (versionInteger != nil) [versionInteger release]; versionInteger = nil;
    if (infoString != nil) [infoString release]; infoString = nil;
    if (derSeq != nil) [derSeq release]; derSeq = nil;
#endif
    return retVal;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SignatureInfo{ version = %d, info = %@ }", self.version, [NSString dataToHex:[self info]]];
}

@end
