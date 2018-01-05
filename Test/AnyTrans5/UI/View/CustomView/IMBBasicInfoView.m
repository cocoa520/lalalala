//
//  IMBBasicInfoView.m
//  NewMacTestApp
//
//  Created by iMobie on 6/11/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBBasicInfoView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "MediaHelper.h"
#import "TempHelper.h"
#define NAMEFONTSIZE 18
#define NORMALFONTSIZE 12
#define ORIGINXOFFSET 60
#define NOEDITINGWIDTH 520
#define EDITINGWIDTH 480
#define EDITINGORIGINOFFSET 100

#define LeftMarginToImageView 25



@implementation IMBBasicInfoView
@synthesize isEditing = _isEditing;
@synthesize delegate = _delegate;
@synthesize image = _image;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize displayAsCompany = _displayAsCompany;
@synthesize jobTitle = _jobTitle;
@synthesize title = _title;
@synthesize companyName = _companyName;
@synthesize department = _department;
@synthesize birthday = _birthday;
@synthesize nickName = _nickName;
@synthesize notes = _notes;
@synthesize middleName = _middleName;
@synthesize lastNameYomi = _lastNameYomi;
@synthesize suffix = _suffix;
@synthesize bindingEntity = _bindingEntity;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [self setIsEditing:NO];
    [self layoutSubViews];
    
}

- (void)changeSkin:(NSNotification *)notification
{
    [self setNeedsDisplay:YES];
    [self layoutSubViews];
}

- (void)viewDidMoveToSuperview{
    [self setIsEditing:NO];
    [self layoutSubViews];
}

- (void)dealloc{
    if (_firstNameField != nil) {
        [_firstNameField release];
        _firstNameField = nil;
    }
    
    if (_middleNameField != nil) {
        [_middleNameField release];
        _middleNameField = nil;
    }
    
    if (_lastNameField != nil) {
        [_lastNameField release];
        _lastNameField = nil;
    }
    
    if (_displayAsCompanyField != nil) {
        [_displayAsCompanyField release];
        _displayAsCompanyField = nil;
    }
    
    if (_imageField != nil) {
        [_imageField release];
        _imageField = nil;
    }
    
    if (_jobTitleField != nil) {
        [_jobTitleField release];
        _jobTitleField = nil;
    }
    
    if (_companyNameField != nil) {
        [_companyNameField release];
        _companyNameField = nil;
    }
    
    if (_departmentField != nil) {
        [_departmentField release];
        _departmentField = nil;
    }
    
    if (_birthDayPicker != nil) {
        [_birthDayPicker release];
        _birthDayPicker = nil;
    }
    
    if (_nickNameField != nil) {
        [_nickNameField release];
        _nickNameField = nil;
    }
    
    if (_notesField != nil) {
        [_notesField release];
        _notesField = nil;
    }
    
    if (_middleNameField != nil) {
        [_middleNameField release];
        _middleNameField = nil;
    }
    
    if (_lastNameYomiField != nil) {
        [_lastNameYomiField release];
        _lastNameYomiField = nil;
    }
    
    if (_firstNameYomiField != nil) {
        [_firstNameYomiField release];
    }
    
    if (_suffixField != nil) {
        [_suffixField release];
        _suffixField = nil;
    }
    
    if (_titleField != nil) {
        [_titleField release];
        _titleField = nil;
    }
    
    if (_bindingEntity != nil){
        [_bindingEntity release];
        _bindingEntity = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

- (void)initSubView{
    _isEditing = NO;
    [self layoutSubViews];
}

- (void)textFieldFrameChanged:(id)sender{
    if (!isEditingChanged) {
        [self layoutSubViews];
    }
}

- (BOOL)isFlipped{
    return YES;
}

//布局规则:按照Prefix first middle last suffix的方式排列各种名字，换行，firstnameYomi,lastnameYomi,换行，nickName,换行companyName jobtitle department，换行birthday,换行title,换行，Note,最左边显示图片

- (void)layoutSingeView:(IMBTextField *)textField placeHolder:(NSString *)placeHolder size:(float)size originX:(CGFloat *)originX originY:(CGFloat *)originY viewArr:(NSMutableArray *)viewArr totalViewArr:(NSMutableArray *)totalViewArr isEditingChanged:(BOOL)isChanged{
    if (isChanged) {
        [textField setFrameSize:NSMakeSize(0, 0)];
    }
    NSImageView *imageField = [viewArr count] >= 1 ? [viewArr objectAtIndex:0] : nil;
//    if(textField == _titleField){
//        NSLog(@"textField.stringValue:%@",textField.stringValue);
//    }
    if (textField != nil) {
//        for (NSView *view in viewArr) {
//            if ([view isKindOfClass:[IMBTextField class]]) {
//                NSLog(@"textField.placeHolder:%@",[[(IMBTextField *)view cell] placeholderString]);
//            }
//        }

        [viewArr addObject:textField];
        [totalViewArr addObject:textField];
        
        NSRect rect = [textField calcuTextBounds:placeHolder fontSize:size width:200];
        
        if (textField.frame.size.width == 0 || textField.frame.size.height == 0 ) {
            
            [textField setFontSize:size];
            [textField setMaxPreferenceWidth:self.frame.size.width - imageField.frame.size.width - LeftMarginToImageView - 5];
            NSRect newRect = rect;
            if (textField.stringValue.length != 0) {
                NSRect textRect = [textField calcuTextBounds:textField.stringValue fontSize:size width:self.frame.size.width - *originX];
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
                    *originX = imageField.frame.size.width + LeftMarginToImageView;
                }
                else{
                    *originY += 0;
                    *originX = imageField.frame.size.width + LeftMarginToImageView;
                    
                }
            }
            [[textField cell] setPlaceholderString:placeHolder];
            [textField  setHandleDelegate:self];
            [self addSubview:textField];
            [textField setInitialWidth:rect.size.width + 6];
            [textField setInitialHeight:rect.size.height];
            
            [textField setMaxPreferenceWidth:self.frame.size.width - imageField.frame.size.width - LeftMarginToImageView - 5];
            
        }
        else{
            NSRect rect = textField.frame;
            if (*originX + rect.size.width > self.frame.size.width ) {
                NSArray *array = totalViewArr;
                
                NSUInteger index = [array indexOfObject:textField];
                if (index > 1) {
                    NSView *view = [array objectAtIndex:index - 1];
                    *originY = view.frame.origin.y + view.frame.size.height + 5;
                    *originX = imageField.frame.size.width + LeftMarginToImageView;
                }
                else{
                    *originY += 0;
                    *originX = imageField.frame.size.width + LeftMarginToImageView;
                    
                }
                
            }
            [textField setFrameOrigin:NSMakePoint(*originX, *originY)];
        }
        *originX += textField.frame.size.width + 5;
        if (rect.size.height < [textField singleLineHeight]) {
            *originY += textField.frame.size.height + 5;
            *originX = imageField.frame.size.width + LeftMarginToImageView;
            
        }
    }
}

- (void)layoutSubViews{
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    CGFloat originX = 0;
    CGFloat originY = 20;
    if (_imageField == nil) {
        _imageField = [[IMBRoundImageView alloc] initWithFrame:NSMakeRect(60, 0, 72, 72)];
        [self addSubview:_imageField];
    }
    else{
        NSArray *arr = [self subviews];
        if (_imageField.frame.size.width == 0 || _imageField.frame.size.height == 0) {
            [_imageField setFrame:NSMakeRect(originX, 0, 72, 72)];
        }
        if (![arr containsObject:_imageField]) {
            [self addSubview:_imageField];
        }
    }
    [viewArray addObject:_imageField];
    [_imageField setFrameOrigin:NSMakePoint(0, 0)];
    originX += _imageField.frame.size.width + LeftMarginToImageView;
    
    [self layoutSingeView:_firstNameField placeHolder:CustomLocalizedString(@"contact_id_1", nil) size:NAMEFONTSIZE originX:&originX originY:&originY viewArr:viewArray totalViewArr:viewArray isEditingChanged:isEditingChanged];
    
    [self layoutSingeView:_middleNameField placeHolder:CustomLocalizedString(@"contact_id_82", nil) size:NAMEFONTSIZE originX:&originX originY:&originY viewArr:viewArray totalViewArr:viewArray isEditingChanged:isEditingChanged];
    
    [self layoutSingeView:_lastNameField placeHolder:CustomLocalizedString(@"contact_id_2", nil) size:NAMEFONTSIZE originX:&originX originY:&originY viewArr:viewArray totalViewArr:viewArray isEditingChanged:isEditingChanged];
    
    [self layoutSingeView:_suffixField placeHolder:CustomLocalizedString(@"contact_id_88", nil) size:NAMEFONTSIZE originX:&originX originY:&originY viewArr:viewArray totalViewArr:viewArray isEditingChanged:isEditingChanged];
    
    if (viewArray != nil && viewArray.count > 1) {
        IMBTextField *lastTestField = [viewArray lastObject];
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = lastTestField.frame.origin.y + lastTestField.frame.size.height + 5;
    }
    else{
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = 0;
    }
    
    if (_firstNameYomiField != nil || _lastNameYomiField != nil || _nickNameField) {
        NSMutableArray *yomiArray = [[NSMutableArray alloc] init];
        [yomiArray addObject:_imageField];
        [self layoutSingeView:_firstNameYomiField placeHolder:CustomLocalizedString(@"contact_id_86", nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:yomiArray totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [self layoutSingeView:_lastNameYomiField placeHolder:CustomLocalizedString(@"contact_id_87", nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:yomiArray totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [self layoutSingeView:_nickNameField placeHolder:CustomLocalizedString(@"contact_id_85", nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:yomiArray totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [yomiArray removeObject:_imageField];
        [yomiArray release];
    }
    
    if (viewArray != nil && viewArray.count > 1) {
        IMBTextField *lastTestField = [viewArray lastObject];
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = lastTestField.frame.origin.y + lastTestField.frame.size.height + 5;
    }
    else{
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = 0;
    }
    
    if (_jobTitleField != nil || _companyNameField != nil || _departmentField != nil) {
        NSMutableArray *companyArr = [[NSMutableArray alloc] init];
        [companyArr addObject:_imageField];
        [self layoutSingeView:_companyNameField placeHolder:CustomLocalizedString(@"contact_id_3", nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:companyArr totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [self layoutSingeView:_jobTitleField placeHolder:CustomLocalizedString(@"contact_id_83", nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:companyArr totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [self layoutSingeView:_departmentField placeHolder:CustomLocalizedString(@"contact_id_84", nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:companyArr totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [companyArr removeObject:_imageField];
        [companyArr release];
        
    }
    
    if (viewArray != nil && viewArray.count > 1) {
        IMBTextField *lastTestField = [viewArray lastObject];
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = lastTestField.frame.origin.y + lastTestField.frame.size.height + 5;
    }
    else{
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = 0;
    }
    
    if (_birthDayPicker != nil) {
        NSMutableArray *birthdayArr = [[NSMutableArray alloc] init];
        if(_birthDayPicker.frame.size.width == 0 || _birthDayPicker.frame.size.height == 0){
            [_birthDayPicker setFrameOrigin:NSMakePoint(originX, originY)];
            [self addSubview:_birthDayPicker];
            [_birthDayPicker setHandleDelegate:self];
            [_birthDayPicker setBindingEntity:_bindingEntity];
            [_birthDayPicker setBindingEntityKeyPath:@"birthday"];
        }
        else{
            [_birthDayPicker setFrameOrigin:NSMakePoint(originX, originY)];
        }
        [birthdayArr addObject:_birthDayPicker];
        [viewArray addObject:_birthDayPicker];
        [birthdayArr release];
    }
    
    if (viewArray != nil && viewArray.count > 1) {
        NSView *lastTestField = [viewArray lastObject];
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = lastTestField.frame.origin.y + lastTestField.frame.size.height + 5;
    }
    else{
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = 0;
    }
    
    if (_titleField != nil) {
        NSMutableArray *titleArr = [[NSMutableArray alloc] init];
        [titleArr addObject:_imageField];
        [self layoutSingeView:_titleField placeHolder:CustomLocalizedString(@"contact_id_90",nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:titleArr totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [titleArr removeObject:_imageField];
        [titleArr release];
    }
    
    
    if (viewArray != nil && viewArray.count > 1) {
        NSView *lastTestField = [viewArray lastObject];
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = lastTestField.frame.origin.y + lastTestField.frame.size.height + 5;
    }
    else{
        originX = _imageField.frame.size.width + LeftMarginToImageView;
        originY = 0;
    }
    
    if (_notesField != nil) {
        NSMutableArray *noteArr = [[NSMutableArray alloc] init];
        [noteArr addObject:_imageField];
        [self layoutSingeView:_notesField placeHolder:CustomLocalizedString(@"contact_id_91", nil) size:NORMALFONTSIZE originX:&originX originY:&originY viewArr:noteArr totalViewArr:viewArray isEditingChanged:isEditingChanged];
        [noteArr removeObject:_imageField];
//        [viewArray addObjectsFromArray:noteArr];
        [noteArr release];
    }
    
    CGFloat finalHeight;
    
    if (viewArray != nil && viewArray.count > 1) {
        NSView *lastTestField = [viewArray lastObject];
        finalHeight = lastTestField.frame.size.height + lastTestField.frame.origin.y + 30> _imageField.frame.size.height + 50 ? lastTestField.frame.size.height + lastTestField.frame.origin.y + 30: _imageField.frame.size.height + 50;
    }
    else{
        finalHeight =  _imageField.frame.size.height + 50;
    }
    
    NSRect rect = self.frame;
    rect.size.height = finalHeight;
    [self setFrame:rect];
    if (finalHeight != compareHeight) {
        compareHeight = finalHeight;
        if ([_delegate respondsToSelector:@selector(blocksInContentFrameChanged:)]) {
            [_delegate blocksInContentFrameChanged:self];
        }
    }
    if (isEditingChanged) {
        isEditingChanged = false;
        [self layoutSubViews];
    }
    [viewArray release];

}

- (void)changeImage{
    NSArray *supportFiles = [[MediaHelper getSupportFileTypeArray:Category_MyAlbums supportVideo:NO supportConvert:YES withiPod:nil] componentsSeparatedByString:@";"];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:supportFiles];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSString *path = [[openPanel URL] path];
            NSImage *imageName = [[NSImage alloc] initWithContentsOfFile:path];
            NSData *imageData = [TempHelper createThumbnail:imageName withWidth:200 withHeight:200];
            [self setImage:imageData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGECONTEACIMAGE_REDEVICENAME object:imageData];
            [imageName release];
        }
    }];
}

- (void)setIsEditing:(BOOL)isEditing{
    if (isEditing != _isEditing) {
        isEditingChanged = true;
    }
    NSLog(@"superViewSize:%f,%f",self.superview.frame.size.width,self.superview.frame.size.height);
    _isEditing = isEditing;

    if (isEditing) {
        NSString *editStr = CustomLocalizedString(@"contact_id_96", nil);
        NSRect editRect = [StringHelper calcuTextBounds:editStr fontSize:13];
        int w = 80;
        if (editRect.size.width > 80) {
            w = editRect.size.width + 10;
        }
        
        _changeImgBtn = [[IMBMyDrawCommonly alloc]initWithFrame:NSMakeRect(0, 80,80, 20)];
        [_changeImgBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        //线的颜色
        [_changeImgBtn WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
        //填充的颜色
        [_changeImgBtn WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
        [_changeImgBtn setTitleName:CustomLocalizedString(@"contact_id_96", nil) WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
        [_changeImgBtn setTarget:self];
        [_changeImgBtn setAction:@selector(changeImage)];
        [self addSubview:_changeImgBtn];

        NSRect rect = self.frame;
        rect.origin.x = ORIGINXOFFSET;
        rect.size.width = NOEDITINGWIDTH;
        [self setFrame:rect];
        [self layoutSubViews];
        for (id view in self.subviews) {
            if ([view respondsToSelector:@selector(setEditable:)]) {
                [view setEditable:YES];
            }
            else{
                if([view respondsToSelector:@selector(setEnabled:)]){
                    [view setEnabled:YES];
                }
            }
        }
    }
    else{
        [_changeImgBtn removeFromSuperview];
        NSRect rect = self.frame;
        rect.origin.x = ORIGINXOFFSET;
        rect.size.width = NOEDITINGWIDTH;
        [self setFrame:rect];
        [self layoutSubViews];
        for (id view in self.subviews) {
            if ([view respondsToSelector:@selector(setEditable:)]) {
                [view setEditable:NO];
            }
            else{
                if([view respondsToSelector:@selector(setEnabled:)]){
                    [view setEnabled:NO];
                }
            }
            
        }
    }
}

- (void)setFirstName:(NSString *)firstName{
    if (_firstNameField == nil) {
        _firstNameField = [[IMBTextField alloc] init];
        [_firstNameField setBindingEntity:_bindingEntity];
        [_firstNameField setBindingEntityKeyPath:@"firstName"];
    }
    [_firstNameField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_firstNameField setStringValue:firstName==nil?@"":firstName];
}

- (NSString *)firstName{
    return _firstNameField.stringValue;
}

- (void)setLastName:(NSString *)lastName{
    if (_lastNameField == nil) {
        _lastNameField = [[IMBTextField alloc] init];
        [_lastNameField setBindingEntity:_bindingEntity];
        [_lastNameField setBindingEntityKeyPath:@"lastName"];

    }
    [_lastNameField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_lastNameField setStringValue:lastName==nil?@"":lastName];
}

- (void)setDisplayAsCompany:(NSString *)displayAsCompany{
    if (_displayAsCompanyField == nil){
        _displayAsCompanyField = [[IMBTextField alloc] init];
        [_displayAsCompanyField setBindingEntity:_bindingEntity];
        [_displayAsCompanyField setBindingEntityKeyPath:@"displayAsCompany"];
    }
    [_displayAsCompanyField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_displayAsCompanyField setStringValue:displayAsCompany==nil?@"":displayAsCompany];
}

- (NSString *)displayAsCompany{
    return _displayAsCompanyField.stringValue;
}

- (void)setImage:(NSData *)image{
    if (_imageField == nil) {
        _imageField = [[IMBRoundImageView alloc] init];
    }
    NSImage *img = [[[NSImage alloc] initWithData:image] autorelease];
    [img setSize:NSMakeSize(72, 72)];
    [_imageField setWantsLayer:YES];
    [_imageField.layer setCornerRadius:36];
    [_imageField setFrameOrigin:NSMakePoint(0, 0)];
    [_imageField setImage:img];
}

- (NSData *)imageData{
    return [[_imageField image] TIFFRepresentation];
}

- (void)setJobTitle:(NSString *)jobTitle{
    if (_jobTitleField == nil) {
        _jobTitleField = [[IMBTextField alloc] init];
        [_jobTitleField setBindingEntity:_bindingEntity];
        [_jobTitleField setBindingEntityKeyPath:@"jobTitle"];

    }
    [_jobTitleField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_jobTitleField setStringValue:jobTitle==nil?@"":jobTitle];
}

- (NSString *)jobTitle{
    return _jobTitleField.stringValue;
}

- (void)setTitle:(NSString *)title{
    if (_titleField == nil) {
        _titleField = [[IMBTextField alloc] init];
        [_titleField setBindingEntity:_bindingEntity];
        [_titleField setBindingEntityKeyPath:@"title"];

    }
    [_titleField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_titleField setStringValue:title==nil?@"":title];
}

- (NSString *)title{
    return _titleField.stringValue;
}

- (void)setCompanyName:(NSString *)companyName{
    if (_companyNameField == nil) {
        _companyNameField = [[IMBTextField alloc] init];
        [_companyNameField setBindingEntity:_bindingEntity];
        [_companyNameField setBindingEntityKeyPath:@"companyName"];

    }
    [_companyNameField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_companyNameField setStringValue:companyName==nil?@"":companyName];
}

- (NSString *)companyName{
    return _companyNameField.stringValue;
}

- (void)setDepartment:(NSString *)department{
    if (_departmentField == nil) {
        _departmentField = [[IMBTextField alloc] init];
        [_departmentField setBindingEntity:_bindingEntity];
        [_departmentField setBindingEntityKeyPath:@"department"];
    }
    [_departmentField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_departmentField setStringValue:department==nil?@"":department];
}

- (NSString *)department{
    return _departmentField.stringValue;
}

- (void)setBirthday:(NSDate *)birthday{
    if (_birthDayPicker == nil) {
        _birthDayPicker = [[IMBDatePicker alloc] init];

    }
    if(birthday != nil){
        [_birthDayPicker setDateValue:birthday];
    }
}

- (NSDate *)birthday{
    return _birthDayPicker.dateValue;
}

- (void)setNickName:(NSString *)nickName{
    if (_nickNameField == nil) {
        _nickNameField = [[IMBTextField alloc] init];
        [_nickNameField setBindingEntity:_bindingEntity];
        [_nickNameField setBindingEntityKeyPath:@"nickname"];

    }
    [_nickNameField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_nickNameField setStringValue:nickName==nil?@"":nickName];
}

- (NSString *)nickName{
    return _nickNameField.stringValue;
}

- (void)setNotes:(NSString *)notes{
    if (_notesField == nil) {
        _notesField = [[IMBTextField alloc] init];
        [_notesField setBindingEntity:_bindingEntity];
        [_notesField setBindingEntityKeyPath:@"notes"];

    }
    [_notesField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_notesField setStringValue:notes==nil?@"":notes];
}

- (NSString *)notes{
    return  _notesField.stringValue;
}

- (void)setMiddleName:(NSString *)middleName{
    if (_middleNameField == nil) {
        _middleNameField = [[IMBTextField alloc] init];
        [_middleNameField setBindingEntity:_bindingEntity];
        [_middleNameField setBindingEntityKeyPath:@"middleName"];

    }
    [_middleNameField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_middleNameField setStringValue:middleName==nil?@"":middleName];
}

- (NSString *)middleName{
    return _middleNameField.stringValue;
}

- (void)setLastNameYomi:(NSString *)lastName{
    if (_lastNameYomiField == nil) {
        _lastNameYomiField = [[IMBTextField alloc] init];
        [_lastNameYomiField setBindingEntity:_bindingEntity];
        [_lastNameYomiField setBindingEntityKeyPath:@"lastNameYomi"];

    }
    [_lastNameYomiField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_lastNameYomiField setStringValue:lastName==nil?@"":lastName];
}

- (NSString *)lastNameYomi{
    return _lastNameYomiField.stringValue;
}

- (void)setFirstNameYomi:(NSString *)firstName{
    if (_firstNameYomiField == nil) {
        _firstNameYomiField = [[IMBTextField alloc] init];
        [_firstNameYomiField setBindingEntity:_bindingEntity];
        [_firstNameYomiField setBindingEntityKeyPath:@"firstNameYomi"];

    }
    [_firstNameYomiField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_firstNameYomiField setStringValue:firstName==nil?@"":firstName];
}

- (NSString *)firstNameYomi{
    return _firstNameYomiField.stringValue;
}

- (void)setSuffix:(NSString *)suffix{
    if (_suffixField == nil) {
        _suffixField = [[IMBTextField alloc] init];
        [_suffixField setBindingEntity:_bindingEntity];
        [_suffixField setBindingEntityKeyPath:@"suffix"];

    }
    [_suffixField setDrawFontColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_suffixField setStringValue:suffix==nil?@"":suffix];
}

- (NSString *)suffix{
    return _suffixField.stringValue;
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


@end
