//
//  IMBPopController.h
//  PrimoMusic
//
//  Created by iMobie_Market on 16/5/9.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBPopController : NSViewController
{
    NSString *_name;
    IBOutlet NSTextField *titleTextField;
}
@property (nonatomic, copy) NSString *name;

@end
