//
//  ViewController.m
//  AES+Crypt
//
//  Created by caoyong on 2019/1/4.
//  Copyright © 2019 caoyong. All rights reserved.
//

#import "ViewController.h"
#import "AESCrypt.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * password = @"AS2r4n78wq24tb5npFVe452GB3faR4Mw";
    NSString * text = @"abrrtggqefewfqewf";
    
    NSString * encryptString = [AESCrypt ordinaryAES256ParmStringEncryptWithKey:password encryptWithParm:text withEncryptParamIv:text];
    NSString * str = [AESCrypt ordinaryAES256ParmStringdDecryptWithKey:password dncryptWithParm:encryptString withDecryptParamIv:text];
    NSLog(@"=====%@",str);
    
    
    NSString * text1 = @"曹勇你好厉害niafagad";
    NSString * two1 = [AESCrypt additionAESParmEncryptWithKey:password encryptParm:text1 withEncryptParamIv:password];
    NSString * two2 = [AESCrypt additionAESParmdDecryptWithKey:password decryptParm:two1 withDecryptParamIv:password];
    NSLog(@"%@===",two2);
    
    
   NSString * text2 = @"json数据格式处理结果我我也知道不不容说加密粗啊i肯恩旭涛不二不听你饿组";
    //NSDictionary * text2 = @{@"resultCode":@"12345",@"message":@"123",@"error":@"345",@"data":@"data"};
    NSString * three1 = [AESCrypt additionAES256EncryptParamWithKey:password encryptParam:text2 withEncryptParamIV:password];
    NSString * three2 = [AESCrypt additionAES256DecryptParamWithKey:password decryptParam:three1 withDecryptParamIV:password];
    
    NSLog(@"%@===",three2);
}


@end
