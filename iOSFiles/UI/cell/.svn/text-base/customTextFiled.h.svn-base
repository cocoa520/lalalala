//
//  customTextFiled.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "customTextFieldCell.h"

@protocol customTextFiledDelegate <NSObject>

- (void)inputTFDidChange:(NSTextField *)tf;

@end

@interface customTextFiled : NSTextField
{
    customTextFieldCell *_btnCell;
    BOOL _needPasteboardContent;
}
@property (nonatomic,assign)BOOL needPasteboardContent;

@property(nonatomic, assign)id<customTextFiledDelegate> dlg;

@end


