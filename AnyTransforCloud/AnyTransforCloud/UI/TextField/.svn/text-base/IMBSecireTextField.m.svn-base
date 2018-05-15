//
//  IMBSecireTextField.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-19.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBSecireTextField.h"
#import "StringHelper.h"
#import "IMBSecureTextFieldCell.h"

#define LINE 5

@implementation IMBSecireTextField

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

-(void)lockFocus{

}
-(BOOL)lockFocusIfCanDrawInContext:(NSGraphicsContext *)context{
    return YES;
}

-(void)unlockFocus{

}

- (void)drawRect:(NSRect)dirtyRect
{
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    NSRectFill(dirtyRect);
    
    [super drawRect:dirtyRect];
}

+ (Class)cellClass
{
    return [IMBSecureTextFieldCell class];
}

- (BOOL)drawsBackground {
    return NO;
}

- (BOOL)textShouldEndEditing:(NSText *)textObject{
    return YES;
}
- (void)textDidBeginEditing:(NSNotification *)notification{
    NSLog(@"textDidBeginEditing");
//    [super textDidBeginEditing:notification];
}
//- (void)textDidEndEditing:(NSNotification *)notification{
//    NSLog(@"ENtextDidEndEditingD");
//    //    [self.cell setPlaceholderString:@"pass"];
//    NSDictionary *dic = [notification userInfo];
//    long tag = [[dic objectForKey:@"NSTextMovement"] longValue];
////    //tag==16 回车
////    //tag == 17 Tab键
////    //0 鼠标点击换行
//    
//     _isEditing = NO;
//   
//    [super textDidEndEditing:notification];
//    if (tag != 16) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_END object:self];
//    }
//}

//用来监听键盘的点击事件
- (BOOL)textView:(NSTextView *)inTextView doCommandBySelector:(SEL)inSelector{
    
    //tab 键
    if (inSelector == @selector(insertTab:)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:INSERT_TAB object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_END object:self];
		return YES;
	}
    else if (inSelector == @selector(insertNewline:) || inSelector == @selector(insertNewlineIgnoringFieldEditor:)) {
//		if (self.target && [self.target respondsToSelector:self.action])
//			[self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:YES];
//		return NO;
	}
	return NO;
}

- (void)textDidChange:(NSNotification *)notification{
    NSLog(@"END");
    [self setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TEXTFILED_INPUT_CHANGE object:self userInfo:nil];
}
-(void)handleNotification:(NSNotification *)notification{
    NSLog(@"closeWindow");
}

- (void)mouseDown:(NSEvent *)theEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:TEXTFILED_MOUSE_DOWN object:self];
    [super mouseDown:theEvent];
}

- (void)selectText:(id)sender{
    
    [super selectText:sender];
}




@end
