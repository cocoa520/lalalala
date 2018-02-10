//
//  IMBStackBox.h
//  iOSFiles
//
//  Created by iMobie on 18/2/6.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBStackBox : NSBox
{
    @private
    NSMutableArray *_contentViewsArray;
}

@property(nonatomic, retain, readonly)NSMutableArray *contentViewsArray;

- (void)pushView:(NSView *)view;
- (void)popView;
- (void)popToView:(NSView *)view;
- (NSView *)currentView;

@end
