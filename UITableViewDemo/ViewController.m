//
//  ViewController.m
//  UITableViewDemo
//
//  Created by asus on 16/7/23.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "ViewController.h"
#import "FDDataModel.h"
#import "FDTableViewCell.h"
#import "UITableViewCell+FDAutoCellHeight.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FDLog(@"UITableView 仿朋友圈 优化测试");
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"全文" style:UIBarButtonItemStyleDone target:self action:@selector(doOn)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)doOn
{
    FDLog(@"do on");
    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0; i < 50; ++i) {
            @autoreleasepool {
                FDDataModel *model = [[FDDataModel alloc] init];
                model.name = @"朱飞东";
                model.desc = @"cell 结合Masonry 自动cell高度计算";

                model.icon = [UIImage imageNamed:@"icon9"];
                model.statusId = i+1;
                [_dataSource addObject:model];
            }
            
        }

    }
    
    return _dataSource;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    FDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[FDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.indexPath = indexPath;
    cell.block = ^(NSIndexPath *path) {
        [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    };
    self.indexPath = indexPath;
    
    FDDataModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDDataModel *model = [self.dataSource objectAtIndex:indexPath.row];
 
    //不使用缓存
//    return [FDTableViewCell heightForTableView:tableView cellConfig:^(UITableViewCell *cell) {
//        FDTableViewCell *heightCell = (FDTableViewCell *)cell;
//        [heightCell configCellWithModel:model];
//    }];
    
    //使用缓存
    NSDictionary *cellInfo = @{kCellIdKey : [NSString stringWithFormat:@"%d", model.statusId],
                               kCellStatusIdKey : [NSString stringWithFormat:@"%d", model.isExpanded]};
    
    return [FDTableViewCell heightForTableView:tableView cellConfig:^(UITableViewCell *cell) {
        FDTableViewCell *heightCell = (FDTableViewCell *)cell;
        [heightCell configCellWithModel:model];
    } cache:cellInfo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
