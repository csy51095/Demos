//
//  ViewController.m
//  CompareTransformDemo
//  Copyright © 2019 M. All rights reserved.
//

#import "ViewController.h"
#import <PinYin4ObjC/PinYin4Objc.h>

@interface ViewController ()
@property (nonatomic, copy) NSArray *users;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.users = [NSArray arrayWithContentsOfURL: [[NSBundle mainBundle] URLForResource:@"users" withExtension:@"plist"]];
    
    [self pinyin4ObjC];
    [self 最终版];
    [self 网友推荐];
    [self 正则表达式优先过滤英文数字特殊字符等];
    [self 参考NSHipster];
}

#pragma mark -
#pragma mark - PinYin4ObjC
- (void)pinyin4ObjC {
    double time = CFAbsoluteTimeGetCurrent();
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    NSMutableArray *array = NSMutableArray.array;
    for (NSDictionary *dict in self.users) {
        @autoreleasepool {
            NSString *name = dict[@"name"];
            NSString *pinyin = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
            [array addObject:pinyin];
        }
    }
    NSLog(@"%s: %f",__func__, CFAbsoluteTimeGetCurrent() - time);
}

#pragma mark -
#pragma mark - 最终版
- (void)最终版 {
    double time = CFAbsoluteTimeGetCurrent();
    NSMutableArray *array = NSMutableArray.array;
    for (NSDictionary *dict in self.users) {
        @autoreleasepool {
            NSString *name = dict[@"name"];
            NSString *pinyin = [self transformToPinyin_A:name];
            [array addObject:pinyin];
        }
    }
    NSLog(@"%s: %f",__func__, CFAbsoluteTimeGetCurrent() - time);
}

- (NSString *)transformToPinyin_A:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}


#pragma mark -
#pragma mark - 网友推荐
- (void)网友推荐 {
    double time1 = CFAbsoluteTimeGetCurrent();
    NSMutableArray *array = NSMutableArray.array;
    for (NSDictionary *dict in self.users) {
        @autoreleasepool {
            NSString *name = dict[@"name"];
            NSString *pinyin = [self transform_C:name];
            [array addObject:pinyin];
        }
    }
    NSLog(@"%s: %f",__func__, CFAbsoluteTimeGetCurrent() - time1);
}

- (NSString *)transform_C:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    return mutableString;
}


#pragma mark -
#pragma mark - 正则表达式优先过滤英文数字特殊字符等
- (void)正则表达式优先过滤英文数字特殊字符等 {
    double time = CFAbsoluteTimeGetCurrent();
    NSMutableArray *array = NSMutableArray.array;
    for (NSDictionary *dict in self.users) {
        @autoreleasepool {
            NSString *name = dict[@"name"];
            NSString *pinyin = [self transform_D:name];
            [array addObject:pinyin];
        }
    }
    NSLog(@"%s: %f",__func__, CFAbsoluteTimeGetCurrent() - time);
}


- (NSString *)transform_D:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    BOOL isNeedTransform = ![self isAllEngNumAndSpecialSign:string];
    if (isNeedTransform) {
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    }
    return mutableString;
}


#pragma mark -
#pragma mark - 参考NSHipster
- (void)参考NSHipster {
    double time = CFAbsoluteTimeGetCurrent();
    NSMutableArray *array = NSMutableArray.array;
    for (NSDictionary *dict in self.users) {
        @autoreleasepool {
            NSString *name = dict[@"name"];
            NSString *pinyin = [self transform_E:name];
            [array addObject:pinyin];
        }
    }
    NSLog(@"%s: %f",__func__, CFAbsoluteTimeGetCurrent() - time);
}

- (NSString *)transform_E:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    BOOL isNeedTransform = ![self isAllEngNumAndSpecialSign:string];
    if (isNeedTransform) {
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, false);
    }
    return mutableString;
}


- (BOOL)isAllEngNumAndSpecialSign:(NSString *)string {
    NSString *regularString = @"^[A-Za-z0-9\\p{Z}\\p{P}]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularString];
    return [predicate evaluateWithObject:string];
}

@end
