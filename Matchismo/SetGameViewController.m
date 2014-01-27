//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/13.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardView.h"
#import "SetCard.h"
#import "SetCardDeck.h"

@interface SetGameViewController ()
@end

@implementation SetGameViewController

- (void)updateUI
{
    [super updateUI];
    
    for (SetCardView *cardView in self.cardViews) {
        int cardViewIndex = [self.cardViews indexOfObject:cardView];
        SetCard *card = (SetCard *)[self.game cardAtIndex:cardViewIndex];
        cardView.number = card.number;
        cardView.symbol = card.symbol;
        cardView.shading = card.shading;
        cardView.color = card.color;
    }
}

- (CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    game.threeCardsMode = YES;
    return game;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

@end
