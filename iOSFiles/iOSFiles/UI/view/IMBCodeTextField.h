//
//  IMBCodeTextField.h
//  AnyTrans
//
//  Created by smz on 18/2/28.
//  Copyright (c) 2018年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#pragma mark - 通知string
APPKIT_EXTERN NSString * const IMBCodeTextFieldCodeTagKey;

APPKIT_EXTERN NSString * const IMBCodeTextFieldDeleteCodeNotification;
APPKIT_EXTERN NSString * const IMBCodeTextFieldCodeEditCodeNotifation;


@interface IMBCodeTextField : NSTextField<NSTextFieldDelegate> {
    int _codeTag;
    BOOL _isDeleting;
}

@property (nonatomic,assign) int codeTag;

@end
