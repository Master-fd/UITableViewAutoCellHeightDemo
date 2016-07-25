//
//  FDTableViewCell.h
//  UITableViewDemo
//
//  Created by asus on 16/7/23.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDDataModel;

typedef void (^FDTableViewCellBlock)(NSIndexPath *indexPath);

@interface FDTableViewCell : UITableViewCell


@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) FDTableViewCellBlock block;


/**
 *  配置cell
 */
- (void)configCellWithModel:(FDDataModel *)model;

/**
 *  获取高度
 */
- (CGFloat)heightWithModel:(FDDataModel *)model;

@end
