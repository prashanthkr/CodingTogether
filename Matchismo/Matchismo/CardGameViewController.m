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

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;

@end

//new comment test

@implementation CardGameViewController

-(void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

//lazy initialize deck by overriding the getter
-(PlayingCardDeck *)deck{
    if(_deck == nil){
        _deck = [[PlayingCardDeck alloc] init];
       /* for(int i=0; i<53;i++){
            Card *card = [[Card alloc] init];
            [_deck addCard:card atTop:YES];
        }
        */
    }
    return _deck;
}
- (IBAction)flipCard:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    
    NSString *desc = [[self.deck drawRandomCard] description];
    //NSLog(@"cards size---%d",[[self.deck cards] length]);
    NSLog(@"cards---%@",[self.deck drawRandomCard]);
    NSLog(@"card desc---%@",desc);
    [sender setTitle: desc forState:UIControlStateSelected];
    self.flipCount++;
}



@end
