//
//  KeySet.m
//  
//
//  Created by Pallas on 7/27/16.
//
//  Complete

#import "KeySet.h"
#import "Arrays.h"
#import "ASN1Primitive.h"
#import "ASN1Integer.h"
#import "BigInteger.h"
#import "CategoryExtend.h"
#import "Digest.h"
#import "DER.h"
#import "DERIterator.h"
#import "DERUTF8String.h"
#import "DEROctetString.h"
#import "DERApplicationSpecific.h"
#import "Sha256Digest.h"
#import "SignatureInfo.h"
#import "DERSequence.h"
#import "PrivateKey.h"
#import "TypeData.h"
#import "DLSet.h"
#import <objc/runtime.h>

@interface KeySet ()

@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite, retain) NSMutableSet *keys;
@property (nonatomic, readwrite, retain) NSMutableSet *serviceKeyIDs;
@property (nonatomic, readwrite, retain) NSMutableData *checksum;
@property (nonatomic, readwrite, retain) NSNumber *flags;
@property (nonatomic, readwrite, retain) SignatureInfo *signatureInfo;

@end

@implementation KeySet
@synthesize name = _name;
@synthesize keys = _keys;
@synthesize serviceKeyIDs = _serviceKeyIDs;
@synthesize checksum = _checksum;
@synthesize flags = _flags;
@synthesize signatureInfo = _signatureInfo;


+ (Digest*)DIGEST {
    static Digest *_digest = nil;
    @synchronized(self) {
        if (!_digest) {
            _digest = [[Sha256Digest alloc] init];
        }
    }
    return _digest;
}

- (id)initWithName:(NSString*)name withKeys:(NSSet*)keys withServices:(NSSet*)services withChecksum:(NSMutableData*)checksum withFlags:(NSNumber*)flags withSignatureInfo:(SignatureInfo*)signatureInfo {
    if (self = [super init]) {
        [self setName:name];
        [self setKeys:[NSMutableSet setWithSet:keys]];
        [self setServiceKeyIDs:[NSMutableSet setWithSet:services]];
        NSMutableData *tmpData = [Arrays copyOfWithData:checksum withNewLength:(int)(checksum.length)];
        [self setChecksum:tmpData];
#if !__has_feature(objc_arc)
        if (tmpData) [tmpData release]; tmpData = nil;
#endif
        [self setFlags:flags];
        [self setSignatureInfo:signatureInfo];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithName:(NSString*)name withKeys:(NSSet*)keys withServices:(NSSet*)services withFlags:(NSNumber*)flags withSignatureInfo:(SignatureInfo*)signatureInfo {
    if (self = [super init]) {
        [self setName:name];
        [self setKeys:[NSMutableSet setWithSet:keys]];
        [self setServiceKeyIDs:[NSMutableSet setWithSet:services]];
        [self setFlags:flags];
        [self setSignatureInfo:signatureInfo];
        [self setChecksum:[self calculateChecksum]];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithASN1Primitive:(ASN1Primitive*)primitive {
    if (self = [super init]) {
        @autoreleasepool {
            ASN1Primitive *app = [DER asApplicationSpecific:KeySet_APPLICATION_TAG withEncodable:primitive];
            DERIterator *i = [DER asSequence:app];
            
            [self setName:[(DERUTF8String*)[DER as:[DERUTF8String class] withEncodable:i] getString]];
            
            SEL selector = @selector(initWithASN1Primitive:);
            Class classType = [PrivateKey class];
            IMP imp = class_getMethodImplementation(classType, selector);
            [self setKeys:[DER asSet:i withClassType:classType withSel:selector withFunction:imp]];
            selector = @selector(initWithASN1Primitive:);
            classType = [TypeData class];
            imp = class_getMethodImplementation(classType, selector);
            [self setServiceKeyIDs:[DER asSet:i withClassType:classType withSel:selector withFunction:imp]];
            
            NSMutableData *tmpChecksum = nil;
            id derOctetObj = [i nextIf:[DEROctetString class]];
            if (derOctetObj != nil) {
                tmpChecksum = [(DEROctetString*)derOctetObj getOctets];
            }
            
            id asn1IntegerObj = [i nextIf:[ASN1Integer class]];
            if (asn1IntegerObj != nil) {
                [self setFlags:@([[(ASN1Integer*)asn1IntegerObj getValue] intValue])];
            } else {
                [self setFlags:nil];
            }
            
            ASN1Primitive *asn1Obj = [i next];
            if (asn1Obj != nil) {
                SignatureInfo *sigInfo = [[SignatureInfo alloc] initWithASN1Primitive:asn1Obj];
                [self setSignatureInfo:sigInfo];
#if !__has_feature(objc_arc)
                if (sigInfo != nil) [sigInfo release]; sigInfo = nil;
#endif
            }
            
            [self setChecksum:[self calculateChecksum]];
        }
        
//        if (tmpChecksum != nil) {
//            BOOL match = [Arrays areEqualWithByteArray:tmpChecksum withB:[self checksum]];
//            if (match) {
//                NSLog(@"** KeySet() - checksums match");
//            } else {
//                NSLog(@"** KeySet()  - bad checksum OR code failure");
//            }
//        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_name != nil) [_name release]; _name = nil;
    if (_keys != nil) [_keys release]; _keys = nil;
    if (_serviceKeyIDs != nil) [_serviceKeyIDs release]; _serviceKeyIDs = nil;
    if (_checksum != nil) [_checksum release]; _checksum = nil;
    if (_flags != nil) [_flags release]; _flags = nil;
    if (_signatureInfo != nil) [_signatureInfo release]; _signatureInfo = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)calculateChecksum {
    @try {
        // Re-encode the data minus the supplied checksum then calculate SHA256 hash.
        // This should match the supplied checksum.
        // Verifies data integrity AND our decode/ encode processes
        NSMutableData *contents = [[self toASN1Primitive:NO] getEncoded];
        
        Digest *digest = [KeySet DIGEST];
        NSMutableData *calculatedChecksum = [[[NSMutableData alloc] initWithSize:[digest getDigestSize]] autorelease];
        [digest blockUpdate:contents withInOff:0 withLength:(int)(contents.length)];
        [digest doFinal:calculatedChecksum withOutOff:0];
        
        return calculatedChecksum;
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:[exception reason] userInfo:nil];
    }
}

- (NSMutableSet*)getKeys {
    return [[[NSMutableSet alloc] initWithSet:[self keys]] autorelease];
}

- (NSMutableSet*)getServiceKeyIDs {
    return [[[NSMutableSet alloc] initWithSet:[self serviceKeyIDs]] autorelease];
}

- (NSMutableData*)getChecksum {
    NSMutableData *retData = nil;
    if ([self checksum]) {
        retData = [Arrays copyOfWithData:[self checksum] withNewLength:(int)([self checksum].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (ASN1Primitive*)toASN1Primitive:(BOOL)includeChecksum {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    DERUTF8String *derUTF8 = [[DERUTF8String alloc] initParamString:[self name]];
    if (derUTF8 != nil) {
        [array addObject:derUTF8];
    }
    
    DERSet *derKeysSet = [DER toSet:[self keys]];
    if (derKeysSet != nil) {
        [array addObject:derKeysSet];
    }
    
    DERSet *servKeyIDsSet = [DER toSet:[self serviceKeyIDs]];
    if (servKeyIDsSet != nil) {
        [array addObject:servKeyIDsSet];
    }
    
    DEROctetString *checksumEncodable = nil;
    if (includeChecksum) {
        checksumEncodable = [[DEROctetString alloc] initDEROctetString:[self getChecksum]];
        if (checksumEncodable != nil) {
            [array addObject:checksumEncodable];
        }
    }
    
    ASN1Integer *flagsEncodable = nil;
    if ([self flags] != nil) {
        flagsEncodable = [[ASN1Integer alloc] initLong:[[self flags] intValue]];
        if (flagsEncodable != nil) {
            [array addObject:flagsEncodable];
        }
    }
    
    if ([self signatureInfo] != nil) {
        [array addObject:[self signatureInfo]];
    }
    
    ASN1EncodableVector *vector = [DER vectorWithArray:array];
    DERSequence *sequence = [[DERSequence alloc] initDERParamASN1EncodableVector:vector];
    DERApplicationSpecific *retVal = [DER toApplicationSpecific:KeySet_APPLICATION_TAG withEncodable:sequence];
#if !__has_feature(objc_arc)
    if (array != nil) [array release]; array = nil;
    if (derUTF8 != nil) [derUTF8 release]; derUTF8 = nil;
    if (checksumEncodable != nil) [checksumEncodable release]; checksumEncodable = nil;
    if (flagsEncodable != nil) [flagsEncodable release]; flagsEncodable = nil;
    if (sequence != nil) [sequence release]; sequence = nil;
#endif
    return retVal;
}

- (ASN1Primitive*)toASN1Primitive {
    return [self toASN1Primitive:YES];
}

@end
