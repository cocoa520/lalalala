//
//  IMBInputNumberFormat.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/19.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBInputNumberFormat.h"

@implementation IMBInputNumberFormat

- (instancetype)init {
    self = [super init];
    if (self) {
        self.max = INTMAX_MAX;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.max = INTMAX_MAX;
    }
    return self;
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString **)error {
    if ((*partialStringPtr).length <= origString.length) {
        return YES;
    }
    
    NSString * strInsert = [*partialStringPtr substringWithRange:*proposedSelRangePtr];
    if (strInsert) {
        for (NSUInteger charIndex = 0; charIndex < strInsert.length; charIndex ++) {
            if (![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[strInsert characterAtIndex:charIndex]]) {
                return NO;
            }
        }
    }
    
    NSNumber * newStringNumber = [[NSNumberFormatter new] numberFromString:*partialStringPtr];
    if (!newStringNumber || newStringNumber.integerValue > self.max) {
        return NO;
    }
    
    return YES;
}

@end
