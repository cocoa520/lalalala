//
//  IMBiCloudPopViewController.h
//  AnyTrans
//
//  Created by LuoLei on 17-1-18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBiCloudPopViewController : NSViewController
{
    @private
    id _target;
    SEL _action;
    BOOL _isTitleBtn;
    NSArray *_accountArr;
    NSString *_currentAppleID;
}
@property (nonatomic, assign) BOOL isTitleBtn;
@property (nonatomic,assign)id target;
@property (nonatomic,assign)SEL action;
@property (nonatomic,retain) NSString *currentAppleID;
- (id)initWithNibName:(NSString *)nibNameOrNil iCloudAccountArr:(NSArray *)accountArr withCureentAppleID:(NSString *)curenntAppleID;
@end
