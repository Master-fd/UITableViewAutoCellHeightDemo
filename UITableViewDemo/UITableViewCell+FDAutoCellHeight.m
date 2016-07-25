//
//  UITableViewCell+FDAutoCellHeight.m
//  UITableViewDemo
//
//  Created by asus on 16/7/24.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "UITableViewCell+FDAutoCellHeight.h"
#import <objc/runtime.h>

//缓存池
//缓存池是个字典，使用cell id作为key， 每个key里保存着一个字典，使用cell status 作为key。所以每个cell有就是一个字典，有多个状态
static const void *_heightCachePool = @"heightCachePool";
static const void *_cellCachePool = @"cellCachePool";

//cell中最后一个控件的
const void *_lastViewInCell = @"lastViewInCell";
const void *_lastViewOffset = @"lastViewOffset";

//cell key cell在缓存池中的key
NSString * const kCellIdKey = @"CellIdKey";

//height key height在缓存池中的key
NSString * const kCellStatusIdKey = @"CellStatusIdKey";



@implementation UITableViewCell (FDAutoCellHeight)


#pragma mark - 创建缓存池
/**
 *  属性关联的方式，给作为cell 的高度缓存，每个cell可以有很多个状态，每个状态都有一个缓存高度
 *
 *  @return dict
 */
+ (NSMutableDictionary *)heightCachePool
{
    
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _heightCachePool);
    
    if (!dict) {
        
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _heightCachePool, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dict;
}

/**
 *  属性关联的方式，给cell做一个缓存pool，一个tableview可能有种不同cell
 *
 *  @return dict
 */
+ (NSMutableDictionary *)cellCachePool
{
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cellCachePool);
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cellCachePool, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dict;
}

#pragma mark - 创建cell 中最后一个view和距离cell底部距离offset的属性关联
/**
 *  setter 和 getter 方法，cell 中最后一个视图
 */
- (void)setLastViewInCell:(UIView *)lastViewInCell
{
    objc_setAssociatedObject(self, _lastViewInCell, lastViewInCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)lastViewInCell
{
    return objc_getAssociatedObject(self, _lastViewInCell);
}


/**
 *  setter 和 getter 方法， cell中最后一个视图和cell底部的距离
 */
- (void)setLastViewOffset:(CGFloat )lastViewOffset
{
    objc_setAssociatedObject(self, _lastViewOffset, @(lastViewOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat )lastViewOffset
{
    NSNumber *number = objc_getAssociatedObject(self, _lastViewOffset);
    if ([number respondsToSelector:@selector(floatValue)]) {
        return [number floatValue];
    }
    
    return 0;
}


#pragma mark - 计算高度一个cell的高度, 私有方法
- (CGFloat )heightForTableView:(UITableView *)tableView
{
    NSAssert(self.lastViewInCell, @"lastViewInCell=nil，必须指定一个控制为cell的最后一个控件");
    if (!self.lastViewInCell) {
        return 0;
    }
    
    //布局
    [self layoutIfNeeded];
    
    CGFloat height = self.lastViewInCell.frame.size.height + self.lastViewInCell.frame.origin.y + self.lastViewOffset;
    
    return height;
}

#pragma mark - 计算cell高度，公有方法
/**
 *  计算cell高度。从cellCachePool中取出cell，计算高度，但是不缓存高度
 *  优化1：缓存cell，如果不缓存，会消耗大量时间
 *  @return height
 */
+ (CGFloat )heightForTableView:(UITableView *)tableView cellConfig:(cellConfigBlock )config
{
    NSAssert(config != nil, @"没有配置cell，计算高度，必须配置cell");
    
    //从cellCachePool中取出cell，如果没有就新建，并缓存起来
    UITableViewCell *cell = (UITableViewCell *)[[self cellCachePool] objectForKey:[[self class] description]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //放入缓存
        [[self cellCachePool] setObject:cell forKey:[[self class] description]];
    }
    
    if (config) {
        config(cell);
    }
    
    return [cell heightForTableView:tableView];
}

/**
 *  计算cell高度，cellCachePool中取出cell，计算高度，缓存到_heightCachePool
 *  一个cell可能对应着多个不同状态，有多个height,使用状态为key，将高度保存到_heightCachePool中
 * cellInfo：字典类型，包含cell id， cell status
 *  @return height
 */
+ (CGFloat )heightForTableView:(UITableView *)tableView cellConfig:(cellConfigBlock )config cache:(NSDictionary *)cellInfo
{
    NSAssert(config != nil, @"没有配置cell，计算高度，必须配置cell");
    
    CGFloat height = 0;
    if (cellInfo.count) {
        
        NSString *cellKey = cellInfo[kCellIdKey];   //取出cell id
        NSString *heightKey = cellInfo[kCellStatusIdKey]; // 取出 cell status key
        NSMutableDictionary *cellDict = [[self heightCachePool] objectForKey:cellKey];  //使用cell id作为key, 取出cell字典
        if (!cellDict) {  //缓存起来
            cellDict = [NSMutableDictionary dictionary];
            [[self heightCachePool] setObject:cellDict forKey:cellKey];
        }
        
        NSString *heightStr = cellDict[heightKey];  //从cell字典里面,取出对应cell状态的的高度
        if (!heightStr) {
            //没有对应的缓存,则计算高度，并缓存起来
            height = [self heightForTableView:tableView cellConfig:config];
            [cellDict setObject:@(height) forKey:heightKey];
        }else if (heightStr){
            //找到缓存，直接返回
            height = heightStr.floatValue;
        }
    }
    
    return height;
}




@end





