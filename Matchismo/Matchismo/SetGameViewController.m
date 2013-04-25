//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 4/10/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "Card.h"
#import "CardMatchingGame.h"
#import "GameViewController.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property(strong, nonatomic) Card* currentFlippedCard;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;//view
@property (strong, nonatomic) CardMatchingGame  *game;//The game model
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
- (IBAction)startNewGame:(UIButton *)sender;

@property (nonatomic)NSUInteger gameMatchMode;//default value is 2.
@end

@implementation SetGameViewController

-(CardMatchingGame *)game
{
    //We get the count of card buttons from the view
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                        usingDeck:[[SetCardDeck alloc] init]
                                                     andMatchMode: 3 ];
    return _game;
}

-(void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    int i=0;
    for(UIButton * scButton in _cardButtons){
        
        Card *card = (SetCard*)[self.game cardAtIndex:i];
        [scButton setAttributedTitle:card.contents forState:UIControlStateNormal];
        i++;
    }             
    
}



@end