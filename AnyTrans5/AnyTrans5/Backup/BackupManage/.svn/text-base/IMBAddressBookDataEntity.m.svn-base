//
//  IMBAddressBookDataEntity.m
//  DataRecovery
//
//  Created by iMobie on 4/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBAddressBookDataEntity.h"

@implementation IMBAddressBookDataEntity
@synthesize birthday = _birthday;
@synthesize firstSort = _firstSort;
@synthesize lastSort = _lastSort;
@synthesize phonemeData = _phonemeData;
@synthesize compositeNameFallback = _compositeNameFallback;
@synthesize externalIdentifier = _externalIdentifier;
@synthesize externalModificationTag = _externalModificationTag;
@synthesize externalUUID = _externalUUID;
@synthesize storeID = _storeID;
@synthesize externalRepresentation = _externalRepresentation;
@synthesize firstSortSection = _firstSortSection;
@synthesize lastSortSection = _lastSortSection;
@synthesize firstSortLanguageIndex = _firstSortLanguageIndex;
@synthesize lastSortLanguageIndex = _lastSortLanguageIndex;
@synthesize personLink = _personLink;
@synthesize imageURI = _imageURI;
@synthesize isPreferredName = _isPreferredName;
@synthesize guid = _guid;


@synthesize rowid = _rowid;
@synthesize kind = _kind;
@synthesize creationDate = _creationDate;
@synthesize modificationDate = _modificationDate;
@synthesize birthdayDate = _birthdayDate;
@synthesize displayName = _displayName;
@synthesize firstName = _firstName;
@synthesize middleName = _middleName;
@synthesize lastName = _lastName;
@synthesize firstNameYomi = _firstNameYomi;
@synthesize middleNameYomi = _middleNameYomi;
@synthesize lastNameYomi = _lastNameYomi;
@synthesize department = _department;
@synthesize companyName = _companyName;
@synthesize contentArray = _contentArray;
@synthesize image = _image;
@synthesize nickName = _nickName;
@synthesize prefix = _prefix;
@synthesize suffix = _suffix;
@synthesize jobTitle = _jobTitle;
@synthesize notes = _notes;
@synthesize imageData = _imageData;
@synthesize numberArray = _numberArray;
@synthesize emailArray = _emailArray;
@synthesize dateArray = _dateArray;
@synthesize IMArray = _IMArray;
@synthesize relatedArray = _relatedArray;
@synthesize specialURLArray = _specialURLArray;
@synthesize streetArray = _streetArray;
@synthesize URLArray = _URLArray;
@synthesize allName = _allName;
@synthesize propertyID = _propertyID;
- (id)init {
    self = [super init];
    if (self) {
        _rowid = 0;
        _kind = 0;
        _creationDate = 0;
        _modificationDate = 0;
        _birthdayDate = 0;
        _firstName = @"";
        _firstNameYomi = @"";
        _middleNameYomi = @"";
        _middleName = @"";
        _lastNameYomi = @"";
        _lastName = @"";
        _department = @"";
        _companyName = @"";
        _nickName = @"";
        _prefix = @"";
        _suffix = @"";
        _jobTitle = @"";
        _notes = @"";
        _allName = @"";
        _image = nil;
        _contentArray = [[NSMutableArray alloc] init];
        
        _numberArray = [[NSMutableArray alloc] init];
        _emailArray = [[NSMutableArray alloc] init];
        _dateArray = [[NSMutableArray alloc] init];
        _IMArray = [[NSMutableArray alloc] init];
        _relatedArray = [[NSMutableArray alloc] init];
        _streetArray = [[NSMutableArray alloc] init];
        _specialURLArray = [[NSMutableArray alloc] init];
        _URLArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_imageData release],_imageData = nil;
    if (_contentArray != nil) {
        [_contentArray release];
        _contentArray = nil;
    }
    if (_numberArray != nil) {
        [_numberArray release];
        _numberArray = nil;
    }
    if (_dateArray != nil) {
        [_dateArray release];
        _dateArray = nil;
    }
    if (_IMArray != nil) {
        [_IMArray release];
        _IMArray = nil;
    }
    if (_relatedArray != nil) {
        [_relatedArray release];
        _relatedArray = nil;
    }
    if (_streetArray != nil) {
        [_streetArray release];
        _streetArray = nil;
    }
    if (_specialURLArray != nil) {
        [_specialURLArray release];
        _specialURLArray = nil;
    }
    if (_URLArray != nil) {
        [_URLArray release];
        _URLArray = nil;
    }
    if (_emailArray != nil) {
        [_emailArray release];
        _emailArray = nil;
    }
    [super dealloc];
}

@end

@implementation IMBAddressBookMultDataEntity
@synthesize identifier = _identifier;
@synthesize label = _label;
@synthesize property = _property;
@synthesize uid = _uid;
@synthesize recordID = _recordID;
@synthesize multValue = _multValue;
@synthesize multiArray = _multiArray;
@synthesize lableType = _labelType;

- (id)init
{
    self = [super init];
    if (self) {
        _identifier = 0;
        _label = 0;
        _property = 0;
        _uid = 0;
        _recordID = 0;
        _multValue = @"";
        _labelType = @"";
        _multiArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_multiArray != nil) {
        [_multiArray release];
        _multiArray = nil;
    }
    
    [super dealloc];
}

@end

@implementation IMBAddressBookDetailEntity
@synthesize detailValue = _detailValue;
@synthesize parentID = _parentID;
@synthesize key = _key;
@synthesize entityType = _entityType;

- (id)init
{
    self = [super init];
    if (self) {
        _key = 0;
        _parentID = 0;
        _detailValue = @"";
        _entityType = @"";
    }
    return self;
}

@end

