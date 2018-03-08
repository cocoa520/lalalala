//
//  IMBCheckHeaderCell.h
//  MacClean
//
//  Created by Gehry on 1/20/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCheckBtn.h"
//#import "IMBSelectButton.h"

@interface IMBCheckHeaderCell : NSTableHeaderCell{
    IMBCheckBtn *_checkButton;
    //    IMBSelectButton *_selectButton;
    NSGradient  *_backgroundgradient;
    BOOL _hasTitleBorderline;
    
    BOOL _ascending;
	NSInteger _priority;
    BOOL _hasLeftTitleBorderLine;
}

@property (nonatomic,assign)  IMBCheckBtn *checkButton;
//@property (nonatomic,assign)  IMBSelectButton *selectButton;
@property (nonatomic,retain) NSGradient  *backgroundgradient;
@property (assign,nonatomic) BOOL hasTitleBorderLine;
- (id)initWithCell:(NSTableHeaderCell*)cell;
- (id)initWithSelectCell:(NSTableHeaderCell*)cell;

@end
