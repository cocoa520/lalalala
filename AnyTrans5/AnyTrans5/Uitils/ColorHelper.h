//
//  ColorHelper.h
//  AnyTrans
//
//  Created by m on 11/11/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorHelper : NSObject
+ (void)setGrientColorWithRect:(NSRect) dirtyRect withCorner:(BOOL)hasCorner withPart:(int)part;
+ (float)getColorFromColorString:(NSString *)str WithIndex:(int)index;
//shuaimingzhong add 2017.8.14
+ (NSColor *) colorWithHexString: (NSString *)color;
@end
