//
//  UITableViewCell+FDAutoCellHeight.h
//  UITableViewDemo
//
//  Created by asus on 16/7/24.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^cellConfigBlock)(UITableViewCell *cell);

@interface UITableViewCell (FDAutoCellHeight)


/**
 *  cell key cell在缓存池中的key
 */
FOUNDATION_EXTERN NSString * const kCellIdKey;
/**
 *  height key height在缓存池中的key
 */
FOUNDATION_EXTERN NSString * const kCellStatusIdKey;

/**
 *  cell 中距离cell底部最后一个控件，必须设置
 */
@property (nonatomic, strong) UIView *lastViewInCell;

/**
 *  cell 中距离cell底部的offset 距离, 必须设置
 */
@property (nonatomic, assign) CGFloat lastViewOffset;


/**
 *  计算cell高度。从cellCachePool中取出cell，计算高度，但是不缓存高度
 *
 *  @return height
 */
+ (CGFloat )heightForTableView:(UITableView *)tableView cellConfig:(cellConfigBlock )config;

/**
 *  计算cell高度，cellCachePool中取出cell，计算高度，缓存到_heightCachePool
 *  一个cell可能对应着多个不同状态，有多个height,使用状态为key，将高度保存到_heightCachePool中
 * cellInfo：字典类型，包含cell id， cell status
 *  @return height
 */
+ (CGFloat )heightForTableView:(UITableView *)tableView cellConfig:(cellConfigBlock )config cache:(NSDictionary *)cellInfo;


@end
