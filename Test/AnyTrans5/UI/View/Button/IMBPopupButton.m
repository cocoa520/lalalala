//
//  IMBPopupButton.m
//  NewMacTestApp
//
//  Created by iMobie on 5/29/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBPopupButton.h"
#import "IMBContactEntity.h"
#import "StringHelper.h"
#import "IMBPopUpButtonCell.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
#define SCROLLERWITH 30

@implementation IMBPopupButton
@synthesize alignmentRightOriginx = _alignmentRightOriginx;
@synthesize titlesArr = _titlesArr;
@synthesize delegate = _delegate;
@synthesize bindingEntity = _bindingEntity;
@synthesize bindingEntityKeyPath = _bindingEntityKeyPath;
@synthesize maxTitleWidth= _maxTitleWidth;
@synthesize hasBorderLine = _hasBorderLine;
@synthesize noMaxWidth = _noMaxWidth;
@synthesize isEditView = _isEditView;
@synthesize isAirBackup = _isAirBackup;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _alignmentRightOriginx = 0;
        [self.cell setArrowPosition:NSPopUpNoArrow];
        [self.cell setImagePosition:NSImageOnly];
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        _alignmentRightOriginx = 0;
        [self initView];
    }
    return self;
}

- (void)awakeFromNib{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [self initView];
}

- (void)changeSkin:(NSNotification *) noti {
    [_arrImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_arrBgView setFrameOrigin:NSMakePoint(0, 4)];
    }else {
        [_arrBgView setFrameOrigin:NSMakePoint(self.frame.size.width-13, 4)];
    }
    if (![StringHelper stringIsNilOrEmpty:self.title]) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:self.title]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, attributedTitles.length)];
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, attributedTitles.length)];
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, attributedTitles.length)];
        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
        [self setAttributedTitle:attributedTitles];
    }
    [self setNeedsDisplay:YES];
}

- (void)viewDidMoveToSuperview{
//
}

- (void)dealloc{
    if(_bindingEntity != nil){
        [_bindingEntity release];
        _bindingEntity = nil;
    }
    if (_bindingEntityKeyPath != nil) {
        [_bindingEntityKeyPath release];
        _bindingEntityKeyPath = nil;
    }
    if (_defaultlabelArr != nil) {
        [_defaultlabelArr release];
        _defaultlabelArr = nil;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

- (void)setFrame:(NSRect)frameRect{
    [super setFrame:frameRect];
}

- (void)setAlignmentRightOriginx:(float)alignmentRightOriginx{
    _alignmentRightOriginx = alignmentRightOriginx;
}

- (void)initView{
    [self setBordered:NO];
    [self setFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [self setAlignment:NSLeftTextAlignment];
    [self setTarget:self];
    [self setAction:@selector(selectionChanged:)];
    
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        _arrBgView = [[[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 4, 16, 16)] autorelease];
        _arrImageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(1, 0, 16, 16)] autorelease];
        [_arrImageView setTag:100];
    }else {
        if (_isEditView) {
            _arrBgView = [[[IMBWhiteView alloc] initWithFrame:NSMakeRect(self.frame.size.width-20, 2, 16, 16)] autorelease];
        } else {
            _arrBgView = [[[IMBWhiteView alloc] initWithFrame:NSMakeRect(self.frame.size.width-15, 4, 16, 16)] autorelease];
        }
        
        _arrImageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)] autorelease];
        [_arrImageView setTag:100];
    }
    [_arrBgView setBackgroundColor:[NSColor clearColor]];
    [_arrImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [_arrBgView addSubview:_arrImageView];
  
    [self addSubview:_arrBgView];
    if (![StringHelper stringIsNilOrEmpty:self.title]) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:self.title]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, attributedTitles.length)];
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, attributedTitles.length)];
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, attributedTitles.length)];
        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
        [self setAttributedTitle:attributedTitles];
    }
    
    
//    IMBPopUpButtonCell *cell = [[IMBPopUpButtonCell alloc] init];
//    [self setCell:cell];
//    [cell release];
//    cell = nil;
    
    firstSet = NO;
}

- (void)setTitlesArr:(NSArray *)titlesArr{
    [_titlesArr release];
    _titlesArr = [titlesArr retain];
    [self removeAllItems];
    [self addItemsWithTitles:_titlesArr];
    if (_titlesArr.count > 1) {
        [[self menu] insertItem:[NSMenuItem separatorItem] atIndex:_titlesArr.count - 1];
    }
    if (!firstSet && _titlesArr.count > 1) {
        firstSet = true;
       NSMutableArray *defaultlabelArr = [[NSMutableArray alloc] initWithArray:_titlesArr];
        [defaultlabelArr removeLastObject];
        _defaultlabelArr = [defaultlabelArr retain];
        [defaultlabelArr release];
    }
}

- (void)caculateMaxWidth{
    float titleWidth = 0;
    for (NSString *title in _titlesArr) {
        int newWidth = [IMBPopupButton calcuTextBounds:title fontSize:12.0].size.width;
        if (newWidth > titleWidth) {
            titleWidth = newWidth;
        }
    }
    _maxTitleWidth = titleWidth;
}

- (void)calculateTitleWidth{
    NSString *title = self.title;
    float titleWidth = [IMBPopupButton calcuTextBounds:title fontSize:12.0].size.width;
    if (_noMaxWidth) {
        _maxTitleWidth = titleWidth;
    }else if (_isAirBackup) {
        if (titleWidth < 54) {
            _maxTitleWidth = 54;
        } else {
            _maxTitleWidth = titleWidth;
        }
    }else {
        if(titleWidth > 70){
            titleWidth = 70;
        }
        _maxTitleWidth = titleWidth;
    }
    
    
}

+ (CGFloat)calcuateTextWidth:(NSString *)text{
    CGFloat titleWidth = [IMBPopupButton calcuTextBounds:text fontSize:12.0].size.width;
    return titleWidth;
}

- (IBAction)selectionChanged:(id)sender{
    [self calculateTitleWidth];
    [self resizeRect];
    if (_bindingEntityKeyPath.length > 0 && _bindingEntity != nil) {
        [_bindingEntity unbind:_bindingEntityKeyPath];
        [_bindingEntity bind:_bindingEntityKeyPath toObject:self
                 withKeyPath:@"title" options:@{}];
        if ([_bindingEntity isKindOfClass:[IMBContactBaseEntity class]]) {
            IMBContactBaseEntity *binding = _bindingEntity;
            if (self.title.length > 0 && ![_defaultlabelArr containsObject:self.title]) {
                binding.type = @"other";
            }
            else{
//                binding.type = self.title;
                binding.type = @"other";
            }
        }
    }
    if (self.title.length >0 && [self.title isEqualToString:[_titlesArr lastObject]]) {
        [self setTitle:_lastDisplayedTitle];
        [[NSNotificationCenter defaultCenter] postNotificationName:OPENSHEETNOTIFICATION object:self];
        return;
    }
    else{
        _lastDisplayedTitle = self.title;
    }
    
    
    if ([_delegate respondsToSelector:@selector(popupButtonFrameChanged:)]) {
        [_delegate popupButtonFrameChanged:self];
    }
}

- (void)setTitle:(NSString *)aString{
    [super setTitle:aString];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:aString];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.length)];//[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
    [as setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as.length)];
    [self setAttributedTitle:as];
    [as release], as = nil;
//    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
//    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
//    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_lastDisplayedTitle?_lastDisplayedTitle:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
//    [super setAttributedTitle:title];
    
    if (_lastDisplayedTitle.length == 0) {
        _lastDisplayedTitle = aString;
    }
    [self selectionChanged:self];
    
    [self setNeedsDisplay:YES];
}

- (void)resizeRect{
    float titleWidth = _maxTitleWidth;
    [self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, titleWidth + SCROLLERWITH,self.frame.size.height)];
    if (_alignmentRightOriginx != 0 && self.frame.origin.x + titleWidth + SCROLLERWITH > _alignmentRightOriginx) {
        NSRect rect = self.frame;
        rect.origin.x -= (rect.origin.x + titleWidth + SCROLLERWITH) - _alignmentRightOriginx;
        rect.size.height += 4;
        [self setFrame:rect];
    }
    
    if (_alignmentRightOriginx > self.frame.origin.x + SCROLLERWITH) {
        NSRect rect = self.frame;
        rect.origin.x += _alignmentRightOriginx - (rect.origin.x + titleWidth + SCROLLERWITH);
        [self setFrame:rect];
    }
    
    if (self.frame.size.height != 20) {
        NSRect rect = self.frame;
        rect.size.height = 20;
        [self setFrame:rect];
    }
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_arrBgView setFrameOrigin:NSMakePoint(0, 4)];
    }else {
        if (_isEditView) {
            [_arrBgView setFrameOrigin:NSMakePoint(self.frame.size.width-17, 2)];
        } else {
            [_arrBgView setFrameOrigin:NSMakePoint(self.frame.size.width-13, 4)];
        }
        
    }
}

- (void)selectItemAtIndex:(NSInteger)index{
    [super selectItemAtIndex:index];
    if (_lastDisplayedTitle.length == 0) {
        _lastDisplayedTitle = [self title];
    }
    [self selectionChanged:self];
//    NSLog(@"select index:%d",index);
}

+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize{
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
        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
    }
    return textBounds;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
//    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
//    [path fill];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_lastDisplayedTitle?_lastDisplayedTitle:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
    int width = title.size.width + 10*3;
    NSRect rect ;
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        rect = NSMakeRect(ceilf((NSWidth(self.frame) - width - 8)/2.0 + 17)+5 - 30, ceilf((NSHeight(self.frame) - title.size.height)/2.0), width, title.size.height);
    }else {
        if (_isEditView) {
            if (_isAirBackup) {
                rect = NSMakeRect(ceilf((NSWidth(self.frame) - width - 8)/2.0 + 17)-5, ceilf((NSHeight(self.frame) - title.size.height)/2.0) - 2, width, title.size.height);
            } else {
                rect = NSMakeRect(ceilf((NSWidth(self.frame) - width - 8)/2.0 + 17)-8, ceilf((NSHeight(self.frame) - title.size.height)/2.0) - 2, width, title.size.height);
            }
        } else {
            rect = NSMakeRect(ceilf((NSWidth(self.frame) - width - 8)/2.0 + 17)-4, ceilf((NSHeight(self.frame) - title.size.height)/2.0), width, title.size.height);
        }
        
    }
    [title drawInRect:rect];
    if (_hasBorderLine) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [path setLineWidth:2.0];
        [path addClip];
        [path setWindingRule:NSEvenOddWindingRule];
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] setStroke];
        [path stroke];
    }
}


@end
