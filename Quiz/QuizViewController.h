//
//  QuizViewController.h
//  Quiz
//
//  Created by patlan on 2014-02-24.
//  Copyright (c) 2014 LBi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizViewController : UIViewController {
    IBOutlet UIButton *answerOne;
    IBOutlet UIButton *answerTwo;
    IBOutlet UIButton *answerThree;
    IBOutlet UIButton *answerFour;
    IBOutlet UILabel *theQuestion;
    IBOutlet UILabel *theScore;
    IBOutlet UILabel *theLives;
	NSInteger myScore;
	NSInteger myLives;
	NSInteger questionNumber;
	NSInteger rightAnswer;
	NSInteger time;
	NSArray *theQuiz;
	NSTimer *timer;
	BOOL questionLive;
	BOOL restartGame;
}

@property (retain, nonatomic) UILabel	*theQuestion;
@property (retain, nonatomic) UILabel	*theScore;
@property (retain, nonatomic) UILabel	*theLives;
@property (retain, nonatomic) UIButton	*answerOne;
@property (retain, nonatomic) UIButton	*answerTwo;
@property (retain, nonatomic) UIButton	*answerThree;
@property (retain, nonatomic) UIButton	*answerFour;
@property (retain, nonatomic) NSArray *theQuiz;
@property (retain, nonatomic) NSTimer *timer;

- (IBAction)buttonOne:(id)sender;
- (IBAction)buttonTwo:(id)sender;
- (IBAction)buttonThree:(id)sender;
- (IBAction)buttonFour:(id)sender;

@end
