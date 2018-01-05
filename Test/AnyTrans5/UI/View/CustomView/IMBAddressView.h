//
//  IMBAddressView.h
//  iMobieTrans
//
//  Created by iMobie on 5/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBTextField.h"
#import "IMBPopupButton.h"
#import "IMBContactEntity.h"
#import "IMBContactItemView.h"
#define TEXTCHANGENOTIFICATION @"NSTextDidChangeNotification"

/* 
 NSString *_country;
 NSString *_postalCode;
 NSString *_addrstate;//
 NSString *_street;
 NSString *_type;//如home
 NSString *_state;
 NSString *_countryCode;
 NSString *_city;
 NSString *_label;
*/
@interface IMBAddressView : IMBContactItemView<InternalLayoutChange>{
    CGFloat _compHeight;
    NSArray *_labelArr;
    NSString *_keyString;
    IMBPopupButton *_popupButton;
    IMBTextField *_StreetField;
    IMBTextField *_CityField;
    IMBTextField *_StateField;
    IMBTextField *_ZIPField;
    IMBTextField *_CountryField;
    IMBTextField *_CountryCodeField;
    IMBContactAddressEntity *_addressEntity;
    
    BOOL isEditingChanged;
    BOOL _isLastItem;
}

@property (nonatomic,retain,setter = setLabelArr:) NSArray *labelArr;
@property (nonatomic,retain,setter = setKeyString:) NSString *keyString;
@property (nonatomic,retain,setter = setStreet:,getter = street) NSString *street;
@property (nonatomic,retain,setter = setCity:,getter = city) NSString *city;
@property (nonatomic,retain,setter = setState:,getter = state) NSString *state;
@property (nonatomic,retain,setter = setZip:,getter = zip) NSString *zip;
@property (nonatomic,retain,setter = setCountry:,getter = country) NSString *country;
@property (nonatomic,retain,setter = setCountryCode:,getter = countryCode) NSString *countryCode;

@property (nonatomic,retain) IMBContactAddressEntity *addressEntity;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL isLastItem;

- (void)setIsEditing:(BOOL)isEditing;
- (void)setKeyString:(NSString *)keyString;
- (void)setStreet:(NSString*)street;
- (void)setCity:(NSString *)city;
- (void)setState:(NSString *)state;
- (void)setZip:(NSString *)zip;
- (void)setCountry:(NSString *)country;
- (void)setCountryCode:(NSString *)countryCode;

- (NSString *)street;
- (NSString *)city;
- (NSString *)state;
- (NSString *)zip;
- (NSString *)country;
- (NSString *)countryCode;
@end
