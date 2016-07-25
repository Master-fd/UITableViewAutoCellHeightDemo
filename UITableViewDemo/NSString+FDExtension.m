//
//  NSString+FDExtension.m
//  UITableViewDemo
//
//  Created by asus on 16/7/24.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "NSString+FDExtension.h"

@implementation NSString (FDExtension)


/**
 *  计算一串文字的size
 *
 *  @param maxSize 限制最大size
 *  @param font    字体
 *
 *  @return 文字需要暂用的size
 */
- (CGSize)sizeWithMaxSize:(CGSize )maxSize font:(UIFont *)font
{
    NSDictionary *attr = @{NSFontAttributeName : font};
    
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    return size;
}

/**
 *  计算一串高度不限制的文字size
 *
 *  @param maxWidth 最大宽度
 *  @param font     字体
 *
 *  @return cgsize
 */
- (CGSize)sizeWithMaxWidth:(CGFloat )maxWidth font:(UIFont *)font
{
    NSDictionary *attr = @{NSFontAttributeName : font};
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    
    return size;
}
@end
