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

//Also override the visibility of lastFlipPoints and previousFlippedCard
@property (nonatomic) int lastFlipPoints;
//@property(strong, nonatomic) Card* previousFlippedCard;
@property(strong, nonatomic) Card* currentFlippedCard;
//@property (strong, nonatomic) NSMutableArray *flippedCards;
//@property (strong, nonatomic) NSMutableArray *matchingFlippedCards;
//@property (strong, nonatomic) NSMutableArray *unMatchingFlippedCards;
@property(nonatomic) NSUInteger gameMode;
//Private property to keep track of the last flipped cards
@property (strong, nonatomic) NSMutableArray *allFlippedCards;
@property (nonatomic) NSString* resultString;

@end
@implementation CardMatchingGame

//Lazy initialization of the cards
-(NSMutableArray *)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

//Lazy initialization of the flipped cards
-(NSMutableArray *)allFlippedCards
{
    if(!_allFlippedCards)_allFlippedCards = [[NSMutableArray alloc] init];
    return _allFlippedCards;
}

//Lazy initialization of the flipped cards
//-(NSMutableArray *)flippedCards
//{
//    if(!_flippedCards)_flippedCards = [[NSMutableArray alloc] init];
//    return _flippedCards;
//}

//Designated Initializer
-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andMatchMode:(NSUInteger)mode
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
        }//end for
        self.gameMode = mode;
    }//end check on self
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
    
    //Reset for each flip
    self.resultString = @"";
//    NSLog(@"self.previousFlippedCard before for----@%@",self.previousFlippedCard.contents);
//    NSLog(@"card before for----@%@",card.contents);
//    NSLog(@"flipped cards---%@",self.allFlippedCards);
//    NSLog(@"gamematch mode---%d",self.gameMode);
//    self.currentFlippedCard = card;
    
    NSMutableArray* cardsToRemove = [[NSMutableArray alloc] init];
    
    //Get the card to flip and make sure it is playable.
    if(!card.isUnplayable){
        //If it is playable, flip the card.
        if(!card.isFaceUp){
            
            int matchScore = 0;
            self.lastFlipPoints = 0;
            NSRange subArrayRange;
            //For 2 gameMode, we look at last 1 card, for 3 gameMode, look at last 2 cards.
            subArrayRange.location = self.allFlippedCards.count > self.gameMode ? (self.allFlippedCards.count-self.gameMode+1) : 0;//start index.
            subArrayRange.length = self.gameMode-1;//number of elements
            //matchScore = [card match:[self.allFlippedCards subarrayWithRange:subArrayRange]];
//            NSLog(@"locn---%d", subArrayRange.location);
//            NSLog(@"length---%d", subArrayRange.length);
            
            for(int i = subArrayRange.location; i<self.allFlippedCards.count; i++){
//                NSLog(@"index of object---%d", i);
                Card* otherCard = [self.allFlippedCards objectAtIndex:i];
                matchScore = [card match:@[otherCard]];
//                NSLog(@"Matchscore---%d", matchScore);
                if(matchScore){
                    card.unplayable = YES;
                    otherCard.unplayable = YES;
                    self.score += matchScore * MATCH_BONUS;
                    [cardsToRemove addObject:otherCard];
                    //Update the lastFlip Count
                    self.lastFlipPoints += matchScore * MATCH_BONUS;
                    
                }else{
                    //If mismatch, then the penalty should be applied, and also the array updated
                    self.lastFlipPoints -= MISMATCH_PENALTY;
                    self.score -= MISMATCH_PENALTY;
                }
            }//end for on allFlippedCards
            
            NSMutableArray* cardsConsidered = [[NSMutableArray alloc] init];
            if(self.allFlippedCards.count >1){
                [cardsConsidered addObjectsFromArray:[self.allFlippedCards subarrayWithRange:subArrayRange]];
                [cardsConsidered addObject:card];//add the current card too.
            }
            
             //Delete the matched cards from the flipped cards array
            [self.allFlippedCards removeObjectsInArray:cardsToRemove];
            
            //After the current card matches any one card,dump all the elements in the flippedcards array
            if(card.unplayable){
                [self.allFlippedCards removeAllObjects];
                [cardsToRemove addObject:card];
            }else{
                //add the card to the list of flipped cards if it isn't matched
                [self.allFlippedCards addObject:card];
            }
            
            //Construct the resultString
            if(cardsToRemove.count >0){
                //There is at least one match
                NSString* matches = @"";
                for(Card * ctr in cardsToRemove){
                    NSLog(@"%@",ctr.contents);
                    matches = [[matches stringByAppendingString:ctr.contents] stringByAppendingString:@","];
                }
//                NSLog(@"")
                self.resultString = [NSString stringWithFormat: @"%@ %d %@",[[[self.resultString stringByAppendingString: @"Matched "] stringByAppendingString:matches] stringByAppendingString:@" for "], self.lastFlipPoints, @" points" ];
                
            }else{
                //There's no match
                NSString* nonMatches = @"";
                for(Card * nmc in cardsConsidered){
                    nonMatches = [[nonMatches stringByAppendingString:nmc.contents] stringByAppendingString:@","];
                }
                self.resultString = [NSString stringWithFormat: @"%@ %d",[[[self.resultString  stringByAppendingString:nonMatches] stringByAppendingString:@" for "]stringByAppendingString: @"don't match "], self.lastFlipPoints ] ;//stringbyAppendingString: @" penalty"];
            }
            //If the card is not already faceup and is playable, then charge the flip cost
            self.score -= FLIP_COST;
            
//            //Now add the card to the list of flipped cards if it isn't matched
//            if(!card.isUnplayable)
//                [self.allFlippedCards addObject:card];
            //NSLog(@"flipped cards after adding---%@",self.allFlippedCards);
        }//end check on card faceUp

        card.faceUp = !card.isFaceUp;
    
    }//end check on card is playable
    
        
}//end flipCardAtIndex
@end
