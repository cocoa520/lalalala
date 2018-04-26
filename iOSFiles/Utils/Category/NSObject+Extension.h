//
//  NSObject+Extension.h
//  iOSFiles
//
//  Created by iMobie on 18/2/27.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLEndMark.h"

@interface NSObject (Extension)

- (void)performSelector:(SEL)aSelector withObjects:(id)object,...;

@end
