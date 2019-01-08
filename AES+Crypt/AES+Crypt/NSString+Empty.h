//
//  NSString+Empty.h
//  AES+Crypt
//
//  Created by caoyong on 2019/1/7.
//  Copyright © 2019 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Empty)
/**
 * @param currentStr 判断对象
 *
 * return BOOL 是否为空状态
 */
+(BOOL)isEmptyWithStr:(NSString*)currentStr;
/**
 * @param dict 字典数据
 *
 * return 返回json字符串数据
 */
+(NSString*)dictionaryTranfromToJson:(NSDictionary*)dict;
/**
 * @param jsonString json数据
 *
 * return 返回字典数据
 */
+(NSDictionary*)jsonStringTranFromToDict:(NSString*)jsonString;

@end

NS_ASSUME_NONNULL_END
