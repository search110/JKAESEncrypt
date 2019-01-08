//
//  NSString+Empty.m
//  AES+Crypt
//
//  Created by caoyong on 2019/1/7.
//  Copyright © 2019 caoyong. All rights reserved.
//

#import "NSString+Empty.h"

@implementation NSString (Empty)

+(BOOL)isEmptyWithStr:(NSString *)currentStr
{
    if ([currentStr isEqual:[NSNull class]] || [currentStr isEqual:[NSNull null]] || currentStr == nil || currentStr == NULL){
        return YES;
    }else{
        if ([currentStr isKindOfClass:[NSString class]]) {
            if ([currentStr isEqualToString:@""] || [currentStr stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
                return YES;
            }
        }
    }
    return NO;
}

+(NSString*)dictionaryTranfromToJson:(NSDictionary *)dict
{
    __autoreleasing NSError * _Nullable  error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


+(NSDictionary*)jsonStringTranFromToDict:(NSString *)jsonString
{
    if (jsonString == nil){
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
     __autoreleasing NSError * _Nullable  error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

@end
