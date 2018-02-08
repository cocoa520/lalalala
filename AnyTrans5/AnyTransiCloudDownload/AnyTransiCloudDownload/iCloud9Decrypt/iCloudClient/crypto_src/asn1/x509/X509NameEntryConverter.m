//
//  X509NameEntryConverter.m
//  crypto
//
//  Created by JGehry on 7/13/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509NameEntryConverter.h"
#import "ASN1InputStream.h"
#import "DERPrintableString.h"

@implementation X509NameEntryConverter

- (ASN1Primitive *)convertHexEncoded:(NSString *)paramString paramInt:(int)paramInt {
    paramString = [paramString lowercaseString];
    NSMutableData *arrayOfByte = [[NSMutableData alloc] initWithSize:(int)(([paramString length] - paramInt) / 2)];
    for (int i = 0; i != arrayOfByte.length; i++) {
        int j = [paramString characterAtIndex:i * 2 + paramInt];
        int k = [paramString characterAtIndex:i * 2 + paramInt + 1];
        if (j < 97) {
            ((Byte *)[arrayOfByte bytes])[i] = ((Byte)((j - 48) << 4));
        }else {
            ((Byte *)[arrayOfByte bytes])[i] = ((Byte)((j - 97 + 10) << 4));
        }
        if (k < 97) {
            int tmp99_97 = i;
            NSMutableData *tmp99_96 = arrayOfByte;
            ((Byte *)[tmp99_96 bytes])[tmp99_97] = (Byte)((((Byte *)[tmp99_96 bytes])[tmp99_97]) | ((Byte)(k - 48)));
        }else {
            int tmp116_114 = i;
            NSMutableData *tmp116_113 = arrayOfByte;
            ((Byte *)[tmp116_113 bytes])[tmp116_114] = (Byte)((((Byte *)[tmp116_113 bytes])[tmp116_114]) | ((Byte)(k - 97 + 10)));
        }
    }
    ASN1InputStream *localASN1InputStream = [[ASN1InputStream alloc] initParamArrayOfByte:arrayOfByte];
    ASN1Primitive *primitive = [localASN1InputStream readObject];
#if !__has_feature(objc_arc)
    if (arrayOfByte) [arrayOfByte release]; arrayOfByte = nil;
    if (localASN1InputStream) [localASN1InputStream release]; localASN1InputStream = nil;
#endif
    return primitive;
}

- (BOOL)canBePrintable:(NSString *)paramString {
    return [DERPrintableString isPrintableString:paramString];
}

- (ASN1Primitive *)getConvertedValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    return nil;
}

@end
