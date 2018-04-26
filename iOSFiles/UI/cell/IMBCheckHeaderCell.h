//
//  IMBCheckHeaderCell.h
//  MacClean
//
//  Created by Gehry on 1/20/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckButton.h"

@interface IMBCheckHeaderCell : NSTableHeaderCell{
    IMBCheckButton *_checkButton;
    NSGradient  *_backgroundgradient;
    BOOL _hasTitleBorderline;
    
    BOOL _ascending;
	NSInteger _priority;
    BOOL _hasLeftTitleBorderLine;
}

@property (nonatomic,assign)  IMBCheckButton *checkButton;
//@property (nonatomic,assign)  IMBSelectButton *selectButton;
@property (nonatomic,retain) NSGradient  *backgroundgradient;
@property (assign,nonatomic) BOOL hasTitleBorderLine;
- (id)initWithCell:(NSTableHeaderCell*)cell;
- (id)initWithSelectCell:(NSTableHeaderCell*)cell;

@end
