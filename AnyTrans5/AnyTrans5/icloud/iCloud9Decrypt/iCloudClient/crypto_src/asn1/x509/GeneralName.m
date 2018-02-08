//
//  GeneralName.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GeneralName.h"
#import "DERIA5String.h"
#import "DEROctetString.h"
#import "ASN1Sequence.h"
#import "DERTaggedObject.h"

@interface GeneralName ()

@property (nonatomic, readwrite, retain) ASN1Encodable *obj;
@property (nonatomic, assign) int tag;

@end

@implementation GeneralName
@synthesize obj = _obj;
@synthesize tag = _tag;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_obj) {
        [_obj release];
        _obj = nil;
    }
    [super dealloc];
#endif
}

+ (int)otherName {
    static int _otherName = 0;
    @synchronized(self) {
        if (!_otherName) {
            _otherName = 0;
        }
    }
    return _otherName;
}

+ (int)rfc822Name {
    static int _rfc822Name = 0;
    @synchronized(self) {
        if (!_rfc822Name) {
            _rfc822Name = 1;
        }
    }
    return _rfc822Name;
}

+ (int)dNSName {
    static int _dNSName = 0;
    @synchronized(self) {
        if (!_dNSName) {
            _dNSName = 2;
        }
    }
    return _dNSName;
}

+ (int)x400Address {
    static int _x400Address = 0;
    @synchronized(self) {
        if (!_x400Address) {
            _x400Address = 3;
        }
    }
    return _x400Address;
}

+ (int)directoryName {
    static int _directoryName = 0;
    @synchronized(self) {
        if (!_directoryName) {
            _directoryName = 4;
        }
    }
    return _directoryName;
}

+ (int)ediPartyName {
    static int _ediPartyName = 0;
    @synchronized(self) {
        if (!_ediPartyName) {
            _ediPartyName = 5;
        }
    }
    return _ediPartyName;
}

+ (int)uniformResourceIdentifier {
    static int _uniformResourceIdentifier = 0;
    @synchronized(self) {
        if (!_uniformResourceIdentifier) {
            _uniformResourceIdentifier = 6;
        }
    }
    return _uniformResourceIdentifier;
}

+ (int)iPAddress {
    static int _iPAddress = 0;
    @synchronized(self) {
        if (!_iPAddress) {
            _iPAddress = 7;
        }
    }
    return _iPAddress;
}

+ (int)registeredID {
    static int _registeredID = 0;
    @synchronized(self) {
        if (!_registeredID) {
            _registeredID = 8;
        }
    }
    return _registeredID;
}

+ (GeneralName *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[GeneralName class]]) {
        return (GeneralName *)paramObject;
    }
    if ([paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)paramObject;
        int i = [localASN1TaggedObject getTagNo];
        switch (i) {
            case 0:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:NO]] autorelease];
            case 1:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[DERIA5String getInstance:localASN1TaggedObject paramBoolean:NO]] autorelease];
            case 2:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[DERIA5String getInstance:localASN1TaggedObject paramBoolean:NO]] autorelease];
            case 3:
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown tag: %d", i] userInfo:nil];
            case 4:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[X500Name getInstance:localASN1TaggedObject paramBoolean:YES]] autorelease];
            case 5:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[ASN1Sequence getInstance:localASN1TaggedObject paramBoolean:NO]] autorelease];
            case 6:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[DERIA5String getInstance:localASN1TaggedObject paramBoolean:NO]] autorelease];
            case 7:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[ASN1OctetString getInstance:localASN1TaggedObject paramBoolean:NO]] autorelease];
            case 8:
                return [[[GeneralName alloc] initParamInt:i paramASN1Encodable:[ASN1ObjectIdentifier getInstance:localASN1TaggedObject paramBoolean:NO]] autorelease];
            default:
                break;
        }
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [GeneralName getInstance:[ASN1Primitive fromByteArray:(NSMutableData *)paramObject]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"unable to parse encoded general name" userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"unknown object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

+ (GeneralName *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [GeneralName getInstance:[ASN1TaggedObject getInstance:paramASN1TaggedObject paramBoolean:YES]];
}

- (instancetype)initParamX509Name:(X509Name *)paramX509Name
{
    if (self = [super init]) {
        self.obj = [X500Name getInstance:paramX509Name];
        self.tag = 4;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamX500Name:(X500Name *)paramX500Name
{
    if (self = [super init]) {
        self.obj = paramX500Name;
        self.tag = 4;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    if (self = [super init]) {
        self.obj = paramASN1Encodable;
        self.tag = paramInt;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamInt:(int)paramInt paramString:(NSString *)paramString
{
    if (self = [super init]) {
        self.tag = paramInt;
        if ((paramInt == 1) || (paramInt == 2) || (paramInt == 6)) {
            ASN1Encodable *objEncodable = [[DERIA5String alloc] initParamString:paramString];
            self.obj = objEncodable;
#if !__has_feature(objc_arc)
    if (objEncodable) [objEncodable release]; objEncodable = nil;
#endif
        }else if (paramInt == 8) {
            ASN1Encodable *objEncodable = [[ASN1ObjectIdentifier alloc] initParamString:paramString];
            self.obj = objEncodable;
#if !__has_feature(objc_arc)
            if (objEncodable) [objEncodable release]; objEncodable = nil;
#endif
        }else if (paramInt == 4) {
            ASN1Encodable *objEncodable = [[X500Name alloc] initParamString:paramString];
            self.obj = objEncodable;
#if !__has_feature(objc_arc)
            if (objEncodable) [objEncodable release]; objEncodable = nil;
#endif
        }else if (paramInt == 7) {
            NSMutableData *arrayOfByte = [self toGeneralNameEncoding:paramString];
            if (arrayOfByte) {
                ASN1Encodable *objEncodable = [[DEROctetString alloc] initDEROctetString:arrayOfByte];
                self.obj = objEncodable;
#if !__has_feature(objc_arc)
                if (objEncodable) [objEncodable release]; objEncodable = nil;
#endif
            }else {
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"IP Address is invalid" userInfo:nil];
            }
        }else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"can't process String for tag: %d", paramInt] userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (int)getTagNo {
    return self.tag;
}

- (ASN1Encodable *)getName {
    return self.obj;
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[[NSMutableString alloc] init] autorelease];
    [localStringBuffer appendString:[NSString stringWithFormat:@"%d", self.tag]];
    [localStringBuffer appendString:@": "];
    switch (self.tag) {
        case 1:
        case 2:
        case 6:
            [localStringBuffer appendString:[[DERIA5String getInstance:self.obj] getString]];
            break;
        case 4:
            [localStringBuffer appendString:[[X500Name getInstance:self.obj] toString]];
            break;
        case 3:
        case 5:
        default:
            [localStringBuffer appendString:[NSString stringWithFormat:@"%@", self.obj]];
            break;
    }
    return [NSString stringWithFormat:@"%@", localStringBuffer.description];
}

- (NSMutableData *)toGeneralNameEncoding:(NSString *)paramString {
    return nil;
}

- (ASN1Primitive *)toASN1Primitive {
    if (self.tag == 4) {
        return [[[DERTaggedObject alloc] initParamBoolean:YES paramInt:self.tag paramASN1Encodable:self.obj] autorelease];
    }
    return [[[DERTaggedObject alloc] initParamBoolean:NO paramInt:self.tag paramASN1Encodable:self.obj] autorelease];
}

@end
