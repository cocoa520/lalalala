//
//  IMBFolderOrFileButton.h
//  IMBFolderOrFileButton
//
//  Created by iMobie on 14-7-3.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSelectionView.h"
#import "IMBFolderOrFileTitleField.h"
@interface IMBFolderOrFileButton : NSControl
{    BOOL _selected;
}

@property(nonatomic,assign)BOOL selected;
@end

