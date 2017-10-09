//
//  SLKMessageCell3.h
//  SLKMessageDemo
//
//  Created by saix on 2017/9/26.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLKMessageParser/SLKMessageParser.h>

@interface SLKMessageCell : UITableViewCell
@property (nonatomic, strong) SLKMessageComponent* component;
@property (nonatomic, strong) SLKMessageView* componentView;
@property (nonatomic, strong) UIButton* avatar;
@property (strong, nonatomic) UILabel *nameDateLabel;

@property (nonatomic) BOOL isAsync;


+(CGFloat)containerWidth;
+(CGFloat)heightOffset;

@end
