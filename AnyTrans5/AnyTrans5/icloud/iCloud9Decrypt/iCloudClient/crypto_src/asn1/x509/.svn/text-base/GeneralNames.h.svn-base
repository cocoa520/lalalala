//
//  GeneralNames.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "ASN1TaggedObject.h"
#import "Extensions.h"
#import "GeneralName.h"

@interface GeneralNames : ASN1Object {
    NSMutableArray *_names;
}

+ (GeneralNames *)getInstance:(id)paramObject;
+ (GeneralNames *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
+ (GeneralNames *)fromExtensions:(Extensions *)paramExtensions paramASN1ObjectIdentifier:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (instancetype)initParamGeneralName:(GeneralName *)paramGeneralName;
- (instancetype)initParamArrayOfGeneralName:(NSMutableArray *)paramArrayOfGeneralName;
- (NSMutableArray *)getNames;
- (ASN1Primitive *)toASN1Primitive;
- (NSString *)toString;

@end
