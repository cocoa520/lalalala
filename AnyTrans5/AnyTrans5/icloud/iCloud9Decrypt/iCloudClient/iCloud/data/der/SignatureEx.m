//
//  Signature.m
//  
//
//  Created by Pallas on 7/29/16.
//
//  Complete

#import "SignatureEx.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "ASN1EncodableVector.h"
#import "DER.h"
#import "DERIterator.h"
#import "DEROctetString.h"
#import "DERSequence.h"
#import "Hex.h"

@interface SignatureEx ()

@property (nonatomic, readwrite, retain) NSMutableData *signerKeyID;
@property (nonatomic, readwrite, assign) int type;
@property (nonatomic, readwrite, retain) NSMutableData *data;

@end

@implementation SignatureEx
@synthesize signerKeyID = _signerKeyID;
@synthesize type = _type;
@synthesize data = _data;

- (id)initWithSignerKeyID:(NSMutableData*)signerKeyID withType:(int)type withData:(NSMutableData*)data {
    if (self = [super init]) {
        NSMutableData *tmpData = [Arrays copyOfWithData:signerKeyID withNewLength:(int)(signerKeyID.length)];
        [self setSignerKeyID:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setType:type];
        tmpData = [Arrays copyOfWithData:data withNewLength:(int)(data.length)];
        [self setData:tmpData];
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
        
        [self setSignerKeyID:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        [self setType:[[(ASN1Integer*)[DER as:[ASN1Integer class] withEncodable:i] getValue] intValue]];
        
        [self setData:[(DEROctetString*)[DER as:[DEROctetString class] withEncodable:i] getOctets]];
        
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_signerKeyID != nil) [_signerKeyID release]; _signerKeyID = nil;
    if (_data != nil) [_data release]; _data = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)getSignerKeyID {
    NSMutableData *retData = nil;
    if ([self signerKeyID]) {
        retData = [Arrays copyOfWithData:[self signerKeyID] withNewLength:(int)([self signerKeyID].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (int)getType {
    return self.type;
}

- (NSMutableData*)getData {
    NSMutableData *retData = nil;
    if ([self data]) {
        retData = [Arrays copyOfWithData:[self data] withNewLength:(int)([self data].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive {
    DEROctetString *signerKeyIDString = [[DEROctetString alloc] initDEROctetString:[self signerKeyID]];
    ASN1Integer *versionInteger = [[ASN1Integer alloc] initLong:self.type];
    DEROctetString *dataString = [[DEROctetString alloc] initDEROctetString:[self data]];
    ASN1EncodableVector *vector = [DER vector:signerKeyIDString, versionInteger, dataString, nil];
    DERSequence *retVal = [[[DERSequence alloc] initDERParamASN1EncodableVector:vector] autorelease];
#if !__has_feature(objc_arc)
    if (signerKeyIDString != nil) [signerKeyIDString release]; signerKeyIDString = nil;
    if (versionInteger != nil) [versionInteger release]; versionInteger = nil;
    if (dataString != nil) [dataString release]; dataString = nil;
#endif
    return retVal;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Signature{ signerKeyID = %@, type = %d, data = %@ }", [NSString dataToHex:[self signerKeyID]], self.type, [NSString dataToHex:[self data]]];
}

@end
