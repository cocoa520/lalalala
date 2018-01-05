//
//  DERUtils.m
//  
//
//  Created by Pallas on 7/27/16.
//
//  Complete

#import "DERUtils.h"
#import "ASN1InputStream.h"
#import "ASN1Primitive.h"
#import <objc/runtime.h>
#import "DERApplicationSpecific.h"
#import "Arrays.h"

@implementation DERUtils

+ (id)parseWithData:(NSMutableData*)data withClassType:(Class)classType withSel:(SEL)sel withFunction:(IMP)function {
    @try {
        ASN1InputStream *asN1InputStream = [[ASN1InputStream alloc] initParamArrayOfByte:data];
        ASN1Primitive *primitive = [asN1InputStream readObject];
        
        id retObj = [DERUtils parseWithASN1Primitive:primitive withClassType:classType withSel:sel withFunction:function];
#if !__has_feature(objc_arc)
        if (asN1InputStream) [asN1InputStream release]; asN1InputStream = nil;
#endif
        return retObj;
    }
    @catch (NSException *exception) {
        NSLog(@"-- parse() - Exception: %@", [exception reason]);
        return nil;
    }
}

+ (id)parseWithASN1Primitive:(ASN1Primitive*)primitive withClassType:(Class)classType withSel:(SEL)sel withFunction:(IMP)function {
    @try {
        id t = [classType alloc];
        typedef id (*MethodName)(id, SEL, ASN1Primitive*);
        MethodName methodName = (MethodName)function;
        id retObj = methodName(t, sel, primitive);
        return (retObj ? [retObj autorelease] : nil);
    }
    @catch (NSException *exception) {
        NSLog(@"-- parse() - failed decode:: %@", [exception reason]);
        return nil;
    }
}

@end
