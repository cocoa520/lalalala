//
//  IMBToolBarButton.h
//  iMobieTrans
//
//  Created by iMobie on 14-8-11.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBToolBarButton : NSButton
{
    BOOL _isThroughNib;
    BOOL needTitle;
    BOOL isselected;
}

@property(nonatomic,assign)BOOL isselected;
- (id)initWithFrame:(NSRect)frame needTitle:(BOOL)_needTitle;

@end
