//
//  X509NameTokenizer.h
//  crypto
//
//  Created by JGehry on 7/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface X509NameTokenizer : NSObject {
@private
    NSString *_value;
    int _index;
    char _separator;
    NSMutableString *_buf;
}

- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamString:(NSString *)paramString paramChar:(char)paramChar;
- (BOOL)hasMoreTokens;
- (NSString *)nextToken;

@end
