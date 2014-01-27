//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViews;
@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
