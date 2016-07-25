//
//  NSString+FDExtension.h
//  UITableViewDemo
//
//  Created by asus on 16/7/24.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (FDExtension)

/**
 *  计算一串文字的size
 *
 *  @param maxSize 限制最大size
 *  @param font    字体
 *
 *  @return 文字需要暂用的size
 */
- (CGSize)sizeWithMaxSize:(CGSize )maxSize font:(UIFont *)font;

/**
 *  计算一串高度不限制的文字size
 *
 *  @param maxWidth 最大宽度
 *  @param font     字体
 *
 *  @return cgsize
 */
- (CGSize)sizeWithMaxWidth:(CGFloat )maxWidth font:(UIFont *)font;

@end
