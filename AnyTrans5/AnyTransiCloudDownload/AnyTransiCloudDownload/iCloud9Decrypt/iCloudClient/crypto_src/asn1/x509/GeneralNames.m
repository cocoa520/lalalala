//
//  GeneralNames.m
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "GeneralNames.h"
#import "ASN1Sequence.h"
#import "DERSequence.h"
#import "Strings.h"
#import "CategoryExtend.h"

@interface GeneralNames ()

@property (nonatomic, readwrite, retain) NSMutableArray *names;

@end

@implementation GeneralNames
@synthesize names = _names;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_names) {
        [_names release];
        _names = nil;
    }
    [super dealloc];
#endif
}

+ (GeneralNames *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[GeneralNames class]]) {
        return (GeneralNames *)paramObject;
    }
    if (paramObject) {
        return [[[GeneralNames alloc] initParamASN1Sequence:[ASN1Sequence getInstance:paramObject]] autorelease];
    }
    return nil;
}

+ (GeneralNames *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean {
    return [GeneralNames getInstance:[ASN1Sequence getInstance:paramASN1TaggedObject paramBoolean:paramBoolean]];
}

+ (GeneralNames *)fromExtensions:(Extensions *)paramExtensions paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier {
    return [GeneralNames getInstance:[paramExtensions getExtensionParsedValue:paramASN1ObjectIdentifier]];
}

- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfGeneralName:(NSMutableArray *)paramArrayOfGeneralName
{
    if (self = [super init]) {
        self.names = paramArrayOfGeneralName;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamASN1Sequence:(ASN1Sequence *)paramASN1Sequence
{
    if (self = [super init]) {
        self.names = [[[NSMutableArray alloc] initWithSize:(int)[paramASN1Sequence size]] autorelease];
        for (int i = 0; i != [paramASN1Sequence size]; i++) {
            self.names[i] = [GeneralName getInstance:[paramASN1Sequence getObjectAt:i]];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSMutableArray *)getNames {
    NSMutableArray *arrayOfGeneralName = [[[NSMutableArray alloc] initWithSize:(int)self.names.count] autorelease];
    [arrayOfGeneralName copyFromIndex:0 withSource:self.names withSourceIndex:0 withLength:(int)[self.names count]];
    return arrayOfGeneralName;
}

- (ASN1Primitive *)toASN1Primitive {
    return [[[DERSequence alloc] initDERparamArrayOfASN1Encodable:self.names] autorelease];
}

- (NSString *)toString {
    NSMutableString *localStringBuffer = [[NSMutableString alloc] init];
    NSString *str = nil;
    [localStringBuffer appendString:@"GeneralNames:"];
    [localStringBuffer appendString:str];
    for (int i = 0; i != self.names.count; i++) {
        [localStringBuffer appendString:@"    "];
        [localStringBuffer appendString:[NSString stringWithFormat:@"%@", self.names[i]]];
        [localStringBuffer appendString:str];
    }
    NSString *tmpLocalStringBuffer = localStringBuffer.description;
#if !__has_feature(objc_arc)
    if (localStringBuffer) [localStringBuffer release]; localStringBuffer = nil;
#endif
    return [NSString stringWithFormat:@"%@", tmpLocalStringBuffer];
}

@end
