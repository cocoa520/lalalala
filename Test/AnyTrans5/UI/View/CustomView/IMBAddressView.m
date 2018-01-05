//
//  IMBAddressView.m
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBAddressView.h"
#import "IMBCommonEnum.h"
#import "StringHelper.h"
#define ORIGINXOFFSET 0
#define EDITINGORIGINOFFSET 124

#define POPUPRIGHTORIGINX 120


@implementation IMBAddressView
@synthesize  labelArr = _labelArr;
@synthesize  keyString = _keyString;
@synthesize addressEntity = _addressEntity;
@synthesize isLastItem = _isLastItem;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_labelArr != nil)
    {
        [_labelArr release];
        _labelArr = nil;
    }
    
    if (_keyString != nil) {
        [_keyString release];
        _keyString = nil;
    }
    
    if (_addressEntity != nil) {
        [_addressEntity release];
        _addressEntity = nil;
    }
    [super dealloc];
}

- (BOOL)hasEnoughWidth:(NSView *)beforeView selfView:(NSView *)selfView{
    if (self.frame.size.width - beforeView.frame.origin.x - beforeView.frame.size.width > selfView.frame.size.width + 2) {
        return YES;
    }
    return NO;
}

- (void)awakeFromNib{
    [self initSubViews];
}

- (void)viewDidMoveToSuperview{
    [self initSubViews];
}

- (void)initSubViews{
    [self setIsEditing:NO];
    _deleteBtn = [[HoverButton alloc] init];
    [_deleteBtn setBordered:NO];
    NSImage *image1 = [StringHelper imageNamed:@"contact_delete1"];
    NSImage *image2 = [StringHelper imageNamed:@"contact_delete2"];
    [_deleteBtn setFrame:NSMakeRect(135, 3, image1.size.width, image1.size.height)];
    [_deleteBtn setImage:image1];
    [_deleteBtn setMouseEnteredImage:image1 mouseExitImage:image1 mouseDownImage:image2];
    [_deleteBtn setHidden:YES];
    [_deleteBtn setTarget:self];
    [_deleteBtn setAction:@selector(deleteAction)];
    [self addSubview:_deleteBtn];
    [self viewLayoutChanged];
    _compHeight = self.frame.size.height;
}

- (void)deleteAction{
    if ([_delegate respondsToSelector:@selector(removedFromSuperView:)]) {
        [_delegate removedFromSuperView:self];
    }
}

- (void)setIsEditing:(BOOL)isEditing{
    if (isEditing != _isEditing) {
        isEditingChanged = true;
    }
    _isEditing = isEditing;
    [self viewLayoutChanged];
}

- (void)setKeyString:(NSString *)keyString{
    [_keyString release];
    _keyString = [keyString retain];
    [_popupButton setTitle:_keyString];
}

- (void)textFieldFrameChanged:(id)sender{
    if (!isEditingChanged) {
        [self viewLayoutChanged];
    }
}

- (BOOL)isFlipped{
    return YES;
}

- (void)viewLayoutChanged{
    NSMutableArray *viewArr = [[NSMutableArray alloc] init];
    CGFloat originX = 0;
    CGFloat originY = 0;
    if (_popupButton == nil) {
        _popupButton = [[IMBPopupButton alloc] init];
        [_popupButton setBindingEntity:_addressEntity];
        [_popupButton setBindingEntityKeyPath:@"label"];
        [_popupButton setAlignmentRightOriginx:POPUPRIGHTORIGINX];
        
        if (_labelArr != nil) {
            [_popupButton setTitlesArr:_labelArr];
        }
        if (_keyString != nil) {
            if (_labelArr != nil) {
                NSUInteger index = [_labelArr indexOfObject:_keyString];
                [_popupButton selectItemAtIndex:index];
            }
        }
        else{
            [self setKeyString:CustomLocalizedString(@"contact_id_5", nil)];
            [_popupButton selectItemAtIndex:0];
            
        }
        [_popupButton setFrameOrigin:NSMakePoint(30 + ORIGINXOFFSET, 0)];
        [_popupButton resizeRect];
        [self addSubview:_popupButton];
    }
    
    if (_isEditing) {
        NSPoint originPoint = _popupButton.frame.origin;
        originPoint.x = 30 + EDITINGORIGINOFFSET;
        originPoint.y = originPoint.y;
        [_popupButton setFrameOrigin:originPoint];
        [_popupButton setAlignmentRightOriginx: POPUPRIGHTORIGINX + EDITINGORIGINOFFSET];
        [_popupButton resizeRect];
        if (!_isEmpty) {
            [_deleteBtn setHidden:NO];
        }
        else{
            [_deleteBtn setHidden:YES];
        }
        [_popupButton setEnabled:YES];
        [_StreetField setEditable:YES];
        [_CityField setEditable:YES];
        [_StateField setEditable:YES];
        [_ZIPField setEditable:YES];
        [_CountryField setEditable:YES];
        [_CountryCodeField setEditable:YES];

    }
    else{
        NSPoint originPoint = _popupButton.frame.origin;
        originPoint.x = 30 + ORIGINXOFFSET;
        originPoint.y = originPoint.y;
        [_popupButton setFrameOrigin:originPoint];
        [_popupButton setAlignmentRightOriginx:POPUPRIGHTORIGINX + ORIGINXOFFSET];
        [_popupButton resizeRect];
        [_deleteBtn setHidden:YES];
        [_popupButton setEnabled:NO];
        [_StreetField setEditable:NO];
        [_CityField setEditable:NO];
        [_StateField setEditable:NO];
        [_ZIPField setEditable:NO];
        [_CountryField setEditable:NO];
        [_CountryCodeField setEditable:NO];
    }

    /*Street,City,State,Zip,Country,CountryCode*/
    [viewArr addObject:_popupButton];
    originX += _popupButton.frame.origin.x + _popupButton.frame.size.width + 5;
    [self layoutSingeView:_StreetField placeHolder:CustomLocalizedString(@"contact_id_52", nil) size:12.0 originX:&originX originY:&originY viewArr:viewArr viewLayoutChanged:isEditingChanged];
    
    [self layoutSingeView:_CityField placeHolder:CustomLocalizedString(@"contact_id_53", nil) size:12.0 originX:&originX originY:&originY viewArr:viewArr viewLayoutChanged:isEditingChanged];
    
    [self layoutSingeView:_StateField placeHolder:CustomLocalizedString(@"contact_id_50", nil) size:12.0 originX:&originX originY:&originY viewArr:viewArr viewLayoutChanged:isEditingChanged];
    
    [self layoutSingeView:_ZIPField placeHolder:CustomLocalizedString(@"contact_id_51", nil) size:12.0 originX:&originX originY:&originY viewArr:viewArr viewLayoutChanged:isEditingChanged];
    
    [self layoutSingeView:_CountryField placeHolder:CustomLocalizedString(@"contact_id_49", nil) size:12.0 originX:&originX originY:&originY viewArr:viewArr viewLayoutChanged:isEditingChanged];
    
    [self layoutSingeView:_CountryCodeField placeHolder:CustomLocalizedString(@"contact_id_80", nil) size:12.0 originX:&originX originY:&originY viewArr:viewArr viewLayoutChanged:isEditingChanged];

    
    IMBTextField *textField= [viewArr lastObject];
    CGFloat newHeight =  textField.frame.origin.y + textField.frame.size.height + 10;
    [self setFrameSize:NSMakeSize(self.frame.size.width, newHeight)];
    [viewArr release];
    if (isEditingChanged) {
        isEditingChanged = false;
        [self viewLayoutChanged];
    }
    if (compHeight != self.frame.size.height) {
        _compHeight = self.frame.size.height;
        if ([_delegate respondsToSelector:@selector(subviewsInBlockFrameChanged:)]) {
            [_delegate subviewsInBlockFrameChanged:self];
        }
    }
}


- (void)layoutSingeView:(IMBTextField *)textField placeHolder:(NSString *)placeHolder size:(float)size originX:(CGFloat *)originX originY:(CGFloat *)originY viewArr:(NSMutableArray *)viewArr viewLayoutChanged:(BOOL)isChanged{
    
    if (isChanged) {
        [textField setFrameSize:NSMakeSize(0, 0)];
    }
    IMBPopupButton *popupButton = [viewArr count] >= 1 ? [viewArr objectAtIndex:0] : nil;
    CGFloat oriX = popupButton.frame.size.width + popupButton.frame.origin.x + 5;
    if (textField != nil) {
        [viewArr addObject:textField];
        
        NSRect rect = [textField calcuTextBounds:placeHolder fontSize:size width:200];
        
        if (textField.frame.size.width == 0 || textField.frame.size.height == 0) {
            
            [textField setFontSize:size];
            [textField setMaxPreferenceWidth:self.frame.size.width - oriX - 5];
            NSRect newRect = rect;
            if (textField.stringValue.length != 0) {
                NSRect textRect = [textField calcuTextBounds:textField.stringValue fontSize:size width:self.frame.size.width - *originX - 5];
                [textField setFrame:NSMakeRect(*originX, *originY, textRect.size.width + 6, textRect.size.height)];
                newRect = textRect;
            }
            else{
                [textField setFrame:NSMakeRect(*originX, *originY, rect.size.width + 6, rect.size.height)];
                
                
            }
            if (*originX + newRect.size.width > self.frame.size.width ) {
                NSUInteger index = [viewArr count] > 2 ? [viewArr count] - 1 : 0;
                if (index > 1) {
                    NSView *view = [viewArr objectAtIndex:index - 1];
                    *originY += view.frame.size.height + 5;
                    *originX = oriX;
                }
                else{
                    *originY += 0;
                    *originX = oriX;
                    
                }
                
            }
            [[textField cell] setPlaceholderString:placeHolder];
            [textField  setHandleDelegate:self];
            [self addSubview:textField];
            [textField setInitialWidth:rect.size.width + 6];
            [textField setInitialHeight:rect.size.height];
            
            [textField setMaxPreferenceWidth:self.frame.size.width - oriX -5];
            
        }
        else{
            NSRect rect = textField.frame;
            if (*originX + rect.size.width > self.frame.size.width ) {
                NSArray *array = self.subviews;
                NSUInteger index = [array indexOfObject:textField];
                if (index > 1) {
                    NSView *view = [array objectAtIndex:index - 1];
                    *originY = view.frame.origin.y + view.frame.size.height + 5;
                    *originX = oriX;
                }
                else{
                    *originY += 0;
                    *originX = oriX;
                    
                }
                
            }
            [textField setFrameOrigin:NSMakePoint(*originX, *originY)];
        }
        *originX += textField.frame.size.width + 5;
        if ([textField singleLineHeight] < textField.frame.size.height) {
            *originY += textField.frame.size.height + 5;
            *originX = oriX;
        }
    }
    else{

    }
}

- (void)setLabelArr:(NSArray *)labelArr{
    [_labelArr release];
    _labelArr = [labelArr retain];
    [_popupButton setTitlesArr:_labelArr];
    [_popupButton resizeRect];
}

- (void)setState:(NSString *)state{
    if (_StateField == nil) {
        _StateField = [[IMBTextField alloc] init];
        [_StateField setBindingEntity:_addressEntity];
        [_StateField setBindingEntityKeyPath:@"state"];
    }
    [_StateField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_StateField setStringValue:(state == nil?@"":state)];
}

- (void)setCountry:(NSString *)country{
    if (_CountryField == nil) {
        _CountryField = [[IMBTextField alloc] init];
        [_CountryField setBindingEntity:_addressEntity];
        [_CountryField setBindingEntityKeyPath:@"country"];

    }
    [_CountryField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_CountryField setStringValue:(country == nil?@"":country)];
}

- (void)setCountryCode:(NSString *)countryCode{
    if (_CountryCodeField == nil) {
        _CountryCodeField = [[IMBTextField alloc] init];
        [_CountryCodeField setBindingEntity:_addressEntity];
        [_CountryCodeField setBindingEntityKeyPath:@"countryCode"];

    }
    [_CountryCodeField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_CountryCodeField setStringValue:(countryCode == nil?@"":countryCode)];
}


- (void)setZip:(NSString *)zip{
    if (_ZIPField == nil) {
        _ZIPField = [[IMBTextField alloc] init];
        [_ZIPField setBindingEntity:_addressEntity];
        [_ZIPField setBindingEntityKeyPath:@"postalCode"];

    }
    [_ZIPField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_ZIPField setStringValue:(zip == nil?@"":zip)];
}

- (void)setCity:(NSString *)city{
    if (_CityField == nil) {
        _CityField = [[IMBTextField alloc] init];
        [_CityField setBindingEntity:_addressEntity];
        [_CityField setBindingEntityKeyPath:@"city"];
    }
    [_CityField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_CityField setStringValue:(city == nil?@"":city)];
}

- (void)setStreet:(NSString *)street{
    if (_StreetField == nil) {
        _StreetField = [[IMBTextField alloc] init];
        [_StreetField setBindingEntity:_addressEntity];
        [_StreetField setBindingEntityKeyPath:@"street"];
    }
    [_StreetField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_StreetField setStringValue:(street == nil?@"":street)];
}

- (NSString *)state{
    return _StateField.stringValue;
}

- (NSString *)country{
    return _CountryField.stringValue;
}

- (NSString *)zip{
    return _ZIPField.stringValue;
}

- (NSString *)city{
    return _CityField.stringValue;
}

- (NSString *)street{
    return _StateField.stringValue;
}

- (NSString *)countryCode{
    return _CountryCodeField.stringValue;
}

- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize width:(CGFloat)width{
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:text?:@""];
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
    
    NSRect textBounds = NSMakeRect(0, 0, width, height);
    return textBounds;
}

- (float)heightForStringDrawing:(NSString *)myString fontSize:(float)fontSize myWidth:(float) myWidth {
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString?:@""] autorelease];
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
    [super drawRect:dirtyRect];
//    float Red = (random()%255 + 1.0);
//    float Green = (rand()%255 + 1.0);
//    float Blue = (rand()%255 + 1.0);
//    [[NSColor colorWithDeviceRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:1.0] set];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}

@end
