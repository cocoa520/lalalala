//
//  ASN1TaggedObject.m
//  crypto
//
//  Created by JGehry on 5/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1TaggedObject.h"
#import "ASN1Choice.h"
#import "ASN1Set.h"
#import "ASN1Encodable.h"
#import "ASN1Sequence.h"
#import "ASN1OctetString.h"

@implementation ASN1TaggedObject
@synthesize tagNO = _tagNO;
@synthesize empty = _empty;
@synthesize explicit = _explicit;
@synthesize obj = _obj;

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

- (instancetype)initParamBoolean:(BOOL)paramBoolean paramInt:(int)paramInt paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable
{
    self = [super init];
    if (self) {
        if ([paramASN1Encodable isKindOfClass:[ASN1Choice class]]) {
            self.explicit = YES;
        }else {
            self.explicit = paramBoolean;
        }
        self.tagNO = paramInt;
        if (self.explicit) {
            self.obj = paramASN1Encodable;
        }else {
            ASN1Primitive *localASN1Primitive = paramASN1Encodable.toASN1Primitive;
            if ([localASN1Primitive isKindOfClass:[ASN1Set class]]) {
            }
            self.obj = paramASN1Encodable;
        }
    }
    return self;
}

+ (ASN1TaggedObject *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    if (paramBoolean) {
        return (ASN1TaggedObject *)paramASN1TaggedObject.getObject;
    }
    @throw [NSException exceptionWithName:NSGenericException reason:@"implicitly tagged tagged object" userInfo:nil];
}

+ (ASN1TaggedObject *)getInstance:(id)paramObject {
    if (!paramObject || [paramObject isKindOfClass:[ASN1TaggedObject class]]) {
        return (ASN1TaggedObject *)paramObject;
    }
    if ([paramObject isKindOfClass:[NSMutableData class]]) {
        @try {
            return [ASN1TaggedObject getInstance:[self fromByteArray:(NSMutableData *)paramObject]];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"failed to construct tagged object from byte[]: %@", exception.description] userInfo:nil];
        }
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"unknown object in getInstance: %s", object_getClassName(paramObject)] userInfo:nil];
}

- (BOOL)asn1Equals:(ASN1Primitive *)paramASN1Primitive {
    if (![paramASN1Primitive isKindOfClass:[ASN1TaggedObject class]]) {
        return NO;
    }
    ASN1TaggedObject *localASN1TaggedObject = (ASN1TaggedObject *)paramASN1Primitive;
    if ((self.tagNO != localASN1TaggedObject.tagNO) || (self.empty != localASN1TaggedObject.empty) || (self.explicit != localASN1TaggedObject.explicit)) {
        return NO;
    }
    if (!self.obj) {
        if (localASN1TaggedObject.obj) {
            return NO;
        }
    }else if ([[self.obj toASN1Primitive] isEqual:[localASN1TaggedObject.obj toASN1Primitive]]) {
        return NO;
    }
    return YES;
}

- (int)getTagNo {
    return self.tagNO;
}

- (BOOL)isExplicit {
    return self.explicit;
}

- (BOOL)isEmpty {
    return self.empty;
}

- (ASN1Primitive *)getObject {
    if (self.obj) {
        return self.obj.toASN1Primitive;
    }
    return NULL;
}

- (ASN1Encodable *)getObjectParser:(int)paramInt paramBoolean:(BOOL)paramBoolean {
    switch (paramInt) {
        case 17:
            return [[ASN1Set getInstance:self paramBoolean:paramBoolean] parser];
            break;
        case 16:
            return [[ASN1Sequence getInstance:self paramBoolean:paramBoolean] parser];
            break;
        case 4:
            return [[ASN1OctetString getInstance:self paramBoolean:paramBoolean] parser];
            break;
            
        default:
            break;
    }
    if (paramBoolean) {
        return [self getObject];
    }
    @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"implicit tagging not implemented for tag: %d", paramInt] userInfo:nil];
}

- (ASN1Primitive *)getLoadedObject {
    return [self toASN1Primitive];
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"[ %@ ]", self.obj];
}

- (NSUInteger)hash {
    int code = self.tagNO;
    if (self.obj)
    {
        code ^= [self.obj hash];
    }
    return code;
}

@end
