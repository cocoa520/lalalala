//
//  XFileKeyFactory.h
//  
//
//  Created by Pallas on 8/29/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class XFileKey;

@interface XFileKeyFactory : NSObject {
@private
    id                          _target;
    SEL                         _selector;
    IMP                         _imp;
}

- (id)initWithTarget:(id)target withSel:(SEL)sel withFunction:(IMP)function;

- (XFileKey*)apply:(NSMutableData*)encryptionKey;

@end