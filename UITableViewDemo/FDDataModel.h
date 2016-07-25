//
//  FDDataModel.h
//  UITableViewDemo
//
//  Created by asus on 16/7/23.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDDataModel : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) NSInteger statusId;
@end
