//
//  IMBFolderOrFileButton.m
//  IMBFolderOrFileButton
//
//  Created by iMobie on 14-7-3.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBFolderOrFileButton.h"

@implementation IMBFolderOrFileButton

@synthesize selected = _selected;

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        
        _selected = selected;
        IMBFolderOrFileTitleField *titlefield = [self viewWithTag:100];
        [titlefield setIsselected:selected];
        for (NSView *subVew in [self subviews]) {
            if ([subVew isKindOfClass:[IMBSelectionView class]]) {
                
                [((IMBSelectionView *)subVew) setSelected:selected];
            }
        }
        [self setNeedsDisplay:YES];
    }
}

@end
