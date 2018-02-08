//
//  IMBPopController.m
//  PrimoMusic
//
//  Created by iMobie_Market on 16/5/9.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import "IMBPopController.h"

@interface IMBPopController ()

@end

@implementation IMBPopController
@synthesize name = _name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:_name];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSCenterTextAlignment;
    NSDictionary *dic = @{NSFontAttributeName:[NSFont fontWithName:@"Helvetica Neue" size:12],NSParagraphStyleAttributeName:style,NSAttachmentAttributeName:as};
    NSSize size = [_name sizeWithAttributes:dic];
    NSRect rect = NSMakeRect(0, 0, size.width + 30, size.height + 6);
    self.view.frame = rect;
    [titleTextField setStringValue:_name];
    [titleTextField setFrame:NSMakeRect(5, 3, size.width + 20, size.height)];
}



@end
