//
//  IMBPurchaseTopVerifyController.h
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IMBWhiteView,customTextFiled,IMBGridientButton;


@interface IMBPurchaseTopVerifyController : NSViewController
{
    IBOutlet IMBWhiteView *_secondViewInputTextFiledBgView;
    IBOutlet customTextFiled *_secondViewInputTextFiled;
    IBOutlet IMBGridientButton *_secondViewActiveBtn;
}
@end
