//
//  WQCollectionViewCell.m
//  CombinationPickerContoller
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "WQCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation WQCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHightlightBackground:(BOOL)isSelected withAimate:(BOOL)animate
{
    [self.imageView.layer removeAllAnimations];
    [self.bgView.layer removeAllAnimations];
    [self.layer removeAllAnimations];
    
    if (isSelected == YES) {
        [self showSelectedIV];
        //[self setHightlightBackground];
        
    } else {
        [self hideSelectedIV];
        //[self setNormalBackground:animate];
        
    }
}
-(void)showSelectedIV {
    self.selBtn.selected = YES;
    self.bgView.hidden = NO;
}
-(void)hideSelectedIV {
    self.selBtn.selected = NO;
    self.bgView.hidden = YES;
}
- (void)setNormalBackground:(BOOL)animate
{
    
    if (animate) {
        
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x+1, self.imageView.frame.origin.y+1, self.imageView.frame.size.width-2, self.imageView.frame.size.height-2)];
                             
                             [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x+1, self.bgView.frame.origin.y+1, self.bgView.frame.size.width-2, self.bgView.frame.size.height-2)];
                             
                         }
                         completion:^(BOOL finished){
                             
                             [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x-1, self.imageView.frame.origin.y-1, self.imageView.frame.size.width+2, self.imageView.frame.size.height+2)];
                             
                             [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x-1, self.bgView.frame.origin.y-1, self.bgView.frame.size.width+2, self.bgView.frame.size.height+2)];
                             
                         }
         ];

    }
    
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    
}

- (void)setHightlightBackground
{

    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = [UIColor greenColor].CGColor;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x+1, self.imageView.frame.origin.y+1, self.imageView.frame.size.width-2, self.imageView.frame.size.height-2)];
                         
                         [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x+1, self.bgView.frame.origin.y+1, self.bgView.frame.size.width-2, self.bgView.frame.size.height-2)];

                     }
                     completion:^(BOOL finished){
                         
                         [self.imageView setFrame:CGRectMake(self.imageView.frame.origin.x-1, self.imageView.frame.origin.y-1, self.imageView.frame.size.width+2, self.imageView.frame.size.height+2)];
                         
                         [self.bgView setFrame:CGRectMake(self.bgView.frame.origin.x-1, self.bgView.frame.origin.y-1, self.bgView.frame.size.width+2, self.bgView.frame.size.height+2)];

                     }
     ];
    
    
}

@end
