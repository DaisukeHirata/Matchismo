//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/13.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSArray *setCardViews;
@property (weak, nonatomic) IBOutlet UILabel *lastConsiderationLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation SetGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (SetCardView *card in self.setCardViews) {
        UITapGestureRecognizer *recognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapSetCardView:)];
        [card addGestureRecognizer:recognizer];
    }
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.setCardViews count]
                                                          usingDeck:[self createDeck]];
        _game.threeCardsMode = YES;
    }
    return _game;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)tapSetCardView:(UITapGestureRecognizer *)sender {
    int chosenButtonIndex = [self.setCardViews indexOfObject:sender.view];
    NSLog(@"%d tapped", chosenButtonIndex);
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI
{
    
    for (SetCardView *cardView in self.setCardViews) {
        int cardViewIndex = [self.setCardViews indexOfObject:cardView];
        SetCard *card = (SetCard *)[self.game cardAtIndex:cardViewIndex];
        cardView.number = card.number;
        cardView.symbol = card.symbol;
        cardView.shading = card.shading;
        cardView.color = card.color;
        cardView.faceUp = card.isChosen;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastConsiderationLabel.text = self.game.lastConsideration;
    self.lastConsiderationLabel.alpha = 1;
}


@end
