//
//  IMBiTunesSecireTextField.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-25.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBiTunesSecireTextField.h"
//#import "IMBCommonDefine.h"
#import "IMBNotificationDefine.h"
#import "IMBCommonEnum.h"
#import "IMBiTunesSecureTextFieldCell.h"
#define LINE 5
@implementation IMBiTunesSecireTextField

@synthesize isHasLoginBtn = _isHasLoginBtn;
-(void)awakeFromNib{
    self.delegate = self;
}
- initWithCoder: (NSCoder *)origCoder
{
	BOOL sub = YES;
	sub = sub && [origCoder isKindOfClass: [NSKeyedUnarchiver class]]; // no support for 10.1 nibs
	sub = sub && ![self isMemberOfClass: [NSControl class]]; // no raw NSControls
	sub = sub && [[self superclass] cellClass] != nil; // need to have something to substitute
	sub = sub && [[self superclass] cellClass] != [[self class] cellClass]; // pointless if same
	if( !sub )
	{
		self = [super initWithCoder: origCoder];
	}
	else
	{
		NSKeyedUnarchiver *coder = (id)origCoder;
		
		// gather info about the superclass's cell and save the archiver's old mapping
		Class superCell = [[self superclass] cellClass];
		NSString *oldClassName = NSStringFromClass( superCell );
		Class oldClass = [coder classForClassName: oldClassName];
		if( !oldClass )
			oldClass = superCell;
		
		// override what comes out of the unarchiver
		[coder setClass: [[self class] cellClass] forClassName: oldClassName];
		
		// unarchive
		self = [super initWithCoder: coder];
        
		// set it back
		[coder setClass: oldClass forClassName: oldClassName];
	}
	return self;
}

//-(void)lockFocus{
//
//}
//-(BOOL)lockFocusIfCanDrawInContext:(NSGraphicsContext *)context{
//    return YES;
//}

//-(void)unlockFocus{
//
//}

- (void)drawRect:(NSRect)dirtyRect
{
    //    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    //
    //    [[NSColor whiteColor] set];
    //    [clipPath fill];
    
    [super drawRect:dirtyRect];
}

+ (Class)cellClass
{
    return [IMBiTunesSecureTextFieldCell class];
}

- (BOOL)drawsBackground {
    return NO;
}

- (BOOL)textShouldEndEditing:(NSText *)textObject{
    return YES;
}
- (void)textDidBeginEditing:(NSNotification *)notification{
    
    NSString *str = self.stringValue;
    NSLog(@"textDidBeginEditing");
}
- (void)textDidEndEditing:(NSNotification *)notification{
    NSLog(@"ENtextDidEndEditingD");
    //    [self.cell setPlaceholderString:@"pass"];
    NSDictionary *dic = [notification userInfo];
    long tag = [[dic objectForKey:@"NSTextMovement"] longValue];
    //tag==16 回车
    //tag == 17 Tab键
    //0 鼠标点击换行
    if (tag == 16) {
        
    }
    //NSString *str = [self stringValue];
    //NSLog(@"%@",str);
}




//用来监听键盘的点击事件
- (BOOL)textView:(NSTextView *)inTextView doCommandBySelector:(SEL)inSelector{
    
    //tab 键
    if (inSelector == @selector(insertTab:)) {
		return NO;
        //回车键
	} else if (inSelector == @selector(insertNewline:) || inSelector == @selector(insertNewlineIgnoringFieldEditor:)) {
        //		self.attributedString = inTextView.attributedString;
		if (self.target && [self.target respondsToSelector:self.action])
			[self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
		return NO;
	}
	return NO;
}

- (void)textDidChange:(NSNotification *)notification{
    NSLog(@"END");
    NSString *str = self.stringValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ITUNES_TETY_PASS object:str userInfo:nil];
    
}
-(void)handleNotification:(NSNotification *)notification{
    NSLog(@"closeWindow");
}


@end
