//
//  IMBBlockView.m
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBlockView.h"
#import "IMBKeyValueView.h"
#import "IMBIMView.h"
#import "IMBAddressView.h"

@implementation IMBBlockView
@synthesize isLastItem = _isLastItem;
@synthesize blockType = _blockType;
@synthesize contactID = _contactID;
@synthesize entityID = _entityID;
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self initSubviews];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)dealloc{
    if (_entityArr != nil) {
        [_entityArr release];
        _entityArr = nil;
    }
    if (_entityViewArr != nil) {
        [_entityViewArr release];
        _entityViewArr = nil;
    }
    if (_contactID != nil) {
        [_contactID release];
        _contactID = nil;
    }
    if (_entityID != nil) {
        [_entityID release];
        _entityID = nil;
    }
    [super dealloc];
}

- (void)viewDidMoveToSuperview{
    [super viewDidMoveToSuperview];
}

- (BOOL)isEditing{
    return _isEditing;
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (isEditing) {
        [self addAllEmptyEntity];
    }
    else{
        [self removeAllEmptyEntity];
    }
    [self layoutSubviews];
    for (id view in self.subviews) {
        if ([view respondsToSelector:@selector(setIsEditing:)]) {
            [view setIsEditing:isEditing];
        }
    }
    [self subviewsInBlockFrameChanged:nil];
}

- (void)removeAllEmptyEntity{
    NSArray *array = [[NSArray alloc] initWithArray:_entityArr];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (IMBContactBaseEntity *entity in array) {
        @autoreleasepool {
            if ([entity isEmpty]) {
                NSInteger index = [array indexOfObject:entity];
                [indexSet addIndex:index];
                NSView *view = [_entityViewArr objectAtIndex:index];
                [view removeFromSuperview];
                
            }
        }
    }
    [_entityArr removeObjectsAtIndexes:indexSet];
    [_entityViewArr removeObjectsAtIndexes:indexSet];
    [indexSet release];
    [array release];
}

- (void)addAllEmptyEntity{
    [self addEntities:nil];
}

- (NSMutableArray *)dataArr{
    return _entityArr;
}

- (void)initSubviews{
    _isEditing = NO;
    if (_entityArr == nil) {
        _entityArr = [[NSMutableArray alloc]init];
    }
    [self layoutSubviews];
    compHeight = self.frame.size.height;
}

- (void)layoutSubviews{
    //    if (_entityViewArr != nil) {
    //        for (NSView *view in _entityViewArr) {
    //            [view removeFromSuperview];
    //        }
    //        [_entityViewArr release];
    //        _entityViewArr = nil;
    //    }
    if (_entityArr.count == 0) {
        return;
    }
    if (_entityViewArr == nil) {
        _entityViewArr = [[NSMutableArray alloc] init];
    }
    
    CGFloat originX = 0,originY = 0;
    NSInteger maxViewIndex = (_entityViewArr.count > 0) ? ([_entityViewArr count] - 1):-1;
    NSInteger j = _entityArr.count > maxViewIndex ? maxViewIndex:-1;
    
    if (j != -1 && _entityViewArr.count > j) {
        NSView *view = [_entityViewArr objectAtIndex:j];
        originY += view.frame.origin.y + view.frame.size.height;
        if (j+1 >= _entityArr.count) {
            return;
        }
    }
    
    for (NSInteger i = j + 1; i < _entityArr.count; i++) {
        IMBContactBaseEntity *baseEntity  = [_entityArr objectAtIndex:i];
        if ([baseEntity isKindOfClass:[IMBContactKeyValueEntity class]]) {
            IMBContactKeyValueEntity *entity = (IMBContactKeyValueEntity *)baseEntity;
            NSArray *array = [self lableArrsFromCategory:baseEntity.contactCategory];
            IMBKeyValueView *keyValueView = [[[IMBKeyValueView alloc] initWithFrame:NSMakeRect(originX, originY, self.frame.size.width, 200)] autorelease];
            [keyValueView setContactKeyValueEntity:entity];
            if (keyValueView.labelArr == nil) {
                if (![array containsObject:entity.label] && entity.label != nil && ![entity.label isEqualToString:@""]) {
                    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:array];
                    NSInteger index =[newArray indexOfObject:CustomLocalizedString(@"contact_id_93", nil)];
                    if (index >= 0) {
                        [newArray insertObject:entity.label atIndex:index];
                    }
                    else{
                        [newArray addObject:entity.label];
                    }
                    [keyValueView setLabelArr:newArray];
                    
                    [newArray release];
                }
                else{
                    [keyValueView setLabelArr:array];
                }
            }
            if (keyValueView.key == nil) {
                [keyValueView setKey:entity.label];
            }
            [keyValueView setValueObj:entity.value];
            if(_blockType == DateBlock){
                [keyValueView setIsDateType:YES];
            }
            else{
                [keyValueView setIsDateType:NO];
            }
            [keyValueView setDelegate:self];
            originY += keyValueView.frame.size.height;
            NSArray *arr = self.subviews;
            if (![arr containsObject:keyValueView]) {
                [self addSubview:keyValueView];
            }
            [keyValueView setIsEmpty:[entity isEmpty]];
            [keyValueView setIsEditing:_isEditing];
            [_entityViewArr addObject:keyValueView];
        }
        else if([baseEntity isKindOfClass:[IMBContactIMEntity class]]){
            IMBContactIMEntity *entity = (IMBContactIMEntity *)baseEntity;
            NSArray *array = [self lableArrsFromCategory:baseEntity.contactCategory];
            IMBIMView *imView = [[[IMBIMView alloc] initWithFrame:NSMakeRect(originX, originY, self.frame.size.width, 200)] autorelease];
            [imView setDelegate:self];
            [imView setImEntity:entity];
            if (imView.labelsArr == nil) {
                if (![[array objectAtIndex:0] containsObject:entity.label] && ![entity.label isEqualToString:@""] && entity.label != nil) {
                    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:[array objectAtIndex:0]];
                    NSInteger index =[newArray indexOfObject:CustomLocalizedString(@"contact_id_93", nil)];
                    if (index >= 0) {
                        [newArray insertObject:entity.label atIndex:index];
                    }
                    else{
                        [newArray addObject:entity.label];
                    }
                    [imView setLabelsArr:newArray];
                    [newArray release];
                }
                else{
                    [imView setLabelsArr:[array objectAtIndex:0]];
                }
            }
            
            if (imView.lableType == nil) {
                if (entity.label != nil) {
                    [imView setLableType:entity.label];
                }
                else{
                    [imView setLableType:[imView.labelsArr objectAtIndex:0]];
                }
            }
            
            if (imView.imArr == nil) {
                if (![[array objectAtIndex:1] containsObject:entity.service] && ![entity.service isEqualToString:@""] && entity.service != nil) {
                    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:[array objectAtIndex:1]];
                    NSInteger index =[newArray indexOfObject:CustomLocalizedString(@"contact_id_93", nil)];
                    if (index >= 0) {
                        [newArray insertObject:entity.service atIndex:index];
                    }
                    else{
                        [newArray addObject:entity.service];
                    }
                    [imView setImArr:newArray];
                    [newArray release];
                }
                else{
                    [imView setImArr:[array objectAtIndex:1]];
                }
            }
            if (imView.serviceType == nil) {
                if (entity.service != nil) {
                    [imView setServiceType:entity.service];
                }
                else{
                    [imView setServiceType:[imView.imArr objectAtIndex:0]];
                }
            }
            
            [imView setValueText:entity.user];
            originY += imView.frame.size.height;
            NSArray *arr = self.subviews;
            if (![arr containsObject:imView]) {
                [self addSubview:imView];
            }
            [imView setIsEmpty:[entity isEmpty]];
            [imView setIsEditing:_isEditing];

            [_entityViewArr addObject:imView];
        }
        else if([baseEntity isKindOfClass:[IMBContactAddressEntity class]]){
            IMBContactAddressEntity *addrEntity = (IMBContactAddressEntity *)baseEntity;
            NSArray *array = [self lableArrsFromCategory:baseEntity.contactCategory];
            IMBAddressView *addressView = [[[IMBAddressView alloc] initWithFrame:NSMakeRect(originY, originY, self.frame.size.width, 200)] autorelease];
            [addressView setAddressEntity:addrEntity];
            
            if (addressView.labelArr == nil) {
                if (![array containsObject:addrEntity.label] && addrEntity.label != nil && ![addrEntity.label isEqualToString:@""]) {
                    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:array];
                    NSInteger index =[newArray indexOfObject:CustomLocalizedString(@"contact_id_93", nil)];
                    if (index >= 0) {
                        [newArray insertObject:addrEntity.label atIndex:index];
                    }
                    else{
                        [newArray addObject:addrEntity.label];
                    }
                    [addressView setLabelArr:newArray];
                    [newArray release];
                }
                else{
                    [addressView setLabelArr:array];
                }
            }
            if (addressView.keyString == nil) {
                [addressView setKeyString:addrEntity.label];
            }
            //定义street,city
            if (addressView.street == nil) {
                [addressView setStreet:addrEntity.street];
            }
            if (addressView.city == nil) {
                [addressView setCity:addrEntity.city];
            }
            if (addressView.country == nil) {
                [addressView setCountry:addrEntity.country];
            }
            if (addressView.zip == nil) {
                [addressView setZip:addrEntity.postalCode];
            }
            if (addressView.state == nil) {
                [addressView setState:addrEntity.state];
            }
            if (addressView.countryCode == nil) {
                [addressView setCountryCode:addrEntity.countryCode];
            }
            [addressView setDelegate:self];
            originY += addressView.frame.size.height;
            NSArray *arr = self.subviews;
            if (![arr containsObject:addressView]) {
                [self addSubview:addressView];
            }
            [addressView setIsEmpty:[addrEntity isEmpty]];
            [addressView setIsEditing:_isEditing];

            [_entityViewArr addObject:addressView];
        }
    }
    
    NSRect rect = self.frame;
    rect.size.height = originY + 20;
    [self setFrame:rect];
//    if (compHeight != rect.size.height) {
//        compHeight = rect.size.height;
//        if ([_delegate respondsToSelector:@selector(blocksInContentFrameChanged:)]) {
//            [_delegate blocksInContentFrameChanged:self];
//        }
//    }
    [self subviewsInBlockFrameChanged:nil];
}

- (void)removedFromSuperView:(id)sender{
    @autoreleasepool {
        NSInteger index = [_entityViewArr indexOfObject:sender];
        if (index >= 0) {
            if (_entityArr.count > index) {
                IMBContactBaseEntity *entity = [_entityArr objectAtIndex:index];
                [_entityArr removeObject:entity];
            }
            if (_entityViewArr.count > index) {
                NSView *view = [_entityViewArr objectAtIndex:index];
                [view removeFromSuperview];
                [_entityViewArr removeObject:view];
            }
        }
        [self subviewsInBlockFrameChanged:sender];
    }
}

- (void)emptyItemInBlockViewHasEdit:(id)sender{
    IMBContactItemView *itemView = (IMBContactItemView *)sender;
    if (itemView.isEmpty) {
        return;
    }
    else{
        BOOL hasEmptyItem = false;
        for (IMBContactItemView *item in _entityViewArr) {
            if (item.isEmpty) {
                hasEmptyItem = true;
                break;
            }
        }
        if (hasEmptyItem) {
            return;
        }
        else{
           IMBContactBaseEntity *entity = [self generateEmptyEntityItem];
            [_entityArr addObject:entity];
            [self layoutSubviews];
        }
    }
}

- (void)notifyBlocksFrameChanged{
    if (compHeight != self.frame.size.height) {
        compHeight = self.frame.size.height;
        if ([_delegate respondsToSelector:@selector(blocksInContentFrameChanged:)]) {
            [_delegate blocksInContentFrameChanged:self];
        }
    }
}

- (void)subviewsInBlockFrameChanged:(id)sender{
    CGFloat originX = 0,originY = 0;
    for (NSView *view in _entityViewArr) {
        [view setFrame:NSMakeRect(originX, originY, view.frame.size.width, view.frame.size.height)];
        originY += view.frame.size.height;
    }
    NSRect rect = self.frame;
    rect.size.height = originY;
    [self setFrame:rect];
    [self notifyBlocksFrameChanged];
}


- (BOOL)isFlipped{
    return YES;
}

- (NSArray *)lableArrsFromCategory:(ContactCategoryEnum)contactCategory{
    NSArray *lableArr = nil;
    switch (contactCategory) {
        case Contact_PhoneNumber:
        {
            lableArr = [NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_40", nil),CustomLocalizedString(@"contact_id_4", nil),CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_7", nil),CustomLocalizedString(@"contact_id_10", nil),CustomLocalizedString(@"contact_id_12", nil),CustomLocalizedString(@"contact_id_9", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil];
        }
            break;
        case Contact_EmailAddressNumber:
        {
            lableArr = [NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil];
        }
            break;
        case Contact_RelatedName:
        {
            lableArr = [NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_17", nil),CustomLocalizedString(@"contact_id_18", nil),CustomLocalizedString(@"contact_id_19", nil),CustomLocalizedString(@"contact_id_20", nil),CustomLocalizedString(@"contact_id_21", nil),CustomLocalizedString(@"contact_id_22", nil),CustomLocalizedString(@"contact_id_23", nil),CustomLocalizedString(@"contact_id_24", nil),CustomLocalizedString(@"contact_id_25", nil),CustomLocalizedString(@"contact_id_26", nil),CustomLocalizedString(@"contact_id_27", nil),CustomLocalizedString(@"contact_id_93", nil),nil];

        }
            break;
        case Contact_URL:
        {
            lableArr = [NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_14", nil),CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil];
        }
            break;
        case Contact_Date:
        {
            lableArr = [NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_38", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil];
        }
            break;
        case Contact_IM:
        {
            lableArr = [NSArray arrayWithObjects:[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_5", nil), CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil), nil],[NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_28", nil),CustomLocalizedString(@"contact_id_36", nil),CustomLocalizedString(@"contact_id_37", nil),CustomLocalizedString(@"contact_id_29", nil),CustomLocalizedString(@"contact_id_32", nil),CustomLocalizedString(@"contact_id_33", nil),CustomLocalizedString(@"contact_id_31", nil),CustomLocalizedString(@"contact_id_35", nil),CustomLocalizedString(@"contact_id_34", nil),CustomLocalizedString(@"contact_id_30", nil),CustomLocalizedString(@"contact_id_93", nil),nil], nil];
        }
            break;
        case Contact_StreetAddress:
        {
            lableArr = [NSArray arrayWithObjects:CustomLocalizedString(@"contact_id_5", nil),CustomLocalizedString(@"contact_id_6", nil),CustomLocalizedString(@"contact_id_8", nil),CustomLocalizedString(@"contact_id_93", nil),nil];
        }
            
        default:
            break;
    }
    return lableArr;
}

- (void)addEntity:(IMBContactBaseEntity *)entity{
    if (entity != nil) {
        [_entityArr addObject:entity];
    }
    
    if (_entityArr.count > 0) {
        IMBContactBaseEntity *entity = [_entityArr objectAtIndex:0];
        _contactID = [[entity contactId] retain];
    }
    [self addEmptyEntityIfNeed];
    [self layoutSubviews];
}

- (void)addEmptyEntity{
    [_entityArr addObject:[self generateEmptyEntityItem]];
    [self layoutSubviews];
}

- (void)addEntities:(NSArray *)entities{
    if (entities.count >0) {
        [_entityArr addObjectsFromArray:entities];
    }
    if (_entityArr.count > 0) {
        IMBContactBaseEntity *entity = [_entityArr objectAtIndex:0];
        _contactID = [[entity contactId] retain];
    }
    [self addEmptyEntityIfNeed];
    [self layoutSubviews];
}

- (void)addEmptyEntityIfNeed{
    if (_entityViewArr.count == 0) {
        IMBContactBaseEntity *emptyEntity = [self generateEmptyEntityItem];
        if (emptyEntity != nil) {
            [_entityArr addObject:emptyEntity];
        }
    }
    else{
        BOOL hasEmptyEntityView = false;
        for (IMBContactItemView *itemView in _entityViewArr) {
            if (itemView.isEmpty) {
                hasEmptyEntityView = true;
                break;
            }
        }
        if (!hasEmptyEntityView) {
            IMBContactBaseEntity *emptyEntity = [self generateEmptyEntityItem];
            [_entityArr addObject:emptyEntity];
            
        }
    }
}

//生成的Item还需要ContactID等属性
- (IMBContactBaseEntity *)generateEmptyEntityItem{
    IMBContactBaseEntity *entity = nil;
    if (_entityArr.count == 0) {
        switch (_blockType) {
            case PhoneNumberBlock:
                entity = [[[IMBContactKeyValueEntity alloc] init] autorelease];
                entity.contactCategory = Contact_PhoneNumber;
                entity.contactId = _contactID;
                entity.entityID = _entityID;
                break;
            case EmailBlock:
                entity = [[[IMBContactKeyValueEntity alloc] init] autorelease];
                entity.contactCategory = Contact_EmailAddressNumber;
                entity.contactId = _contactID;
                entity.entityID = _entityID;

                break;
            case DateBlock:
                entity = [[[IMBContactKeyValueEntity alloc] init] autorelease];
                entity.contactCategory = Contact_Date;
                entity.contactId = _contactID;
                entity.entityID = _entityID;

                break;
            case RelatedNameBlock:
                entity = [[[IMBContactKeyValueEntity alloc] init] autorelease];
                entity.contactCategory = Contact_RelatedName;
                entity.contactId = _contactID;
                entity.entityID = _entityID;

                break;
            case URLBlock:
                entity = [[[IMBContactKeyValueEntity alloc] init] autorelease];
                entity.contactCategory = Contact_URL;
                entity.contactId = _contactID;
                entity.entityID = _entityID;

                break;
            case IMBlock:
                entity = [[[IMBContactIMEntity alloc] init] autorelease];
                entity.contactCategory = Contact_IM;
                entity.contactId = _contactID;
                entity.entityID = _entityID;

                break;
            case AddressBlock:
                entity = [[[IMBContactAddressEntity alloc] init] autorelease];
                entity.contactCategory = Contact_StreetAddress;
                entity.contactId = _contactID;
                entity.entityID = _entityID;

                break;
            default:
                break;
        }
    }
    else{
        IMBContactBaseEntity *lastEntityInArr = [_entityArr lastObject];
        if ([lastEntityInArr isKindOfClass:[IMBContactIMEntity class]]) {
            entity = [[[IMBContactIMEntity alloc] init] autorelease];
            entity.contactId = _contactID;
            entity.entityID = _entityID;
            [self generatedEntityID];

        }
        else if([lastEntityInArr isKindOfClass:[IMBContactKeyValueEntity class]]){
            entity = [[[IMBContactKeyValueEntity alloc] init] autorelease];
            entity.contactId = _contactID;
            entity.entityID = _entityID;
            [self generatedEntityID];

        }
        else if([lastEntityInArr isKindOfClass:[IMBContactAddressEntity class]]){
            entity = [[[IMBContactAddressEntity alloc] init] autorelease];
            entity.contactId = _contactID;
            entity.entityID = _entityID;
            [self generatedEntityID];
        }
        entity.contactCategory = lastEntityInArr.contactCategory;
    }
    return entity;
}

- (int)generatedEntityID{
    long long entityID = -1;
    for (IMBContactEntity *contactEntity in _entityArr) {
        if (contactEntity.entityID != nil) {
            NSNumber *number = contactEntity.entityID;
            long long newID = [number longLongValue];
            if (newID > entityID) {
                entityID = newID;
            }
        }
        else{
            entityID ++;
            contactEntity.entityID = [NSNumber numberWithLongLong:entityID];
        }
    }
    return 0;
}

//- (void)generate

- (void)drawRect:(NSRect)dirtyRect
{
//    [[NSColor grayColor] set];
//    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];

    
    // Drawing code here.
}

@end
