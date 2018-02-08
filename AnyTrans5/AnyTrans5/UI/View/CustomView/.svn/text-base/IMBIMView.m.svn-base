//
//  IMBIMView.m
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBIMView.h"
#import "StringHelper.h"
#define ORIGINX 0
#define EDITINGORIGINX 124
#define POPUPRIGHTORIGINX 120
#define TEXTFIELDHEIGHT 16


@implementation IMBIMView
@synthesize imArr = _imArr;
@synthesize lableType = _lableType;
@synthesize displayValue = _displayValue;
@synthesize labelsArr = _labelsArr;
@synthesize valueText = _valueText;
@synthesize imEntity = _imEntity;
@synthesize isLastItem = _isLastItem;
@synthesize serviceType = _servicetype;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc{
    if (_valueField != nil) {
        [_valueField release];
        _valueField = nil;
    }
    if (_lablePopup != nil) {
        [_lablePopup release];
        _lablePopup = nil;
    }
    if (_imPopup != nil) {
        [_imPopup release];
        _imPopup = nil;
    }
    if (_labelsArr != nil) {
        [_labelsArr release];
        _labelsArr = nil;
    }
    if (_imArr != nil) {
        [_imArr release];
        _imArr = nil;
    }
    if (_lableType != nil) {
        [_lableType release];
        _lableType = nil;
    }
    if (_displayValue != nil) {
        [_displayValue release];
        _displayValue = nil;
    }
    if (_deleteBtn != nil) {
        [_deleteBtn release];
        _deleteBtn = nil;
    }
    if (_imArr != nil) {
        [_imArr release];
        _imArr = nil;
    }
    if (_imEntity != nil) {
        [_imEntity release];
        _imEntity = nil;
    }
    
    [super dealloc];
}

- (void)awakeFromNib{
    [self initSubview];
}

- (void)viewDidMoveToSuperview{
    [super viewDidMoveToSuperview];
    [self initSubview];
}

- (void)initSubview{
    _isEditing = NO;
    [self layoutSubViews];
}

- (void)layoutSubViews{
    if (_lablePopup == nil) {
        _lablePopup = [[IMBPopupButton alloc] initWithFrame:NSMakeRect(ORIGINX + 30, 0, 120, TEXTFIELDHEIGHT)];
        [_lablePopup setBindingEntity:_imEntity];
        [_lablePopup setBindingEntityKeyPath:@"label"];
        [_lablePopup setAlignmentRightOriginx:POPUPRIGHTORIGINX + ORIGINX];
        
        if (_labelsArr != nil) {
            [_lablePopup setTitlesArr:_labelsArr];
        }
        
        if (_lableType != nil) {
            if (_labelsArr != nil) {
                NSUInteger index = [_labelsArr indexOfObject:_lableType];
                [_lablePopup selectItemAtIndex:index];
            }
        }
        else{
            [self setLableType:@"IM"];
            [_lablePopup selectItemAtIndex:0];
        }
        
        [_lablePopup setFrameOrigin:NSMakePoint(ORIGINX + 30, 0)];
        [_lablePopup resizeRect];
        [_lablePopup setDelegate:self];
        [self addSubview:_lablePopup];
    }
    if (!_isEditing) {
        [_lablePopup setFrame:NSMakeRect(30 + ORIGINX, 0, 120, TEXTFIELDHEIGHT)];
        [_lablePopup setAlignmentRightOriginx:POPUPRIGHTORIGINX + ORIGINX];
        [_lablePopup resizeRect];
    }
    else{
        [_lablePopup setFrame:NSMakeRect(30 + EDITINGORIGINX, 0, 120, TEXTFIELDHEIGHT)];
        [_lablePopup setAlignmentRightOriginx:POPUPRIGHTORIGINX + EDITINGORIGINX];
        [_lablePopup resizeRect];
    }

    int originX = (int)_lablePopup.frame.origin.x + (int)_lablePopup.frame.size.width + 5;
    
    if (_imPopup == nil) {
        //这儿暂时有问题，有待调整
        _imPopup = [[IMBPopupButton alloc] initWithFrame:NSMakeRect(ORIGINX + 30, 0, 200, TEXTFIELDHEIGHT)];
        [_imPopup setBindingEntity:_imEntity];
        [_imPopup setBindingEntityKeyPath:@"service"];
        [_imPopup setAlignmentRightOriginx:POPUPRIGHTORIGINX + ORIGINX];
        if (_imArr != nil){
            [_imPopup setTitlesArr:_imArr];
        }
        if (_servicetype != nil) {
            NSUInteger index = [_imArr indexOfObject:_servicetype];
            [_imPopup selectItemAtIndex:index];
        }
        else{
            [self setServiceType:@"Service"];
            [_imPopup selectItemAtIndex:0];
        }
        [_imPopup setFrameOrigin:NSMakePoint(ORIGINX + 30, 0)];
        [_imPopup resizeRect];
        [_imPopup setDelegate:self];
        [self addSubview:_imPopup];
    }

    if (_valueField == nil) {
        NSString *placeHolderString = CustomLocalizedString(@"contact_id_61", nil);

        _valueField = [[IMBTextField alloc] init];
        [_valueField setBindingEntity:_imEntity];
        [_valueField setBindingEntityKeyPath:@"user"];
        
        [_valueField setFontSize:12.0];
        [_valueField setMaxPreferenceWidth:self.frame.size.width - originX - 5 - _imPopup.frame.size.width - 5];

        NSRect placeHolderRect = [_valueField calcuTextBounds:placeHolderString fontSize:12.0 width:200];
        NSRect newRect = placeHolderRect;
        if (_valueText != 0) {
            [_valueField setStringValue:_valueText];
            NSRect textRect = [_valueField calcuTextBounds:_valueField.stringValue fontSize:12.0 width:self.frame.size.width  - originX - _imPopup.frame.size.width - 5 - 5];
            newRect = textRect;
            [_valueField setFrame:NSMakeRect(originX, 0, textRect.size.width + 6, textRect.size.height < TEXTFIELDHEIGHT ? TEXTFIELDHEIGHT:textRect.size.height)];
        }
        else{
            [_valueField setFrame:NSMakeRect(originX, 0, newRect.size.width, newRect.size.height<TEXTFIELDHEIGHT ? TEXTFIELDHEIGHT:newRect.size.height)];
        }

        [[_valueField cell] setPlaceholderString:placeHolderString];
        [_valueField setHandleDelegate:self];
        [self addSubview:_valueField];
        [_valueField setInitialWidth:placeHolderRect.size.width + 6];
        [_valueField setInitialHeight:placeHolderRect.size.height < TEXTFIELDHEIGHT?TEXTFIELDHEIGHT:placeHolderRect.size.height];
        [_valueField setMaxPreferenceWidth:self.frame.size.width - 5 - originX - _imPopup.frame.size.width - 5];
    }
    else{
        int newMaxLayoutWidth = (int)self.frame.size.width - 5 - originX - (int)_imPopup.frame.size.width - 5;
        [_valueField setFrameOrigin:NSMakePoint(originX, _valueField.frame.origin.y)];
        if (newMaxLayoutWidth != _valueField.maxPreferenceWidth) {
                [_valueField setMaxPreferenceWidth:newMaxLayoutWidth];
                [_valueField textDidChange:nil];
        }
        else{
            [_valueField setMaxPreferenceWidth:newMaxLayoutWidth];
        }
    }
    
    [_imPopup setAlignmentRightOriginx:_valueField.frame.origin.x + _valueField.frame.size.width + 5 + _imPopup.frame.size.width];
    if (_valueField.frame.size.width > 26) {
        [_imPopup setFrameOrigin:NSMakePoint(_valueField.frame.size.width + _valueField.frame.origin.x  , _valueField.frame.origin.y + _valueField.frame.size.height - 20)];
    }
    else{
        [_imPopup setFrameOrigin:NSMakePoint(_valueField.frame.size.width + _valueField.frame.origin.x  , _valueField.frame.origin.y + _valueField.frame.size.height - TEXTFIELDHEIGHT)];

    }
    [_imPopup resizeRect];
    
    if (_deleteBtn == nil) {
        _deleteBtn = [[HoverButton alloc] init];
        NSImage *image1 = [StringHelper imageNamed:@"contact_delete1"];
        NSImage *image2 = [StringHelper imageNamed:@"contact_delete2"];
        [_deleteBtn setFrame:NSMakeRect(135, 3, image1.size.width, image1.size.height)];
        [_deleteBtn setImage:image1];
        [_deleteBtn setMouseEnteredImage:image1 mouseExitImage:image1 mouseDownImage:image2];
        [_deleteBtn setBordered:NO];
        [_deleteBtn setHidden:YES];
        [_deleteBtn setTarget:self];
        [_deleteBtn setAction:@selector(deleteAction)];
        [self addSubview:_deleteBtn];
    }
    if (_isEditing) {
        if(!_isEmpty){
            [_deleteBtn setHidden:NO];
        }
        else{
            [_deleteBtn setHidden:YES];
        }
        [_imPopup setEnabled:YES];
        [_valueField setEnabled:YES];
        [_lablePopup setEnabled:YES];
    }
    else{
        [_deleteBtn setHidden:YES];
        [_imPopup setEnabled:NO];
        [_valueField setEnabled:NO];
        [_lablePopup setEnabled:NO];
    }
    NSRect rect = self.frame;
    rect.size.height = _valueField.frame.origin.y + _valueField.frame.size.height + 10;
    if (compHeight != rect.size.height) {
        [self setFrame:rect];
        compHeight = self.frame.size.height;
        if ([_delegate respondsToSelector:@selector(subviewsInBlockFrameChanged:)]) {
            [_delegate subviewsInBlockFrameChanged:self];
        }
    }
}

- (void)popupButtonFrameChanged:(id)sender{
    if(sender == _lablePopup){
        //什么也不做
    }
    else if(sender == _imPopup){
        [self layoutSubViews];
    }
}

- (void)setValueText:(NSString *)valueText{
    [_valueText release];
    _valueText = [valueText retain];
    [_valueField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_valueField setStringValue:valueText];
}

- (void)textFieldFrameChanged:(id)sender{
    [self layoutSubViews];
}

- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize width:(CGFloat)width{
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        float textWidth = textSize.width;
        
        float height = textSize.height;
        if (textWidth > width) {
            textWidth = width;
            height = [self heightForStringDrawing:text fontSize:fontSize myWidth:textWidth] + 5;
        }
        
        textBounds = NSMakeRect(0, 0, width, height);
    }
    return textBounds;
}

- (float)heightForStringDrawing:(NSString *)myString fontSize:(float)fontSize myWidth:(float) myWidth {
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(myWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setAlignment:NSLeftTextAlignment];
    [textParagraph setLineSpacing:5];
    [textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:fontSize],NSFontAttributeName,nil];
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager
            usedRectForTextContainer:textContainer].size.height;
}


- (void)setImArr:(NSArray *)imArr{
    [_imArr release];
    _imArr = [imArr retain];
    [_imPopup setTitlesArr:imArr];
    [_imPopup resizeRect];
}


- (void)setLabelsArr:(NSArray *)labelsArr{
    [_labelsArr release];
    _labelsArr = [labelsArr retain];
    [_lablePopup setTitlesArr:labelsArr];
    [_lablePopup resizeRect];
}

- (void)setLableType:(NSString *)lableType{
    [_lableType release];
    _lableType = [lableType retain];
    if (_labelsArr != nil) {
        NSUInteger index = [_labelsArr indexOfObject:lableType];
        [_lablePopup selectItemAtIndex:index ];
    }
}

- (void)setServiceType:(NSString *)serviceType{
    [_servicetype release];
    _servicetype = [serviceType retain];
    if (_imArr != nil) {
        NSUInteger index = [_imArr indexOfObject:serviceType];
        [_imPopup selectItemAtIndex:index];
    }
}

- (void)setDisplayValue:(NSString *)displayValue{
    [_valueField setStringValue:displayValue];
    
}

- (void)deleteAction{
    if ([_delegate respondsToSelector:@selector(removedFromSuperView:)]) {
        [_delegate removedFromSuperView:self];
    }
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    [_deleteBtn setHidden:!isEditing];
    [self layoutSubViews];
}

- (BOOL)isFlipped{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
