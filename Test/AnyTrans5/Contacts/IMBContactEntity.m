//
//  IMBContactEntity.m
//  iMobieTrans
//
//  Created by ZHANGYANG on 2/23/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBContactEntity.h"
#import "IMBContactHelper.h"

@implementation IMBContactBaseEntity
@synthesize contactCategory = _contactCategory;
@synthesize contactId = _contactId;
@synthesize entityID = _entityID;
@synthesize isCustomLabel = _isCustomLabel;
@synthesize isEmpty = _isEmpty;
@synthesize type = _type;

-(void)dicToObject:(NSDictionary *)dic{
}
- (NSDictionary *)objectToDic{
    return nil;
}

- (void)setEntityID:(NSNumber *)entityID{
    [_entityID release];
    _entityID = [entityID retain];
}

- (void)dealloc{
    if (_entityID != nil) {
        [_entityID release];
        _entityID = nil;
    }
    if (_contactId != nil) {
        [_contactId release];
        _contactId = nil;
    }
    [super dealloc];
}

@end

@implementation IMBContactEntity
@synthesize fullName = _fullName;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize displayAsCompany = _displayAsCompany;
@synthesize image = _image;
@synthesize jobTitle = _jobTitle;
@synthesize companyName = _companyName;
@synthesize department = _department;
@synthesize birthday = _birthday;
@synthesize nickname = _nickname;
@synthesize notes = _notes;
@synthesize middleName = _middleName;
@synthesize firstNameYomi = _firstNameYomi;
@synthesize lastNameYomi = _lastNameYomi;
@synthesize suffix = _suffix;
@synthesize title = _title;
@synthesize phoneNumberArray = _phoneNumberArray;
@synthesize emailAddressArray = _emailAddressArray;
@synthesize relatedNameArray = _relatedNameArray;
@synthesize urlArray = _urlArray;
@synthesize dateArray = _dateArray;
@synthesize addressArray = _addressArray;
@synthesize IMArray = _IMArray;
@synthesize allName = _allName;


- (id)init{
    if (self = [super init]) {
        _phoneNumberArray = [[NSMutableArray alloc]init];
        _relatedNameArray = [[NSMutableArray alloc]init];
        _urlArray = [[NSMutableArray alloc]init];
        _dateArray = [[NSMutableArray alloc]init];
        _addressArray = [[NSMutableArray alloc]init];
        _IMArray = [[NSMutableArray alloc]init];
        _emailAddressArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)dicToObject:(NSDictionary *)dic{
    self.entityID = [NSNumber numberWithInt:[[dic.allKeys objectAtIndex:0] intValue]];
    self.contactId = [dic.allKeys objectAtIndex:0];
    NSDictionary *valueDic = [dic objectForKey:[dic.allKeys objectAtIndex:0]];
    NSDictionary *contactDic = [valueDic objectForKey:DOMAIN_CONTACT];
    if ([contactDic.allKeys containsObject:@"birthday"]) {
        self.birthday = [contactDic objectForKey:@"birthday"];
    }
    if ([contactDic.allKeys containsObject:@"company name"]) {
        self.companyName = [contactDic objectForKey:@"company name"];
    }
    if ([contactDic.allKeys containsObject:@"department"]) {
        self.department = [contactDic objectForKey:@"department"];
    }
    if ([contactDic.allKeys containsObject:@"display as company"]) {
        self.displayAsCompany = [contactDic objectForKey:@"display as company"];
    }
    if ([contactDic.allKeys containsObject:@"first name"]) {
        self.firstName = [contactDic objectForKey:@"first name"];
    }
    if ([contactDic.allKeys containsObject:@"first name yomi"]) {
        self.firstNameYomi = [contactDic objectForKey:@"first name yomi"];
    }
    if ([contactDic.allKeys containsObject:@"job title"]) {
        self.jobTitle = [contactDic objectForKey:@"job title"];
    }
    if ([contactDic.allKeys containsObject:@"middle name"]) {
        self.middleName = [contactDic objectForKey:@"middle name"];
    }
    if ([contactDic.allKeys containsObject:@"last name"]) {
        self.lastName = [contactDic objectForKey:@"last name"];
    }
    if ([contactDic.allKeys containsObject:@"last name yomi"]) {
        self.lastNameYomi = [contactDic objectForKey:@"last name yomi"];
    }
    if ([contactDic.allKeys containsObject:@"nickname"]) {
        self.nickname = [contactDic objectForKey:@"nickname"];
    }
    if ([contactDic.allKeys containsObject:@"notes"]) {
        self.notes = [contactDic objectForKey:@"notes"];
    }
    if ([contactDic.allKeys containsObject:@"suffix"]) {
        self.suffix = [contactDic objectForKey:@"suffix"];
    }
    if ([contactDic.allKeys containsObject:@"title"]) {
        self.title = [contactDic objectForKey:@"title"];
    }
    if ([contactDic.allKeys containsObject:@"image"]) {
        self.image = [contactDic objectForKey:@"image"];
    }
    if (self.lastName == nil) {
        self.lastName = @"";
    }
    if (self.firstName == nil) {
        self.firstName = @"";
    }
   
    self.fullName = [NSString stringWithFormat:@"%@ %@",self.lastName,self.firstName];
    //获取dateArray;
    if([valueDic.allKeys containsObject:DOMAIN_DATE]){
        NSDictionary *dateDic = [valueDic objectForKey:DOMAIN_DATE];
        [IMBContactHelper arrayWithEnumeratedDic:dateDic inArray:_dateArray];
    }
    
    //获取relatedNameArray
    if([valueDic.allKeys containsObject:DOMAIN_RELATED_NAME]){
        
        NSDictionary *relatedDic = [valueDic objectForKey:DOMAIN_RELATED_NAME];
        [IMBContactHelper arrayWithEnumeratedDic:relatedDic inArray:_relatedNameArray];
    }
    
    if([valueDic.allKeys containsObject:DOMAIN_PHONE_NUMBER]){
        
        NSDictionary *numberDic = [valueDic objectForKey:DOMAIN_PHONE_NUMBER];
        [IMBContactHelper arrayWithEnumeratedDic:numberDic inArray:_phoneNumberArray] ;
    }
    if([valueDic.allKeys containsObject:DOMAIN_EMAIL_ADDRESS]){
        
        NSDictionary *emailDic = [valueDic objectForKey:DOMAIN_EMAIL_ADDRESS];
        [IMBContactHelper arrayWithEnumeratedDic:emailDic inArray:_emailAddressArray];
    }
    if([valueDic.allKeys containsObject:DOMAIN_URL]){
        
        NSDictionary *urlDic = [valueDic objectForKey:DOMAIN_URL];
        [IMBContactHelper arrayWithEnumeratedDic:urlDic inArray:_urlArray];
    }
    if([valueDic.allKeys containsObject:DOMAIN_IM]){
        
        NSDictionary *imDic = [valueDic objectForKey:DOMAIN_IM];
        [IMBContactHelper arrayWithEnumeratedIMDic:imDic inArray:_IMArray];
    }
    if([valueDic.allKeys containsObject:DOMAIN_STREET_ADDRESS]){
        
        NSDictionary *addrDic = [valueDic objectForKey:DOMAIN_STREET_ADDRESS];
        [IMBContactHelper arrayWithEnumeratedAddrDic:addrDic inArray:_addressArray] ;
    }


}

- (NSDictionary *)objectToDic{
    NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *totalValueDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *contactDic = [[NSMutableDictionary alloc]init];
    [contactDic setObject:DOMAIN_CONTACT forKey:RECORD_ENTITY_NAME];
//    NSImage *imageName = [NSImage imageNamed:@"btn_voicemailnew1"];
//    NSData *imageData = [imageName TIFFRepresentation];
//    _image = imageData;
    if (_image) {
        [contactDic setObject:_image forKey:RECORD_IMAGE];
    }
    if (_birthday) {
        [contactDic setObject:_birthday forKey:RECORD_BIRTHDAY];
    }
    if (_companyName) {
        [contactDic setObject:_companyName forKey:RECORD_COMPANY_NAME];
    }
    if (_department) {
        [contactDic setObject:_department forKey:RECORD_DEPARTMENT];
    }
    if(_displayAsCompany){
        [contactDic setObject:_displayAsCompany forKey:RECORD_DISPLAY_AS_COMPANY];
    }
    if (_firstName) {
        [contactDic setObject:_firstName forKey:RECORD_FIRST_NAME];
    }
    if (_firstNameYomi) {
        [contactDic setObject:_firstNameYomi forKey:RECORD_FIRST_NAME_YOMI];
    }
    if (_jobTitle) {
        [contactDic setObject:_jobTitle forKey:RECORD_JOB_NAME];
    }
    if (_lastName) {
        [contactDic setObject:_lastName forKey:RECORD_LAST_NAME];
    }
    if (_lastNameYomi) {
        [contactDic setObject:_lastNameYomi forKey:RECORD_LAST_NAME_YOMI];
    }
    if (_middleName) {
        [contactDic setObject:_middleName forKey:RECORD_MIDDLE_NAME];
    }
    if (_nickname) {
        [contactDic setObject:_nickname forKey:RECORD_NICK_NAME];
    }
    if (_notes) {
        [contactDic setObject:_notes forKey:RECORD_NOTES];
    }
    if (_suffix) {
        [contactDic setObject:_suffix forKey:RECORD_SUFFIX];
    }
    if (_title) {
        [contactDic setObject:_title forKey:RECORD_TITLE];
    }
    NSMutableDictionary *totalDateDic = [[NSMutableDictionary alloc]init];
    if (_dateArray && _dateArray.count > 0) {
        for (IMBContactKeyValueEntity *entity in _dateArray) {
            NSDictionary *dic = [entity objectToDic];
            [totalDateDic setObject:[dic objectForKey:[dic.allKeys objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        }
    }
    NSMutableDictionary *totalRelateDic = [[NSMutableDictionary alloc]init];
    if (_relatedNameArray && _relatedNameArray.count > 0) {
        for (IMBContactKeyValueEntity *entity in _relatedNameArray) {
            NSDictionary *dic = [entity objectToDic];
            [totalRelateDic setObject:[dic objectForKey:[dic.allKeys objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        }
    }
    NSMutableDictionary *totalPhoneNumberDic = [[NSMutableDictionary alloc]init];
    if (_phoneNumberArray && _phoneNumberArray.count >0) {
        for (IMBContactKeyValueEntity *entity in _phoneNumberArray) {
            NSDictionary *dic = [entity objectToDic];
            [totalPhoneNumberDic setObject:[dic objectForKey:[dic.allKeys objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        }
    }
    NSMutableDictionary *totalEmailAddressDic = [[NSMutableDictionary alloc]init];
    if (_emailAddressArray && _emailAddressArray.count > 0) {
        for (IMBContactKeyValueEntity *entity in _emailAddressArray) {
            NSDictionary *dic = [entity objectToDic];
            [totalEmailAddressDic setObject:[dic objectForKey:[dic.allKeys objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        }
    }
    NSMutableDictionary *totalUrlDic = [[NSMutableDictionary alloc]init];
    if (_urlArray && _urlArray.count >0) {
        for (IMBContactKeyValueEntity *entity in _urlArray) {
            NSDictionary *dic = [entity objectToDic];
            [totalUrlDic setObject:[dic objectForKey:[dic.allKeys objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        }
    }
    NSMutableDictionary *totalIMDic = [[NSMutableDictionary alloc]init];
    if (_IMArray && _IMArray.count >0) {
        for (IMBContactIMEntity *entity in _IMArray) {
            NSDictionary *dic = [entity objectToDic];
            [totalIMDic setObject:[dic objectForKey:[dic.allKeys objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        }
    }
    NSMutableDictionary *totalAddressDic = [[NSMutableDictionary alloc]init];
    if (_addressArray && _addressArray.count > 0) {
        for (IMBContactAddressEntity *entity in _addressArray) {
            NSDictionary *dic = [entity objectToDic];
            [totalAddressDic setObject:[dic objectForKey:[dic.allKeys objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        }
    }
    if (contactDic.allKeys.count > 0) {
        [totalValueDic setObject:contactDic forKey:DOMAIN_CONTACT];
    }
    [contactDic release];
    
    if (totalDateDic.allKeys.count > 0) {
        [totalValueDic setObject:totalDateDic forKey:DOMAIN_DATE];
    }
    [totalDateDic release];
    
    if (totalEmailAddressDic.allKeys.count > 0) {
        [totalValueDic setObject:totalEmailAddressDic forKey:DOMAIN_EMAIL_ADDRESS];
    }
    [totalEmailAddressDic release];
    
    if (totalIMDic.allKeys.count > 0) {
        [totalValueDic setObject:totalIMDic forKey:DOMAIN_IM];
    }
    [totalIMDic release];
    if (totalPhoneNumberDic.allKeys.count > 0) {
        [totalValueDic setObject:totalPhoneNumberDic forKey:DOMAIN_PHONE_NUMBER];
    }
    [totalPhoneNumberDic release];
    
    if (totalRelateDic.allKeys.count > 0) {
        [totalValueDic setObject:totalRelateDic forKey:DOMAIN_RELATED_NAME];
    }
    [totalRelateDic release];
    
    if (totalAddressDic.allKeys.count > 0) {
        [totalValueDic setObject:totalAddressDic forKey:DOMAIN_STREET_ADDRESS];
    }
    [totalAddressDic release];
    
    if (totalUrlDic.allKeys.count > 0) {
        [totalValueDic setObject:totalUrlDic forKey:DOMAIN_URL];
    }
    [totalUrlDic release];
    
    [finalDic setObject:totalValueDic forKey:[NSString stringWithFormat:@"%d",[_entityID intValue]]];
    return finalDic;
}


-(id)mutableCopyWithZone:(NSZone *)zone{
    IMBContactEntity *entity = [[IMBContactEntity allocWithZone:zone]init];
    entity->_entityID =  [_entityID retain];
    entity->_contactId = [_contactId mutableCopy];
//    entity->_birthday = [_birthday mutableCopy];
    if (_birthday != nil) {
        entity->_birthday = [[NSDate dateWithTimeIntervalSince1970:[_birthday timeIntervalSince1970]] retain];
    }
    entity->_companyName = [_companyName mutableCopy];
    entity->_department = [_department mutableCopy];
    entity->_displayAsCompany = [_displayAsCompany mutableCopy];
    entity->_firstName = [_firstName mutableCopy];
    entity->_firstNameYomi = [_firstNameYomi mutableCopy];
    entity->_jobTitle = [_jobTitle mutableCopy];
    entity->_middleName = [_middleName mutableCopy];
    entity->_lastName = [_lastName mutableCopy];
    entity->_lastNameYomi = [_lastNameYomi mutableCopy];
    entity->_notes = [_notes mutableCopy];
    entity->_suffix = [_suffix mutableCopy];
    entity->_title = [_title mutableCopy];
    entity->_dateArray = [[self dateArray] mutableCopyWithZone:zone];
    entity->_relatedNameArray = [[self relatedNameArray] mutableCopyWithZone:zone];
    entity->_phoneNumberArray = [[self phoneNumberArray] mutableCopyWithZone:zone];
    entity->_emailAddressArray = [[self emailAddressArray] mutableCopyWithZone:zone];
    entity->_urlArray = [[self urlArray] mutableCopyWithZone:zone];
    entity->_IMArray = [[self IMArray] mutableCopyWithZone:zone];
    entity->_addressArray = [[self addressArray] mutableCopyWithZone:zone];
    return entity;
}

- (NSMutableArray *)phoneNumberArray
{
    if (_phoneNumberArray == nil) {
        _phoneNumberArray = [[NSMutableArray array] retain];
    }
    
    return _phoneNumberArray;
}

- (NSMutableArray *)emailAddressArray
{

    if (_emailAddressArray == nil) {
        _emailAddressArray = [[NSMutableArray array] retain];
    }
    
    return _emailAddressArray;

}

- (NSMutableArray *)relatedNameArray
{
    if (_relatedNameArray == nil) {
        _relatedNameArray = [[NSMutableArray array] retain];
    }
    
    return _relatedNameArray;
}

- (NSMutableArray *)urlArray
{
    if (_urlArray == nil) {
        _urlArray = [[NSMutableArray array] retain];
    }
    
    return _urlArray;
}

- (NSMutableArray *)dateArray
{
    if (_dateArray == nil) {
        _dateArray = [[NSMutableArray array] retain];
    }
    
    return _dateArray;
}

- (NSMutableArray *)addressArray
{
    if (_addressArray == nil) {
        _addressArray = [[NSMutableArray array] retain];
    }
    
    return _addressArray;
}

- (NSMutableArray *)IMArray
{
    if (_IMArray == nil) {
        _IMArray = [[NSMutableArray array] retain];
    }
    
    return _IMArray;
}
- (void)dealloc
{
    [_fullName release],_fullName = nil;
    if (_phoneNumberArray != nil) {
        [_phoneNumberArray release];
        _phoneNumberArray = nil;
    }
    if (_emailAddressArray != nil) {
        [_emailAddressArray release];
        _emailAddressArray = nil;
    }
    if (_relatedNameArray != nil) {
        [_relatedNameArray release];
        _relatedNameArray = nil;
    }
    if (_urlArray != nil) {
        [_urlArray release];
        _urlArray = nil;
    }
    if (_dateArray != nil) {
        [_dateArray release];
        _dateArray = nil;
    }
    if(_addressArray != nil){
        [_addressArray release];
        _addressArray = nil;
    }
    if (_IMArray != nil) {
        [_IMArray release];
        _IMArray = nil;
    }
    
    [super dealloc];
}


@end

@implementation IMBContactKeyValueEntity
@synthesize label = _label;
@synthesize value = _value;

-(void)dicToObject:(NSDictionary *)dic{
    NSArray *preformatKeys = [[dic.allKeys objectAtIndex:0] componentsSeparatedByString:@"/"];
    for(int i = 0;i<3;i++){
        switch (i) {
            case 0:
                self.contactCategory = [[preformatKeys objectAtIndex:i]intValue];
                break;
            case 1:
                self.contactId = [preformatKeys objectAtIndex:i];
                break;
            case 2:
            {
                NSString *string = [preformatKeys objectAtIndex:i];
                NSNumber *number = nil;
                if (string.length > 0) {
                    @try {
                        number = [NSNumber numberWithLongLong:[string longLongValue]];
                        self.entityID = number;
                    }
                    @catch (NSException *exception) {
                        NSLog(@"exception:%@",exception.description);
                    }
                }
            }
                break;
            default:
                break;
        }
    }
    NSDictionary *valueDic = [dic objectForKey:[dic.allKeys objectAtIndex:0]];
    if ([valueDic.allKeys containsObject:@"label"]) {
        self.label = [valueDic objectForKey:@"label"];
    }
    if ([valueDic.allKeys containsObject:@"value"]) {
        if (_contactCategory == Contact_Date) {
            self.value = [valueDic objectForKey:@"value"];
        }
        else{
            self.value = [valueDic objectForKey:@"value"];
        }
    }
    if ([valueDic.allKeys containsObject:@"type"]) {
        self.type = [valueDic objectForKey:@"type"];
    }
    else{
        self.type = TYPE_OTHER;
    }
}

-(NSDictionary*)objectToDic{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    NSString *preFormatKey = [NSString stringWithFormat:@"%d/%@/%@",_contactCategory,_contactId,_entityID];
    NSMutableDictionary *valueDic = [[NSMutableDictionary alloc]init];
    switch (self.contactCategory) {
        case Contact_PhoneNumber:
        {
            [valueDic setObject:DOMAIN_PHONE_NUMBER forKey:RECORD_ENTITY_NAME];
            
        }
            break;
        case Contact_EmailAddressNumber:
        {
            [valueDic setObject:DOMAIN_EMAIL_ADDRESS forKey:RECORD_ENTITY_NAME];
        }
            break;
        case Contact_RelatedName:
        {
            [valueDic setObject:DOMAIN_RELATED_NAME forKey:RECORD_ENTITY_NAME];
        }
            break;
        case Contact_URL:
        {
            [valueDic setObject:DOMAIN_URL forKey:RECORD_ENTITY_NAME];
        }
            break;
        case Contact_Date:
        {
            [valueDic setObject:DOMAIN_DATE forKey:RECORD_ENTITY_NAME];
        }
            break;
        default:
            break;
    }
    [valueDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[_contactId integerValue]], nil] forKey:@"contact"];
    if (!_type) {
        _type = TYPE_OTHER;
    }
    if (_label) {
        [valueDic setObject:_label forKey:@"label"];
    }
    [valueDic setObject:_type forKey:@"type"];
    if (_value) {
        if (_contactCategory == Contact_Date) {
            [valueDic setObject:_value forKey:@"value"];
        }
        else{
            [valueDic setObject:_value forKey:@"value"];
        }
    }
    
    [dictionary setObject:valueDic forKey:[NSString stringWithCString:[preFormatKey UTF8String] encoding:NSUTF8StringEncoding]];
    return dictionary;
}

- (BOOL)isEmpty{
    BOOL isEmpty = false;
    if ([_value isKindOfClass:[NSString class]] || _value == nil) {
        isEmpty = ((NSString *)_value).length == 0;
    }
    else if([_value isKindOfClass:[NSDate class]]){
        isEmpty = _value == nil;
    }
    return isEmpty;
}

- (void)dealloc{
    [super dealloc];
}

@end

@implementation IMBContactAddressEntity
@synthesize country = _country;
@synthesize postalCode = _postalCode;
@synthesize street = _street;
@synthesize city = _city;
@synthesize state = _state;
@synthesize label = _label;

@synthesize countryCode = _countryCode;

-(void)dicToObject:(NSDictionary *)dic{
    NSArray *preFormatKeys = [[dic.allKeys objectAtIndex:0] componentsSeparatedByString:@"/"];
    for(int i = 0;i<3;i++){
        switch (i) {
            case 0:
                self.contactCategory = [[preFormatKeys objectAtIndex:i]intValue];
                break;
            case 1:
                self.contactId = [preFormatKeys objectAtIndex:i];
                break;
            case 2:
                self.entityID = [preFormatKeys objectAtIndex:i];
                break;
            default:
                break;
        }
    }
    NSDictionary *valueDic = [dic objectForKey:[dic.allKeys objectAtIndex:0]];
    if ([valueDic.allKeys containsObject:@"city"]) {
        self.city = [valueDic objectForKey:@"city"];
    }
    if ([valueDic.allKeys containsObject:@"country"]) {
        self.country = [valueDic objectForKey:@"country"];
    }
    if ([valueDic.allKeys containsObject:@"postal code"]) {
        self.postalCode = [valueDic objectForKey:@"postal code"];
    }
    if ([valueDic.allKeys containsObject:@"country code"]) {
        self.countryCode = [valueDic objectForKey:@"country code"];
    }
    if ([valueDic.allKeys containsObject:@"state"]) {
        self.state = [valueDic objectForKey:@"state"];
    }
    if ([valueDic.allKeys containsObject:@"street"]) {
        self.street = [valueDic objectForKey:@"street"];
    }
    if ([valueDic.allKeys containsObject:@"type"]) {
        self.type = [valueDic objectForKey:@"type"];
    }
    else{
        self.type = TYPE_OTHER;
    }
    if ([valueDic.allKeys containsObject:@"label"]) {
        self.label = [valueDic objectForKey:@"label"];
    }
    
}

-(NSDictionary*)objectToDic{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    NSString *preFormatKey = [NSString stringWithFormat:@"%d/%@/%@",_contactCategory,_contactId,_entityID];
    NSMutableDictionary *valueDic = [[NSMutableDictionary alloc]init];
    if (!_type) {
        _type = TYPE_OTHER;
    }
    if (_city) {
        [valueDic setObject:_city forKey:@"city"];
    }
    [valueDic setObject:DOMAIN_STREET_ADDRESS forKey:RECORD_ENTITY_NAME];
    [valueDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[_contactId integerValue]], nil] forKey:@"contact"];
    if (_country) {
        [valueDic setObject:_country forKey:@"country"];
    }
    if (_countryCode) {
        [valueDic setObject:_countryCode forKey:@"country code"];
    }
    if (_postalCode) {
        [valueDic setObject:_postalCode forKey:@"postal code"];
    }
    if (_state) {
        [valueDic setObject:_state forKey:@"state"];
    }
    if (_street) {
        [valueDic setObject:_street forKey:@"street"];
    }
    if (_label) {
        [valueDic setObject:_label forKey:@"label"];
    }
    [valueDic setObject:_type forKey:@"type"];
    
    [dictionary setObject:valueDic forKey:[NSString stringWithCString:[preFormatKey UTF8String] encoding:NSUTF8StringEncoding]];
    return dictionary;
}

- (BOOL)isEmpty{
    BOOL isEmpty = _city.length == 0 && _country.length == 0 && _countryCode.length == 0 && _postalCode.length == 0 && _state.length == 0 && _street.length == 0;
    return isEmpty;
}

- (void)dealloc{


    
    [super dealloc];
}

@end

@implementation IMBContactIMEntity

@synthesize label = _label;
@synthesize user = _user;
@synthesize service = _service;


-(void)dicToObject:(NSDictionary *)dic{
    NSArray *preFormatKeys = [[dic.allKeys objectAtIndex:0] componentsSeparatedByString:@"/"];
    for(int i = 0;i<3;i++){
        switch (i) {
            case 0:
                self.contactCategory = [[preFormatKeys objectAtIndex:i]intValue];
                break;
            case 1:
                self.contactId = [preFormatKeys objectAtIndex:i];
                break;
            case 2:
                self.entityID = [preFormatKeys objectAtIndex:i];
                break;
            default:
                break;
        }
    }
    NSDictionary *valueDic = [dic objectForKey:[dic.allKeys objectAtIndex:0]];
    if ([valueDic.allKeys containsObject:@"label"]) {
        self.label = [valueDic objectForKey:@"label"];
    }
    if ([valueDic.allKeys containsObject:@"type"]) {
        self.type = [valueDic objectForKey:@"type"];
    }
    else{
        self.type = TYPE_OTHER;
    }
    if ([valueDic.allKeys containsObject:@"user"]) {
        self.user =  [valueDic objectForKey:@"user"];
    }
    if ([valueDic.allKeys containsObject:@"service"]) {
        self.service = [valueDic objectForKey:@"service"];
    }
    
}

- (void)setLabel:(NSString *)label{
    [_label release];
    _label = [label retain];
    NSLog(@"123");
}

-(NSDictionary*)objectToDic{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    NSString *preFormatKey = [NSString stringWithFormat:@"%d/%@/%@",_contactCategory,_contactId,_entityID];
    NSMutableDictionary *valueDic = [[NSMutableDictionary alloc]init];
    [valueDic setObject:DOMAIN_IM forKey:RECORD_ENTITY_NAME];
    [valueDic setObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)[_contactId integerValue]], nil] forKey:@"contact"];
    if (!_type) {
        _type = TYPE_OTHER;
    }
    if (_service) {
        [valueDic setObject:[_service lowercaseString] forKey:@"service"];
        [valueDic setObject:[_service uppercaseString] forKey:@"label"];
    }
//    if (_label) {
//        [valueDic setObject:_label forKey:@"label"];
//    }
    
    [valueDic setObject:_type forKey:@"type"];
    
    if (_user) {
        [valueDic setObject:_user forKey:@"user"];
    }
    
    [dictionary setObject:valueDic forKey:[NSString stringWithCString:[preFormatKey UTF8String] encoding:NSUTF8StringEncoding]];
    return dictionary;
}

- (BOOL)isEmpty{
    BOOL isEmpty = _user.length == 0;
    return isEmpty;
}

@end

