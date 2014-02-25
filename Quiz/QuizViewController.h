//
//  QuizViewController.h
//  Quiz
//
//  Created by patlan on 2014-02-24.
//  Copyright (c) 2014 LBi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuizDelegate <NSObject>

-(void)userDidPassQuiz:(BOOL)flag;


@end

@interface QuizViewController : UIViewController {
    id<QuizDelegate> quizDelegate;
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

@property (strong, nonatomic) id<QuizDelegate> quizDelegate;
@property (retain, nonatomic) UILabel	*theQuestion;
@property (retain, nonatomic) UILabel	*theScore;
@property (retain, nonatomic) UILabel	*theLives;
@property (retain, nonatomic) UIButton	*answerOne;
@property (retain, nonatomic) UIButton	*answerTwo;
@property (retain, nonatomic) UIButton	*answerThree;
@property (retain, nonatomic) UIButton	*answerFour;
@property (retain, nonatomic) NSArray *theQuiz;
@property (retain, nonatomic) NSTimer *timer;

-(void)checkAnswer:(int)theAnswerValue;

- (IBAction)buttonOne:(id)sender;
- (IBAction)buttonTwo:(id)sender;
- (IBAction)buttonThree:(id)sender;
- (IBAction)buttonFour:(id)sender;

@end
