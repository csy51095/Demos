//
//  ViewController.m
//  StackViewDemo
//
//  Created by Xian Mo on 2020/8/18.
//  Copyright © 2020 Mo. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

#define StackFixed(w, h) \
^{\
    UIView *view = UIView.new;\
    [view mas_makeConstraints:^(MASConstraintMaker *make) {\
        make.width.mas_equalTo(w);\
        make.height.mas_equalTo(h);\
    }];\
    return view;\
}()

#define StackSpring(axis) \
^{\
    UIView *view = UIView.new; \
    [view mas_makeConstraints:^(MASConstraintMaker *make) {\
        if (axis == UILayoutConstraintAxisHorizontal) {\
            make.width.mas_equalTo(1000).priorityLow();\
        } else {\
            make.height.mas_equalTo(1000).priorityLow();\
        }\
    }];\
    return view;\
}()

@interface ViewController ()

@property (nonatomic, weak) UILabel *label1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [self.class createImageWithColor:UIColor.redColor];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"京东集团";
    label1.textColor = UIColor.blackColor;
    label1.font = [UIFont systemFontOfSize:15.f];
    self.label1 = label1;
    
    UIStackView *topStack = [[UIStackView alloc] initWithArrangedSubviews:@[imgView, StackFixed(10, 0) ,label1]];
    // 不使用 space，用透明view来占位
    topStack.axis = UILayoutConstraintAxisHorizontal;
    topStack.alignment = UIStackViewAlignmentCenter;
    topStack.distribution = UIStackViewDistributionFill;
    
    UILabel *numLab = [UILabel new];
    numLab.text = @"02263";
    numLab.textColor = UIColor.blackColor;
    numLab.font = [UIFont systemFontOfSize:13.f];
    
    // 如果两边都使用弹簧，需要再将弹簧约束为等宽(高)
    UIStackView *numStack = [[UIStackView alloc] initWithArrangedSubviews:@[StackSpring(UILayoutConstraintAxisHorizontal) ,numLab, StackFixed(30, 0)]];
    
    numStack.axis = UILayoutConstraintAxisHorizontal;
    numStack.alignment = UIStackViewAlignmentTrailing;
    numStack.distribution = UIStackViewDistributionFill;
    
    UILabel *bottomLab = [UILabel new];
    NSString *str = @"中签300签";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: UIColor.grayColor}];
    
    NSRange range = [self matchNumberInString:str];
    
    NSAttributedString *replaceAttr = [[NSAttributedString alloc] initWithString:@"4000" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: UIColor.redColor}];
    
    [attrStr replaceCharactersInRange:range withAttributedString:replaceAttr];
    bottomLab.attributedText = attrStr;
    
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[topStack,
                                                                         StackFixed(0, 10),
                                                                         numStack,
                                                                         StackFixed(0, 30),
                                                                         bottomLab]];
    // 不使用 space，用透明view来占位
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.distribution = UIStackViewDistributionFill;
    
    [self.view addSubview:stack];
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(200);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.25 animations:^{
        self.label1.alpha = 0;
    } completion:^(BOOL finished) {
        self.label1.hidden = !self.label1.isHidden;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.label1.hidden = !self.label1.isHidden;
    [UIView animateWithDuration:0.25 animations:^{
        self.label1.alpha = 1;
    }];
}

- (NSRange) matchNumberInString:(NSString *)string {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *numString = [string stringByTrimmingCharactersInSet:nonNumberSet];
    NSRange range = [string rangeOfString:numString];
    return range;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
