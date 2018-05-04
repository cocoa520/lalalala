//
//  IMBGridTextField.h
//  AllFiles
//
//  Created by iMobie on 2018/5/4.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol IMBGridTextFieldDelegate <NSObject>

@optional
- (void)gridTextFieldInsertNewline;

@end

@interface IMBGridTextField : NSTextField
{
    id<IMBGridTextFieldDelegate> _dlg;
}
@property(nonatomic, retain)id<IMBGridTextFieldDelegate> dlg;
@property(nonatomic, copy)void(^gridTextfieldInsertNewline)(void);
@end
