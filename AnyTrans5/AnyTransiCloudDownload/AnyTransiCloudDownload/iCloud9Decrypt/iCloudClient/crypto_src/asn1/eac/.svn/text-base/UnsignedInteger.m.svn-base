//
//  UnsignedInteger.m
//  crypto
//
//  Created by JGehry on 7/5/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "UnsignedInteger.h"
#import "ASN1TaggedObject.h"
#import "ASN1OctetString.h"
#import "DERTaggedObject.h"
#import "DEROctetString.h"
#import "CategoryExtend.h"

@interface UnsignedInteger ()

@property (nonatomic, assign) int tagNo;
@property (nonatomic, readwrite, retain) BigInteger *value;

@end

@implementation UnsignedInteger
@synthesize tagNo = _tagNo;
@synthesize value = _value;


- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_value) {
        [_value release];
        _value = nil;
    }
    [super dealloc];
#endif
}

+ (UnsignedInteger *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[UnsignedInteger class]]) {
        return (UnsignedInteger *)paramObject;
    }
    if (paramObject) {
        return [[[UnsignedInteger alloc] initParamASN1TaggedObject:[ASN1TaggedObject getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamASN1TaggedObject:(ASN1TaggedObject *)paramASN1TaggedObject
{
    self = [super init];
    if (self) {
        self.tagNo = [paramASN1TaggedObject getTagNo];
        self.value = [[[BigInteger alloc] initWithSign:1 withBytes:[[ASN1OctetString getInstance:paramASN1TaggedObject paramBoolean:false] getOctets]] autorelease];
    }
    return self;
}

- (instancetype)initParamInt:(int)paramInt paramBigInteger:(BigInteger *)paramBigInteger
{
    self = [super init];
    if (self) {
        self.tagNo = paramInt;
        self.value = paramBigInteger;
    }
    return self;
}

- (NSMutableData *)convertValue {
    NSMutableData *arrayOfByte1 = [self.value toByteArray];
    if (((Byte *)[arrayOfByte1 bytes])[0] == 0) {
        NSMutableData *arrayOfByte2 = [[[NSMutableData alloc] initWithSize:((int)arrayOfByte1.length - 1)] autorelease];
        [arrayOfByte2 copyFromIndex:0 withSource:arrayOfByte1 withSourceIndex:1 withLength:(int)[arrayOfByte2 length]];
        return arrayOfByte2;
    }
    return arrayOfByte1;
}

- (int)getTagNo {
    return self.tagNo;
}

- (BigInteger *)getValue {
    return self.value;
}

- (ASN1Primitive *)toASN1Primitive {
    ASN1Encodable *encodable = [[DEROctetString alloc] initDEROctetString:[self convertValue]];
    ASN1Primitive *primitive = [[[DERTaggedObject alloc] initParamBoolean:NO paramInt:self.tagNo paramASN1Encodable:encodable] autorelease];
#if !__has_feature(objc_arc)
    if (encodable) [encodable release]; encodable = nil;
#endif
    return primitive;
}

@end
