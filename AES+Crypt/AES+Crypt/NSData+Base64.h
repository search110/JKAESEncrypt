//
//  NSData+Base64.h
//  AES+Crypt
//
//  Created by caoyong on 2019/1/8.
//  Copyright © 2019 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Base64)

+(NSData *)base64DataFromString:(NSString *)string;

+(NSData *)transformResultData:(nullable NSData*)result;

@end

NS_ASSUME_NONNULL_END
