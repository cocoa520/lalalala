//
//  NameOrPseudonym.h
//  crypto
//
//  Created by JGehry on 7/7/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Choice.h"
#import "DirectoryString.h"
#import "ASN1Sequence.h"

@interface NameOrPseudonym : ASN1Choice {
@private
    DirectoryString *_pseudonym;
    DirectoryString *_surname;
    ASN1Sequence *_givenName;
}

+ (NameOrPseudonym *)getInstance:(id)paramObject;
- (instancetype)initParamDirectoryString:(DirectoryString *)paramDirectoryString;
- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamDirectoryString:(DirectoryString *)paramDirectoryString paramASN1Sequence:(ASN1Sequence *)paramASN1Sequence;
- (DirectoryString *)getPseudonym;
- (DirectoryString *)getSurname;
- (NSMutableArray *)getGivenName;
- (ASN1Primitive *)toASN1Primitive;

@end
