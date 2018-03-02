//
//  ViewController.m
//  TestAnimation
//
//  Created by iMobie on 18/3/1.
//  Copyright © 2018年 TsinHzl. All rights reserved.
//

#import "ViewController.h"
#import "ZLAnimation.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    
    NSTextField *tf1 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 100, 100, 100)];
    [tf1 setEditable:NO];
    [tf1 setBordered:NO];
    tf1.stringValue = @"Test";
    [self.view addSubview:tf1];
    
    [ZLAnimation testWithView:tf1 frame:NSMakeRect(0, 0, 234, 150)];
    
}



@end
