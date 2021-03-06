//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/21.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)updateUI
{
    [super updateUI];
    
    for (PlayingCardView *cardView in self.cardViews) {
        int cardViewIndex = [self.cardViews indexOfObject:cardView];
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:cardViewIndex];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
    }
}

- (CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    game.threeCardsMode = NO;
    return game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
