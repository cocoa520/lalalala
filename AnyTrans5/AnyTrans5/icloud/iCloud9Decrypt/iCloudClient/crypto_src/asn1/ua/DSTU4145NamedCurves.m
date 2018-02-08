//
//  DSTU4145NamedCurves.m
//  crypto
//
//  Created by JGehry on 6/20/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DSTU4145NamedCurves.h"
#import "CategoryExtend.h"
#import "BigInteger.h"
#import "UAObjectIdentifiers.h"
#import "ECCurve.h"
#import "ECDomainParameters.h"

@implementation DSTU4145NamedCurves

+ (BigInteger *)ZERO {
    static BigInteger *_ZERO = nil;
    @synchronized(self) {
        if (!_ZERO) {
            _ZERO = [BigInteger Zero];
        }
    }
    return _ZERO;
}

+ (BigInteger *)ONE {
    static BigInteger *_ONE = nil;
    @synchronized(self) {
        if (!_ONE) {
            _ONE = [BigInteger One];
        }
    }
    return _ONE;
}

+ (NSMutableArray *)params {
    static NSMutableArray *_params = nil;
    @synchronized(self) {
        if (!_params) {
            _params = [[NSMutableArray alloc] initWithSize:10];
        }
    }
    return _params;
}

+ (NSMutableArray *)oids {
    static NSMutableArray *_oids = nil;
    @synchronized(self) {
        if (!_oids) {
            _oids = [[NSMutableArray alloc] initWithSize:10];
        }
    }
    return _oids;
}

+ (NSString *)oidBase {
    static NSString *_oidBase = nil;
    @synchronized(self) {
        if (!_oidBase) {
            _oidBase = [[NSString stringWithFormat:@"%@.2.", [[UAObjectIdentifiers dstu4145le] getId]] retain];
        }
    }
    return _oidBase;
}

+ (NSMutableArray *)getOIDs {
    return [self oids];
}

+ (void)load {
    [super load];
    
    @autoreleasepool {
        NSMutableArray *arrayOfBigInteger1 = [[NSMutableArray alloc] initWithSize:10];
        BigInteger *big00 = [[BigInteger alloc] initWithValue:@"400000000000000000002BEC12BE2262D39BCF14D" withRadix:16];
        BigInteger *big01 = [[BigInteger alloc] initWithValue:@"3FFFFFFFFFFFFFFFFFFFFFB12EBCC7D7F29FF7701F" withRadix:16];
        BigInteger *big02 = [[BigInteger alloc] initWithValue:@"800000000000000000000189B4E67606E3825BB2831" withRadix:16];
        BigInteger *big03 = [[BigInteger alloc] initWithValue:@"3FFFFFFFFFFFFFFFFFFFFFFB981960435FE5AB64236EF" withRadix:16];
        BigInteger *big04 = [[BigInteger alloc] initWithValue:@"40000000000000000000000069A779CAC1DABC6788F7474F" withRadix:16];
        BigInteger *big05 = [[BigInteger alloc] initWithValue:@"1000000000000000000000000000013E974E72F8A6922031D2603CFE0D7" withRadix:16];
        BigInteger *big06 = [[BigInteger alloc] initWithValue:@"800000000000000000000000000000006759213AF182E987D3E17714907D470D" withRadix:16];
        BigInteger *big07 = [[BigInteger alloc] initWithValue:@"3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC079C2F3825DA70D390FBBA588D4604022B7B7" withRadix:16];
        BigInteger *big08 = [[BigInteger alloc] initWithValue:@"40000000000000000000000000000000000000000000009C300B75A3FA824F22428FD28CE8812245EF44049B2D49" withRadix:16];
        BigInteger *big09 = [[BigInteger alloc] initWithValue:@"3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBA3175458009A8C0A724F02F81AA8A1FCBAF80D90C7A95110504CF" withRadix:16];
        arrayOfBigInteger1[0] = big00;
        arrayOfBigInteger1[1] = big01;
        arrayOfBigInteger1[2] = big02;
        arrayOfBigInteger1[3] = big03;
        arrayOfBigInteger1[4] = big04;
        arrayOfBigInteger1[5] = big05;
        arrayOfBigInteger1[6] = big06;
        arrayOfBigInteger1[7] = big07;
        arrayOfBigInteger1[8] = big08;
        arrayOfBigInteger1[9] = big09;
#if !__has_feature(objc_arc)
        if (big00) [big00 release]; big00 = nil;
        if (big01) [big01 release]; big01 = nil;
        if (big02) [big02 release]; big02 = nil;
        if (big03) [big03 release]; big03 = nil;
        if (big04) [big04 release]; big04 = nil;
        if (big05) [big05 release]; big05 = nil;
        if (big06) [big06 release]; big06 = nil;
        if (big07) [big07 release]; big07 = nil;
        if (big08) [big08 release]; big08 = nil;
        if (big09) [big09 release]; big09 = nil;
#endif
        
        NSMutableArray *arrayOfBigInteger2 = [[NSMutableArray alloc] initWithSize:10];
        arrayOfBigInteger2[0] = [BigInteger Two];
        arrayOfBigInteger2[1] = [BigInteger Two];
        arrayOfBigInteger2[2] = [BigInteger Four];
        arrayOfBigInteger2[3] = [BigInteger Two];
        arrayOfBigInteger2[4] = [BigInteger Two];
        arrayOfBigInteger2[5] = [BigInteger Two];
        arrayOfBigInteger2[6] = [BigInteger Four];
        arrayOfBigInteger2[7] = [BigInteger Two];
        arrayOfBigInteger2[8] = [BigInteger Two];
        arrayOfBigInteger2[9] = [BigInteger Two];
        NSMutableArray *arrayOfF2m = [[NSMutableArray alloc] initWithSize:10];
        BigInteger *big0 = [[BigInteger alloc] initWithValue:@"5FF6108462A2DC8210AB403925E638A19C1455D21" withRadix:16];
        F2mCurve *f2m0 = [[F2mCurve alloc] initWithM:163 withK1:3 withK2:6 withK3:7 withA:[self ONE] withB:big0 withOrder:arrayOfBigInteger1[0] withCofactor:arrayOfBigInteger2[0]];
        arrayOfF2m[0] = f2m0;
        
        BigInteger *big1 = [[BigInteger alloc] initWithValue:@"6EE3CEEB230811759F20518A0930F1A4315A827DAC" withRadix:16];
        F2mCurve *f2m1 = [[F2mCurve alloc] initWithM:167 withK:6 withA:[self ONE] withB:big1 withOrder:arrayOfBigInteger1[1] withCofactor:arrayOfBigInteger2[1]];
        arrayOfF2m[1] = f2m1;
        
        BigInteger *big2 = [[BigInteger alloc] initWithValue:@"108576C80499DB2FC16EDDF6853BBB278F6B6FB437D9" withRadix:16];
        F2mCurve *f2m2 = [[F2mCurve alloc] initWithM:173 withK1:1 withK2:2 withK3:10 withA:[self ZERO] withB:big2 withOrder:arrayOfBigInteger1[2] withCofactor:arrayOfBigInteger2[2]];
        arrayOfF2m[2] = f2m2;
        
        BigInteger *big3 = [[BigInteger alloc] initWithValue:@"4A6E0856526436F2F88DD07A341E32D04184572BEB710" withRadix:16];
        F2mCurve *f2m3 = [[F2mCurve alloc] initWithM:179 withK1:1 withK2:2 withK3:4 withA:[self ONE] withB:big3 withOrder:arrayOfBigInteger1[3] withCofactor:arrayOfBigInteger2[3]];
        arrayOfF2m[3] = f2m3;
        
        BigInteger *big4 = [[BigInteger alloc] initWithValue:@"7BC86E2102902EC4D5890E8B6B4981ff27E0482750FEFC03" withRadix:16];
        F2mCurve *f2m4 = [[F2mCurve alloc] initWithM:191 withK:9 withA:[self ONE] withB:big4 withOrder:arrayOfBigInteger1[4] withCofactor:arrayOfBigInteger2[4]];
        arrayOfF2m[4] = f2m4;
        
        BigInteger *big5 = [[BigInteger alloc] initWithValue:@"06973B15095675534C7CF7E64A21BD54EF5DD3B8A0326AA936ECE454D2C" withRadix:16];
        F2mCurve *f2m5 = [[F2mCurve alloc] initWithM:233 withK1:1 withK2:4 withK3:9 withA:[self ONE] withB:big5 withOrder:arrayOfBigInteger1[5] withCofactor:arrayOfBigInteger2[5]];
        arrayOfF2m[5] = f2m5;
        
        BigInteger *big6 = [[BigInteger alloc] initWithValue:@"1CEF494720115657E18F938D7A7942394FF9425C1458C57861F9EEA6ADBE3BE10" withRadix:16];
        F2mCurve *f2m6 = [[F2mCurve alloc] initWithM:257 withK:12 withA:[self ZERO] withB:big6 withOrder:arrayOfBigInteger1[6] withCofactor:arrayOfBigInteger2[6]];
        arrayOfF2m[6] = f2m6;
        
        BigInteger *big7 = [[BigInteger alloc] initWithValue:@"393C7F7D53666B5054B5E6C6D3DE94F4296C0C599E2E2E241050DF18B6090BDC90186904968BB" withRadix:16];
        F2mCurve *f2m7 = [[F2mCurve alloc] initWithM:307 withK1:2 withK2:4 withK3:8 withA:[self ONE] withB:big7 withOrder:arrayOfBigInteger1[7] withCofactor:arrayOfBigInteger2[7]];
        arrayOfF2m[7] = f2m7;
        
        BigInteger *big8 = [[BigInteger alloc] initWithValue:@"43FC8AD242B0B7A6F3D1627AD5654447556B47BF6AA4A64B0C2AFE42CADAB8F93D92394C79A79755437B56995136" withRadix:16];
        F2mCurve *f2m8 = [[F2mCurve alloc] initWithM:367 withK:21 withA:[self ONE] withB:big8 withOrder:arrayOfBigInteger1[8] withCofactor:arrayOfBigInteger2[8]];
        arrayOfF2m[8] = f2m8;
        
        BigInteger *big9 = [[BigInteger alloc] initWithValue:@"03CE10490F6A708FC26DFE8C3D27C4F94E690134D5BFF988D8D28AAEAEDE975936C66BAC536B18AE2DC312CA493117DAA469C640CAF3" withRadix:16];
        F2mCurve *f2m9 = [[F2mCurve alloc] initWithM:431 withK1:1 withK2:3 withK3:5 withA:[self ONE] withB:big9 withOrder:arrayOfBigInteger1[9] withCofactor:arrayOfBigInteger2[9]];
        arrayOfF2m[9] = f2m9;
#if !__has_feature(objc_arc)
        if (big0) [big0 release]; big0 = nil;
        if (big1) [big1 release]; big1 = nil;
        if (big2) [big2 release]; big2 = nil;
        if (big3) [big3 release]; big3 = nil;
        if (big4) [big4 release]; big4 = nil;
        if (big5) [big5 release]; big5 = nil;
        if (big6) [big6 release]; big6 = nil;
        if (big7) [big7 release]; big7 = nil;
        if (big8) [big8 release]; big8 = nil;
        if (big9) [big9 release]; big9 = nil;
        if (f2m0) [f2m0 release]; f2m0 = nil;
        if (f2m1) [f2m1 release]; f2m1 = nil;
        if (f2m2) [f2m2 release]; f2m2 = nil;
        if (f2m3) [f2m3 release]; f2m3 = nil;
        if (f2m4) [f2m4 release]; f2m4 = nil;
        if (f2m5) [f2m5 release]; f2m5 = nil;
        if (f2m6) [f2m6 release]; f2m6 = nil;
        if (f2m7) [f2m7 release]; f2m7 = nil;
        if (f2m8) [f2m8 release]; f2m8 = nil;
        if (f2m9) [f2m9 release]; f2m9 = nil;
#endif
        NSMutableArray *arrayOfECPoint = [[NSMutableArray alloc] initWithSize:10];
        BigInteger *pointBig0 = [[BigInteger alloc] initWithValue:@"2E2F85F5DD74CE983A5C4237229DAF8A3F35823BE" withRadix:16];
        BigInteger *y0 = [[BigInteger alloc] initWithValue:@"3826F008A8C51D7B95284D9D03FF0E00CE2CD723A" withRadix:16];
        arrayOfECPoint[0] = [arrayOfF2m[0] createPoint:pointBig0 withY:y0];
        
        BigInteger *pointBig1 = [[BigInteger alloc] initWithValue:@"7A1F6653786A68192803910A3D30B2A2018B21CD54" withRadix:16];
        BigInteger *y1 = [[BigInteger alloc] initWithValue:@"5F49EB26781C0EC6B8909156D98ED435E45FD59918" withRadix:16];
        arrayOfECPoint[1] = [arrayOfF2m[1] createPoint:pointBig1 withY:y1];
        
        BigInteger *pointBig2 = [[BigInteger alloc] initWithValue:@"4D41A619BCC6EADF0448FA22FAD567A9181D37389CA" withRadix:16];
        BigInteger *y2 = [[BigInteger alloc] initWithValue:@"10B51CC12849B234C75E6DD2028BF7FF5C1CE0D991A1" withRadix:16];
        arrayOfECPoint[2] = [arrayOfF2m[2] createPoint:pointBig2 withY:y2];
        
        BigInteger *pointBig3 = [[BigInteger alloc] initWithValue:@"6BA06FE51464B2BD26DC57F48819BA9954667022C7D03" withRadix:16];
        BigInteger *y3 = [[BigInteger alloc] initWithValue:@"25FBC363582DCEC065080CA8287AAFF09788A66DC3A9E" withRadix:16];
        arrayOfECPoint[3] = [arrayOfF2m[3] createPoint:pointBig3 withY:y3];
        
        BigInteger *pointBig4 = [[BigInteger alloc] initWithValue:@"714114B762F2FF4A7912A6D2AC58B9B5C2FCFE76DAEB7129" withRadix:16];
        BigInteger *y4 = [[BigInteger alloc] initWithValue:@"29C41E568B77C617EFE5902F11DB96FA9613CD8D03DB08DA" withRadix:16];
        arrayOfECPoint[4] = [arrayOfF2m[4] createPoint:pointBig4 withY:y4];
        
        BigInteger *pointBig5 = [[BigInteger alloc] initWithValue:@"3FCDA526B6CDF83BA1118DF35B3C31761D3545F32728D003EEB25EFE96" withRadix:16];
        BigInteger *y5 = [[BigInteger alloc] initWithValue:@"9CA8B57A934C54DEEDA9E54A7BBAD95E3B2E91C54D32BE0B9DF96D8D35" withRadix:16];
        arrayOfECPoint[5] = [arrayOfF2m[5] createPoint:pointBig5 withY:y5];
        
        BigInteger *pointBig6 = [[BigInteger alloc] initWithValue:@"02A29EF207D0E9B6C55CD260B306C7E007AC491CA1B10C62334A9E8DCD8D20FB7" withRadix:16];
        BigInteger *y6 = [[BigInteger alloc] initWithValue:@"10686D41FF744D4449FCCF6D8EEA03102E6812C93A9D60B978B702CF156D814EF" withRadix:16];
        arrayOfECPoint[6] = [arrayOfF2m[6] createPoint:pointBig6 withY:y6];
        
        BigInteger *pointBig7 = [[BigInteger alloc] initWithValue:@"216EE8B189D291A0224984C1E92F1D16BF75CCD825A087A239B276D3167743C52C02D6E7232AA" withRadix:16];
        BigInteger *y7 = [[BigInteger alloc] initWithValue:@"5D9306BACD22B7FAEB09D2E049C6E2866C5D1677762A8F2F2DC9A11C7F7BE8340AB2237C7F2A0" withRadix:16];
        arrayOfECPoint[7] = [arrayOfF2m[7] createPoint:pointBig7 withY:y7];
        
        BigInteger *pointBig8 = [[BigInteger alloc] initWithValue:@"324A6EDDD512F08C49A99AE0D3F961197A76413E7BE81A400CA681E09639B5FE12E59A109F78BF4A373541B3B9A1" withRadix:16];
        BigInteger *y8 = [[BigInteger alloc] initWithValue:@"1AB597A5B4477F59E39539007C7F977D1A567B92B043A49C6B61984C3FE3481AAF454CD41BA1F051626442B3C10" withRadix:16];
        arrayOfECPoint[8] = [arrayOfF2m[8] createPoint:pointBig8 withY:y8];
        
        BigInteger *pointBig9 = [[BigInteger alloc] initWithValue:@"1A62BA79D98133A16BBAE7ED9A8E03C32E0824D57AEF72F88986874E5AAE49C27BED49A2A95058068426C2171E99FD3B43C5947C857D" withRadix:16];
        BigInteger *y9 = [[BigInteger alloc] initWithValue:@"70B5E1E14031C1F70BBEFE96BDDE66F451754B4CA5F48DA241F331AA396B8D1839A855C1769B1EA14BA53308B5E2723724E090E02DB9" withRadix:16];
        arrayOfECPoint[9] = [arrayOfF2m[9] createPoint:pointBig9 withY:y9];
        
#if !__has_feature(objc_arc)
        if (pointBig0) [pointBig0 release]; pointBig0 = nil;
        if (pointBig1) [pointBig1 release]; pointBig1 = nil;
        if (pointBig2) [pointBig2 release]; pointBig2 = nil;
        if (pointBig3) [pointBig3 release]; pointBig3 = nil;
        if (pointBig4) [pointBig4 release]; pointBig4 = nil;
        if (pointBig5) [pointBig5 release]; pointBig5 = nil;
        if (pointBig6) [pointBig6 release]; pointBig6 = nil;
        if (pointBig7) [pointBig7 release]; pointBig7 = nil;
        if (pointBig8) [pointBig8 release]; pointBig8 = nil;
        if (pointBig9) [pointBig9 release]; pointBig9 = nil;
        if (y0) [y0 release]; y0 = nil;
        if (y1) [y1 release]; y1 = nil;
        if (y2) [y2 release]; y2 = nil;
        if (y3) [y3 release]; y3 = nil;
        if (y4) [y4 release]; y4 = nil;
        if (y5) [y5 release]; y5 = nil;
        if (y6) [y6 release]; y6 = nil;
        if (y7) [y7 release]; y7 = nil;
        if (y8) [y8 release]; y8 = nil;
        if (y9) [y9 release]; y9 = nil;
#endif
        
        for (int i = 0; i < [self params].count; i++) {
            ECDomainParameters *parameters = [[ECDomainParameters alloc] initWithCurve:arrayOfF2m[i] withG:arrayOfECPoint[i] withN:arrayOfBigInteger1[i] withH:arrayOfBigInteger2[i]];
            [self params][i] = parameters;
#if !__has_feature(objc_arc)
            if (parameters) [parameters release]; parameters = nil;
#endif
        }
        for (int i = 0; i < [self oids].count; i++) {
            ASN1ObjectIdentifier *object = [[ASN1ObjectIdentifier alloc] initParamString:[NSString stringWithFormat:@"%@%d", [self oidBase], i]];
            [self oids][i] = object;
#if !__has_feature(objc_arc)
            if (object) [object release]; object = nil;
#endif
        }
#if !__has_feature(objc_arc)
        if (arrayOfBigInteger1) [arrayOfBigInteger1 release]; arrayOfBigInteger1 = nil;
        if (arrayOfBigInteger2) [arrayOfBigInteger2 release]; arrayOfBigInteger2 = nil;
#endif
    }
}

@end
