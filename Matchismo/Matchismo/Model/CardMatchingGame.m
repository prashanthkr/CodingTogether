//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 2/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardMatchingGame.h"

//Private Interface
@interface CardMatchingGame()
//Private property to keep track of the cards
@property (strong, nonatomic) NSMutableArray *cards;

//Override the score's visibility
@property (nonatomic) int score;

@end
@implementation CardMatchingGame

//Lazy initialization of the cards
-(NSMutableArray *)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

//Designated Initializer
-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    //Super class initializer
    self = [super init];
    //check for null
    if(self){
        //Loop through the specified count of cards
        for (int i=0; i<count; i++) {
            Card *card = [deck drawRandomCard];
            //Adding nil to an NSMutableArray will crash. So we return nil if we cannot properly initialize with the arguments passed.
            if(!card){
                self = nil;
            }else{
                self.cards[i]= card;
            }
        }
    }
    return self;
}

//CardAtIndex implementation. Checking for out of bounds.
-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count)? self.cards[index]:nil;
}

//To be able to scale the scoring
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1 //charge for flipping

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    //Get the card to flip and make sure it is playable.
    if(!card.isUnplayable){
        //If it is playable, flip the card.
        if(!card.isFaceUp){
            //See if flipping this card up creates a match
            //Loop through other cards looking for a face up, playable card.
            for(Card *otherCard in self.cards){
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    //check to see if this matches
                    int matchScore = [card match:@[otherCard]];
                    
                    //If it's a match, both cards become unplayable and we up our score
                    if(matchScore){
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                    }else{
                        //Assess a penalty if the card doesn't match
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }//end for
             //If the card is not already faceup and is playable, then charge the flip cost
            self.score -= FLIP_COST;
        }//end check on card faceUp
        card.faceUp = !card.isFaceUp;
    }
}
@end
