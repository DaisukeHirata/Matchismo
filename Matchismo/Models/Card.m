//
//  Card.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
    