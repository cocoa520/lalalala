//
//  IMBTranferViewCell.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTranferViewCell.h"

@implementation IMBTranferViewCell
@synthesize transferModel = _transferModel;
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    [super drawWithFrame:cellFrame inView:controlView];
    if (_transferModel.fileName != nil) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_transferModel.fileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
         NSRect rect = [self titleRectForBounds:cellFrame];
        [as drawWithRect: rect
                       options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
        [as release];
    }
    if (![_transferModel.progressView superview]) {
        [_transferModel.progressView setFrame:NSMakeRect(cellFrame.origin.x , cellFrame.origin.y + (cellFrame.size.height - _transferModel.progressView.frame.size.height)/2, _transferModel.progressView.frame.size.width, _transferModel.progressView.frame.size.height)];
        [controlView addSubview:_transferModel.progressView];
        [_transferModel.progressView setDoubleValue:40];
    }
    
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:[@"目的地：Dropbox" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSRect rect = NSMakeRect(cellFrame.origin.x , cellFrame.origin.y + 40, cellFrame.size.width, cellFrame.size.height);
    [as drawWithRect: rect
             options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
    [as release];
    
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = [super titleRectForBounds:theRect];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_transferModel.fileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = as;
    NSMutableAttributedString *titleStr = [attrString mutableCopy];
    NSRect textRect = NSZeroRect;
    if (titleStr != nil) {
        textRect = [titleStr boundingRectWithSize: titleFrame.size
                                          options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
        [titleStr release];
    }
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.x = theRect.origin.x +4;
        titleFrame.origin.y = theRect.origin.y +14;
        titleFrame.size.height = textRect.size.height + 2;
        titleFrame.size.width -= 4;
    }
    [as release];
    
    return titleFrame;
}

@end
