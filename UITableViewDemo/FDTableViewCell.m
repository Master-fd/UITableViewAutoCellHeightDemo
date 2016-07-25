//
//  FDTableViewCell.m
//  UITableViewDemo
//
//  Created by asus on 16/7/23.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "FDTableViewCell.h"
#import "FDDataModel.h"
#import "UITableViewCell+FDAutoCellHeight.h"

@interface FDTableViewCell()

@property (nonatomic, strong) FDDataModel *model;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *allDescVisibleBtn;
@property (nonatomic, strong) UIView *gapLineView;


@end

@implementation FDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        self.iconView = [[UIImageView alloc] init];
        self.iconView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(10);
        }];
        //昵称
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        // 兼容6.0
        self.nameLabel.preferredMaxLayoutWidth = w - 50 - 15*2-10;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconView.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.top.mas_equalTo(self.iconView);
        }];
        
        //正文
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.textColor = [UIColor blackColor];
        self.descLabel.font = [UIFont systemFontOfSize:13];
        self.descLabel.numberOfLines = 0;
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        
        // 兼容6.0
        self.descLabel.preferredMaxLayoutWidth = w - 50 - 15*2-10;
        [self.contentView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.iconView.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(self.descLabel.font.lineHeight*5);
        }];
        
        //全文/收起
        self.allDescVisibleBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.allDescVisibleBtn];
        self.allDescVisibleBtn.hidden = YES;
        self.allDescVisibleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.allDescVisibleBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.allDescVisibleBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.allDescVisibleBtn addTarget:self action:@selector(allVisibleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.allDescVisibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel.mas_left);
            make.top.mas_equalTo(self.descLabel.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(1, 1)); //先将约束size设置为0
        }];
        self.allDescVisibleBtn.backgroundColor = [UIColor redColor];
        
        //分割线
        UIView *gapLineView = [[UIView alloc] init];
        gapLineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:gapLineView];
        [gapLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.allDescVisibleBtn.mas_bottom).offset(5);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        self.gapLineView = gapLineView;
        
        //必须配置最后一个view
        self.lastViewInCell = self.gapLineView;
        self.lastViewOffset = 0;
        
    }
    
    return self;
}

- (void)configCellWithModel:(FDDataModel *)model {
    self.model = model;
    self.iconView.image = model.icon;
    self.nameLabel.text = model.name;
    self.descLabel.text = model.desc;
    
    
    //计算文字的size
    CGSize size = [self.descLabel.text sizeWithMaxWidth:self.descLabel.preferredMaxLayoutWidth font:self.descLabel.font];
    
    //判断收需要显示btn
    if (size.height > self.descLabel.font.lineHeight*5) {
      
        //显示按钮
        self.allDescVisibleBtn.selected = self.model.isExpanded;
        self.allDescVisibleBtn.hidden = NO;
        [self.allDescVisibleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel.mas_left);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(30, 25)); //先将约束size设置为0
        }];
        
        
        self.descLabel.backgroundColor = [UIColor orangeColor];
        //更新约束
        if (self.model.isExpanded) {
            //显示全文
            [self.descLabel sizeToFit];
            [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
                make.left.mas_equalTo(self.nameLabel);
                make.right.mas_equalTo(self.nameLabel);
            }];
        } else {
            //显示局部
            [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
                make.left.mas_equalTo(self.nameLabel);
                make.right.mas_equalTo(self.nameLabel);
                make.height.mas_equalTo(self.descLabel.font.lineHeight*5-15);
            }];
        }
    }
    
    [self.contentView setNeedsUpdateConstraints];
    [self.contentView updateConstraintsIfNeeded];
}

- (void)allVisibleBtnDidClick:(UIButton *)btn {
    
    self.model.isExpanded = !self.model.isExpanded;
    
    //更新tableviewcell
    if (self.block) {
        self.block(self.indexPath);
    }
    
}

@end
