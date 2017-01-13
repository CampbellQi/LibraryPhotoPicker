//
//  WQCollectionViewCell.h
//  testPhotoLib
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

- (void)setHightlightBackground:(BOOL)isSelected withAimate:(BOOL)animate;
- (void)setNormalBackground:(BOOL)animate;
- (void)setHightlightBackground;

-(void)showSelectedIV;
-(void)hideSelectedIV;
@end
