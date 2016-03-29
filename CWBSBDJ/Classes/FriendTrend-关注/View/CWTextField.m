//
//  CWTextField.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/28.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWTextField.h"
#import <UIKit/NSAttributedString.h>

@implementation CWTextField
-(void)awakeFromNib {
    // 设置占位文字
//    NSDictionary *attributesDict = @{NSForegroundColorAttributeName: [UIColor grayColor]};
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributesDict];
    
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
    
    [self addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
    
    [self addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - 监听
- (void)editingDidBegin {
    [self setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
}

- (void)editingDidEnd {
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
}

/**
 *  文体框内部特有的监听编辑状态的方法
 */
//- (BOOL)becomeFirstResponder {
//    [self setValue:[UIColor blueColor] forKeyPath:@"placeholderLabel.textColor"];
//    
//   return  [super becomeFirstResponder];
//}
//
//- (BOOL)resignFirstResponder {
//    [self setValue:[UIColor purpleColor] forKeyPath:@"placeholderLabel.textColor"];
//
//    return [super becomeFirstResponder];
//}
@end
