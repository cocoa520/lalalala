//
//  GenericPolynomialExtensionField.h
//  
//
//  Created by Pallas on 5/6/16.
//
//  Complete

#import "IPolynomialExtensionField.h"

@class IFiniteField;
@class IPolynomial;

@interface GenericPolynomialExtensionField : IPolynomialExtensionField {
@protected
    IFiniteField *                          _subfield;
    IPolynomial *                           _minimalPolynomial;
}

- (IFiniteField*)subfield;
- (IPolynomial*)minimalPolynomial;

- (id)initWithSubfield:(IFiniteField*)subfield withPolynomial:(IPolynomial*)polynomial;

@end
