//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) NSString *lastConsideration;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            NSMutableString *consideration = [NSMutableString stringWithCapacity: 0];
            [consideration appendFormat:@"%@ ", card.contents];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                    [consideration appendFormat:@"%@ ", otherCard.contents];
                }
            }
            
            if ( (!self.isThreeCardsMode && [otherCards count] == 1) ||
                 (self.isThreeCardsMode  && [otherCards count] == 2) ) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *othercard in otherCards) {
                        othercard.matched = YES;
                    }
                    card.matched = YES;
                    self.lastConsideration = [NSString stringWithFormat:@"Matched  %@", consideration];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *othercard in otherCards) {
                        othercard.chosen = NO;
                    }
                    self.lastConsideration = [NSString stringWithFormat:@"%@ does not match", consideration];
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
}


@end
