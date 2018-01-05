//
//  IMBKeyValueView.m
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBKeyValueView.h"
#import "StringHelper.h"
#define EDITINGOFFSETX 124
#define NOTEDITOFFSET 0
#define TEXTFIELDHEIGHT 16
#define POPUPRIGHTORIGINX 120

@implementation IMBKeyValueView

@synthesize key = _key;
@synthesize valueObj = _valueObj;
@synthesize labelArr = _labelArr;
@synthesize contactKeyValueEntity = _contactKeyValueEntity;
@synthesize isDateType = _isDateType;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)initView{
    [self initSubviews];
    compHeight = self.frame.size.height;
}

- (void)viewDidMoveToSuperview{
    [super viewDidMoveToSuperview];
    [self initSubviews];
}

- (void)textFieldFrameChanged:(id)sender{
    if (sender == _textFiled) {
        [self viewLayoutChanged];
        if (compHeight != self.frame.size.height) {
            if ([_delegate respondsToSelector:@selector(subviewsInBlockFrameChanged:)]) {
                [_delegate subviewsInBlockFrameChanged:self];
                compHeight = self.frame.size.height;
            }
        }
    }
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    [self viewLayoutChanged];

}

- (void)setLabelArr:(NSArray *)labelArr{
    [_labelArr release];
    _labelArr = [labelArr retain];
    [_popupButton setTitlesArr:labelArr];
}

- (void)setValueObj:(id)value{
    [_valueObj release];
    _valueObj = [value retain];
    if ([value isKindOfClass:[NSString class]] || value == nil) {
        _isDateType = NO;
        [_textFiled setStringValue:value== nil?@"":value];
    }
    else if([value isKindOfClass:[NSDate class]]){
        _isDateType = YES;
        [_textFiled setHidden:YES];
        [_datePicker setDateValue:value];
    }
}

- (void)setIsDateType:(BOOL)isDateType{
    _isDateType = isDateType;
    [_textFiled setHidden:YES];
    
}

- (void)setKey:(NSString *)key{
    if (_labelArr != nil) {
        [_key release];
        _key = [key retain];
        if (_key.length != 0) {
            if(![_labelArr containsObject:_key] && _labelArr.count > 1){
                NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:_labelArr];
                [mutableArr insertObject:_key atIndex:(_labelArr.count -1)];
                [self setLabelArr:mutableArr];
                [mutableArr release];
            }
            NSUInteger index = [_labelArr indexOfObject:key];
            [_popupButton selectItemAtIndex:index ];
        }
        else{
            [_popupButton selectItemAtIndex:0];
        }
    }
    else{
        return;
    }
}

- (void)setType:(NSString *)type{
    _type = type;
    if (_textFiled != nil) {
        [_textFiled.cell setPlaceholderString:_type];
    }
}

- (void)dealloc{
    if (_textFiled != nil) {
        [_textFiled release];
        _textFiled = nil;
    }
    if (_popupButton != nil) {
        [_popupButton release];
        _popupButton = nil;
    }
    if (_deleteBtn != nil) {
        [_deleteBtn release];
        _deleteBtn = nil;
    }
    if (_key != nil) {
        [_key release];
        _key = nil;
    }
    if (_valueObj != nil) {
        [_valueObj release];
        _valueObj = nil;
    }
    if (_labelArr != nil) {
        [_labelArr release];
        _labelArr = nil;
    }
    if (_type != nil) {
        [_type release];
        _type = nil;
    }
    if (_contactKeyValueEntity != nil) {
        [_contactKeyValueEntity release];
        _contactKeyValueEntity = nil;
    }
    
    [super dealloc];
}

- (void)initSubviews{
    _isEditing = NO;
    [self viewLayoutChanged];
}

- (NSString *)key{
    return _key;
}

- (id)valueObj{
    return _valueObj;
}

- (BOOL)isEditing{
    return _isEditing;
}

- (NSString *)type{
    return _type;
}

- (NSArray *)labelArr{
    return _labelArr;
}


- (void)viewLayoutChanged{
    if (_popupButton == nil) {
        _popupButton = [[IMBPopupButton alloc] init];
        [_popupButton setAlignmentRightOriginx:POPUPRIGHTORIGINX];
        //TODO:_type在提交时确定
        [_popupButton setBindingEntity:_contactKeyValueEntity];
        [_popupButton setBindingEntityKeyPath:@"label"];
        
        if (_labelArr != nil) {
            [_popupButton setTitlesArr:_labelArr];
        }
        if (_key != nil) {
            if (_labelArr != nil) {
                NSUInteger index = [_labelArr indexOfObject:_key];
                [_popupButton selectItemAtIndex:index];
            }
        }
        else{
            [self setKey:CustomLocalizedString(@"contact_id_94", nil)];
            [_popupButton selectItemAtIndex:0];

        }
        [_popupButton setFrameOrigin:NSMakePoint(30 + NOTEDITOFFSET, 0)];
        [_popupButton resizeRect];
        [self addSubview:_popupButton];
    }

    if (_isEditing) {
        [_popupButton setFrameOrigin:NSMakePoint(30  + EDITINGOFFSETX,  0)];
        [_popupButton setAlignmentRightOriginx: POPUPRIGHTORIGINX + EDITINGOFFSETX];
        [_popupButton resizeRect];
        if (!_isEmpty) {
            [_deleteBtn setHidden:NO];
        }
        else{
            [_deleteBtn setHidden:YES];
        }
    }
    else{
        [_popupButton setFrameOrigin:NSMakePoint(30 + NOTEDITOFFSET, 0)];
        [_popupButton setAlignmentRightOriginx:POPUPRIGHTORIGINX + NOTEDITOFFSET];
        [_popupButton resizeRect];
        [_deleteBtn setHidden:YES];
    }

    
    int originX = (int)_popupButton.frame.origin.x + (int)_popupButton.frame.size.width + 5;
    if (!_isDateType){
        if (_textFiled == nil) {
            NSString *placeHolderString = [self getTypeStrWithCategory:_contactKeyValueEntity.contactCategory];
            _textFiled = [[IMBTextField alloc] init];
            [_textFiled setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
            [_textFiled setBindingEntity:_contactKeyValueEntity];
            [_textFiled setBindingEntityKeyPath:@"value"];
            
            [_textFiled setFontSize:12.0];
            [_textFiled setMaxPreferenceWidth:self.frame.size.width - originX - 5];
            NSRect placeHolderRect = [_textFiled calcuTextBounds:placeHolderString fontSize:12.0 width:200];
            NSRect newRect = placeHolderRect;
            if (![_valueObj isKindOfClass:[NSDate class]] && _valueObj.length != 0) {
                [_textFiled setStringValue:_valueObj];
                NSRect textRect = [_textFiled calcuTextBounds:_valueObj fontSize:12.0 width:self.frame.size.width - 5 - originX];
                newRect = textRect;
                [_textFiled setFrame:NSMakeRect(originX, 0, textRect.size.width+ 6, textRect.size.height )];
            }
            else{
                [_textFiled setFrame:NSMakeRect(originX, 0, newRect.size.width + 6, newRect.size.height)];
            }
            [[_textFiled cell] setPlaceholderString:placeHolderString];
            [_textFiled setHandleDelegate:self];
            [self addSubview:_textFiled];
            [_textFiled setInitialWidth:placeHolderRect.size.width + 6];
            [_textFiled setInitialHeight:placeHolderRect.size.height];
            [_textFiled setMaxPreferenceWidth:self.frame.size.width - 5 - originX];
        }
        else{
            int newMaxLayoutWidth = (int)self.frame.size.width - 5 - originX;
            [_textFiled setFrameOrigin:NSMakePoint(originX, _textFiled.frame.origin.y)];
            if (newMaxLayoutWidth != _textFiled.maxPreferenceWidth) {
                [_textFiled setMaxPreferenceWidth:newMaxLayoutWidth];
                [_textFiled textDidChange:nil];
            }
            else{
                [_textFiled setMaxPreferenceWidth:newMaxLayoutWidth];
            }
            
        }
        //不判断_textfield存在的情况，因为IMBTextField已实现自适应

    }
    
   else {
        if (_datePicker == nil) {
            _datePicker = [[IMBDatePicker alloc] init];
            [_datePicker setFrameOrigin:NSMakePoint(originX, 5)];
//            [_datePicker setFrameSize:_textFiled.frame.size];
            [_datePicker setDateValue:_contactKeyValueEntity.value];
            [_datePicker setBindingEntity:_contactKeyValueEntity];
            [_datePicker setBindingEntityKeyPath:@"value"];
            [_datePicker setHandleDelegate:self];
            [self addSubview:_datePicker];
            if(_valueObj != nil){
                [_datePicker setDateValue:(NSDate *)_valueObj];
            }
            [_textFiled release];
            _textFiled = nil;
        }
        else{
            [_datePicker setFrameOrigin:NSMakePoint(originX, _datePicker.frame.origin.y)];
        }
    }
    
    if (_deleteBtn == nil) {
        _deleteBtn = [[HoverButton alloc] init];
        [_deleteBtn setBordered:NO];
        NSImage *image1 = [StringHelper imageNamed:@"contact_delete1"];
        NSImage *image2 = [StringHelper imageNamed:@"contact_delete2"];
        [_deleteBtn setFrame:NSMakeRect(135, 3, image1.size.width, image1.size.height)];
        [_deleteBtn setImage:image1];
        [_deleteBtn setMouseEnteredImage:image1 mouseExitImage:image1 mouseDownImage:image2];
        [_deleteBtn setFrameSize:NSMakeSize(image1.size.width, image1.size.height)];
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
        [_popupButton setEnabled:YES];
        [_textFiled setEnabled:YES];
        [_datePicker setEnabled:YES];
    }
    else{
        [_deleteBtn setHidden:YES];
        [_popupButton setEnabled:NO];
        [_textFiled setEnabled:NO];
        [_datePicker setEnabled:NO];
    }
    
    NSRect rect = self.frame;
    if(_isDateType){
        [self setFrame:NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, _datePicker.frame.origin.y + _datePicker.frame.size.height + 10)];
    }
    else{
        [self setFrame:NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, _textFiled.frame.origin.y + _textFiled.frame.size.height + 10)];
    }
}

- (NSString *)getTypeStrWithCategory:(ContactCategoryEnum)contactCategoryEnum{
    NSString *string = @"";
    switch (contactCategoryEnum) {
        case Contact_PhoneNumber:
            string = CustomLocalizedString(@"contact_id_41", nil);
            break;
        case Contact_EmailAddressNumber:
            string = CustomLocalizedString(@"contact_id_42", nil);
            break;
        case Contact_RelatedName:
            string = CustomLocalizedString(@"contact_id_44", nil);
            break;
        case Contact_Date:
            string = CustomLocalizedString(@"contact_id_47", nil);
            break;
        case Contact_URL:
            string = CustomLocalizedString(@"contact_id_43", nil);
            break;
        default:
            break;
    }
    return string;
}

- (BOOL)isFlipped{
    return YES;
}

- (void)deleteAction{
    if ([_delegate respondsToSelector:@selector(removedFromSuperView:)]) {
        [_delegate removedFromSuperView:self];
    }
}

- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize width:(CGFloat)width{
    if (text.length > 50) {
        text = [text substringToIndex:47];
        text = [text stringByAppendingString:@"..."];
    }
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
        
        textBounds = NSMakeRect(0, 0, textWidth, height);
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

- (void)drawRect:(NSRect)dirtyRect
{
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


@end
