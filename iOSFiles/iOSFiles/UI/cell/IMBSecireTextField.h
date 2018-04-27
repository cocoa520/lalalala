//
//  IMBSecireTextField.h
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBSecireTextField : NSSecureTextField<NSTextFieldDelegate>
{
    BOOL _isHasLoginBtn;
}
@property (nonatomic, assign) BOOL isHasLoginBtn;
@end
