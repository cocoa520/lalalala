//
//  GenericPolynomialExtensionField.m
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "GenericPolynomialExtensionField.h"
#import "IFiniteField.h"
#import "IPolynomial.h"

@interface GenericPolynomialExtensionField ()

@property (nonatomic, readwrite, retain) IFiniteField *subfield;
@property (nonatomic, readwrite, retain) IPolynomial *minimalPolynomial;

@end

@implementation GenericPolynomialExtensionField
@synthesize subfield = _subfield;
@synthesize minimalPolynomial = _minimalPolynomial;

- (id)initWithSubfield:(IFiniteField*)subfield withPolynomial:(IPolynomial*)polynomial {
    if (self = [super init]) {
        [self setSubfield:subfield];
        [self setMinimalPolynomial:polynomial];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setSubfield:nil];
    [self setMinimalPolynomial:nil];
    [super dealloc];
#endif
}

- (BigInteger*)characteristic {
    return [self.subfield characteristic];
}

- (int)dimension {
    return [self.subfield dimension] * [self.minimalPolynomial degree];
}

- (int)degree {
    return [self.minimalPolynomial degree];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (object && [object isKindOfClass:[GenericPolynomialExtensionField class]]) {
        GenericPolynomialExtensionField *other = (GenericPolynomialExtensionField*)object;
        return ([self.subfield isEqualTo:other.subfield] && [self.minimalPolynomial isEqualTo:other.minimalPolynomial]);
    } else {
        return NO;
    }
}

@end
