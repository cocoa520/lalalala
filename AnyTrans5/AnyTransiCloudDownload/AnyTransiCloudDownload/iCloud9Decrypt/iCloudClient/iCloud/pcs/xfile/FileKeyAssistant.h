//
//  FileKeyAssistant.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>
#import "KeyBag.h"

@class KeyBlob;

@interface FileKeyAssistant : NSObject

+ (NSMutableData*)uuid:(NSMutableData*)fileKey;
+ (NSMutableData*)unwrap:(id)target withSel:(SEL)sel withFunction:(IMP)function withBlob:(KeyBlob*)blob;

@end
