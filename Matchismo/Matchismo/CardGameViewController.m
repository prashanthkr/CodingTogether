//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;//view
@property (strong, nonatomic) CardMatchingGame  *game;//The game model
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchedElementsLabel;
@end

@implementation CardGameViewController


//Lazy instantiation
-(CardMatchingGame *)game
{
    //We are getting the count of card buttons from the view
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                        usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

-(void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;

}

//Updates the UI for every flip
-(void)updateUI
{
    //Just cycle through the card buttons getting the associated card from the CardMatchingGame
    for(UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        //Set the title for selectedstate. if contents don't change, this will do nothing
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        
        //If the card is both selected and disabled, then set the title to teh card's contents
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        //Card is selected only if it is face up.
        cardButton.Selected = card.isFaceUp;//IS OBJECTIVE C Case sensitive????
        
        //Make the card untappable if it is unplayable
        cardButton.enabled = !card.isUnplayable;
        
        //Make a disabled button semi-transparent using opaqueness property
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0; //1 fully opaque, 0.0 fully transparent
        
        //Update the score
        self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d", self.game.score];
        
        NSLog(@"matched---%@",[self.game.matchingFlippedCards componentsJoinedByString:@"-"]);
        NSLog(@"unmatched---%@",[self.game.unMatchingFlippedCards componentsJoinedByString:@"-"]);
        //Update the matched elements and last flip count
        self.matchedElementsLabel.text = [NSString stringWithFormat:@"Flipped %@\rMatched %@ \rUnmatched %@  Points:%d",card.contents, [self.game.matchingFlippedCards componentsJoinedByString:@"-"], [self.game.unMatchingFlippedCards componentsJoinedByString:@"-"], self.game.lastFlipPoints];
        //componentsJoinedByString:@"-"
    }//end for
}


-(void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    //Flipping is now done by the CardMatchingGame
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    self.flipCount++;
    
    //Update the UI whenever the card gets flipped
    [self updateUI];
}



@end
