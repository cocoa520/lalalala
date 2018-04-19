//
//  IMBPurchaseLeftNumController.h
//  AllFiles
//
//  Created by iMobie on 2018/4/19.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBPurchaseLeftNumController : NSViewController
{
    
    IBOutlet NSTextField *_firstLabel;
    IBOutlet NSTextField *_secondLabel;
    IBOutlet NSTextField *_thirdLabel;
    IBOutlet NSTextField *_titleLabel;
    
    NSArray *_leftNums;
}

@property(nonatomic, retain)NSTextField *titleLabel;
@property(nonatomic, retain)NSArray *leftNums;

@end
