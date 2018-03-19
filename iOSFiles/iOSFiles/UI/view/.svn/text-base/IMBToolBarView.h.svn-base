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
    IMBToolBarViewEnumToMac     =1,
    IMBToolBarViewEnumAddToDevice =2,
    IMBToolBarViewEnumDelete =3,
    IMBToolBarViewEnumToDevice =4,
    IMBToolBarNoData =5,
    IMBToolBarViewEnumEdit = 6
} IMBToolBarViewEnum;

@interface IMBToolBarView : NSView
{
    @private
    IMBInformation *_information;
    id _delegate;
}
@property(nonatomic, assign) id delegate;
@property(nonatomic, retain)IMBInformation *information;
//要隐藏的按钮
- (void)setHiddenIndexes:(NSArray *)indexes;
- (void)enableBtns:(BOOL)isEnable;

@end
