//
//  IMBLackCornerView.h
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/26.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBLackCornerView : NSView
{
    NSColor *_backgroundColor;
    NSImage *_backgroundImage;
    BOOL _luCorner;
    BOOL _lbCorner;
    BOOL _ruCorner;
    BOOL _rbCorner;
    float _cornerRadius;
}
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSImage *backgroundImage;
- (id)initWithLuCorner:(BOOL)luCorner LbCorner:(BOOL)lbConer RuCorner:(BOOL)ruConer RbConer:(BOOL)rbConer CornerRadius:(float)cornerRadius;
@end




