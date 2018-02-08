//
//  X500NameTokenizer.h
//  crypto
//
//  Created by JGehry on 6/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface X500NameTokenizer : NSObject {
@private
    NSString *_value;
    int _index;
    char *_separator;
}

- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamString:(NSString *)paramString paramChar:(char *)paramChar;
- (BOOL)hasMoreTokens;
- (NSString *)nextToken;

@end
