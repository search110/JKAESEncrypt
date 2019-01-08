//
//  NSString+Base64.h
//  AES+Crypt
//
//  Created by caoyong on 2019/1/8.
//  Copyright © 2019 caoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Base64)

+(NSString *)base64StringFromData: (NSData *)data length: (NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
