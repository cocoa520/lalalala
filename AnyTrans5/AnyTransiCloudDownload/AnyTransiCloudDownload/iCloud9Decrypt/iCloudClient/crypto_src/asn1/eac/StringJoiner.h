//
//  StringJoiner.h
//  crypto
//
//  Created by JGehry on 7/5/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringJoiner : NSObject {
    NSString *_mSeparator;
    BOOL _First;
    NSMutableString *_b;
}

@property (nonatomic, readwrite, retain) NSString *mSeparator;
@property (nonatomic, assign) BOOL First;
@property (nonatomic, readwrite, retain) NSMutableString *b;

- (instancetype)initParamString:(NSString *)paramString;
- (void)add:(NSString *)paramString;
- (NSString *)toString;

@end
