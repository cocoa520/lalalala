//
//  IMBToolBarView.h
//  iOSFiles
//
//  Created by iMobie on 18/2/10.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBInformation;

typedef enum : NSUInteger {
    IMBToolBarViewEnumRefresh = 0,
    IMBToolBarViewEnumToMac,
    IMBToolBarViewEnumAddToDevice,
    IMBToolBarViewEnumDelete,
    IMBToolBarViewEnumToDevice
} IMBToolBarViewEnum;

@interface IMBToolBarView : NSView
{
    @private
    IMBInformation *_information;
}

@property(nonatomic, retain)IMBInformation *information;

- (void)setHiddenIndexes:(NSArray *)indexes;

@end
