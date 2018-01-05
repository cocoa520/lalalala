//
//  SubjectKeyIdentifier.m
//  crypto
//
//  Created by JGehry on 7/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "SubjectKeyIdentifier.h"
#import "DEROctetString.h"
#import "Extension.h"

@interface SubjectKeyIdentifier ()

@property (nonatomic, readwrite, retain) NSMutableData *keyidentifier;

@end

@implementation SubjectKeyIdentifier
@synthesize keyidentifier = _keyidentifier;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_keyidentifier) {
        [_keyidentifier release];
        _keyidentifier = nil;
    }
    [super dealloc];
#endif
}

+ (SubjectKeyIdentifier *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[SubjectKeyIdentifier class]]) {
        return (SubjectKeyIdentifier *)paramObject;
    }
    if (paramObject) {
        return [[[SubjectKeyIdentifier alloc] initParamASN1OctetString:[ASN1OctetString getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (SubjectKeyIdentifier *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [SubjectKeyIdentifier getInstance:[ASN1OctetString getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (SubjectKeyIdentifier *)fromExtensions:(Extensions *)paramExtensions {
    return [SubjectKeyIdentifier getInstance:[paramExtensions getExtensionParsedValue:[Extension subjectKeyIdentifier]]];
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        self.keyidentifier = paramArrayOfByte;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1OctetString:(ASN1OctetString *)paramASN1OctetString
{
    if (self = [super init]) {
        self.keyidentifier = [paramASN1OctetString getOctets];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (NSMutableData *)getKeyIdentifier {
    return self.keyidentifier;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DEROctetString alloc] initDEROctetString:self.keyidentifier] autorelease];
}

@end
