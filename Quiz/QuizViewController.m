//
//  QuizViewController.m
//  Quiz
//
//  Created by patlan on 2014-02-24.
//  Copyright (c) 2014 LBi. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController
@synthesize theQuestion, theScore, theLives, theQuiz;
@synthesize answerOne, answerTwo, answerThree, answerFour;
@synthesize timer, quizDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	//[self buttonMoveOut];
	questionLive = NO;
	restartGame = NO;
	theQuestion.textAlignment =  NSTextAlignmentLeft;
	theQuestion.textColor = [UIColor blackColor];
	theQuestion.text = @"Welcome to Stef's Quick Science Quiz (changeme)!";
	theScore.text = @"Score:0";
	theLives.text = @"";
	questionNumber = 0;
	myScore = 0;
	myLives = 0;
	//[buttonStart setTitle:@"Start Quiz" forstate:UIControlStateNormal];
	//[answerOne setTitle:@"Let's Play!" forState:UIControlStateNormal];
    
	[answerOne setHidden:YES];
	[answerTwo setHidden:YES];
	[answerThree setHidden:YES];
	[answerFour setHidden:YES];
    
	[self loadQuiz];
}

-(void)loadQuiz
{
	// This is our forced-loaded array of quiz questions.
	// FORMAT IS IMPORTANT!!!!
	// 1: Question, 2 3 4 5: Answers 1-4 respectively, 6: The right answer
	// THIS IS A TERRIBLE WAY TO DO THIS. I will figure out how to do nested arrays to make this better.
	NSArray *quizArray = [[NSArray alloc] initWithObjects:
						  @"Which rays are most damaging to cells?",@"Infrared",@"Ultraviolet",@"X-rays",@"Radio Waves",@"2",
						  @"Wavelengs that are shorter than visible light are:", @"Dangerous and can be harmful", @"Harmless", @"Have a low frequency", @"Can be seen with our eyes", @"4",
						  @"What is the difference between a Theory and a Law?", @"A theory can be proven", @"A law can be proven", @"A law is based on ideas", @"Theories are based on opinions", @"2",
						  @"What is a Hypothesis?", @"A guess", @"A law", @"What you change in an experiment", @"A prediction of the outcome", @"4",
						  @"Convert 1500 milliliters to meters:", @"1500000", @"150", @"1.5", @".015", @"3",
						  @"What would be the appropriate measure to record the length of a car?", @"Centimeters", @"Kilometers", @"Millimeters", @"Meters", @"4",
						  @"Magnitudes on the Richter Scale increase by what increment?", @"2 times", @"5 times", @"50%", @"10 times", @"4",
						  nil];
	self.theQuiz = quizArray;
	quizArray=nil;
    
    [self askQuestion];
}

-(void)askQuestion
{
	// Unhide all the answer buttons.
    // [self buttonMoveIn];
	// [self moveButtonsIn];
	// [buttonStart setHidden:YES];
    
	[answerOne setHidden:NO];
	[answerTwo setHidden:NO];
	[answerThree setHidden:NO];
	[answerFour setHidden:NO];
    
	
	// Set the game to a "live" question (for timer purposes)
	questionLive = YES;
	
	// Go to the next question
	questionNumber = questionNumber + 1;
	
	//[self buttonBounce];
	
	// THIS IS REALLY TERRIBLE CODE!!!
	// We get the question from the questionNumber * the row that we look up in the array.
	// This is absolutely horrible, just a placeholder until the right way.
	// I cannot even begin to describe how wrong this solution is.
	NSInteger row = 0;
	if(questionNumber == 1)
	{
		row = questionNumber - 1;
	}
	else
	{
		row = ((questionNumber - 1) * 6);
	}
	
	// Set the question string, and set the buttons the the answers
	NSString *selected = [theQuiz objectAtIndex:row];
	NSString *activeQuestion = [[NSString alloc] initWithFormat:@"Question: %@", selected];
	[answerOne setTitle:[theQuiz objectAtIndex:row+1] forState:UIControlStateNormal];
	[answerTwo setTitle:[theQuiz objectAtIndex:row+2] forState:UIControlStateNormal];
	[answerThree setTitle:[theQuiz objectAtIndex:row+3] forState:UIControlStateNormal];
	[answerFour setTitle:[theQuiz objectAtIndex:row+4] forState:UIControlStateNormal];
	rightAnswer = [[theQuiz objectAtIndex:row+5] intValue];
	
	// Set theQuestion label to the active question
	theQuestion.textAlignment =  NSTextAlignmentLeft;
	theQuestion.textColor = [UIColor blackColor];
	theQuestion.text = activeQuestion;
	
	selected=nil;
	activeQuestion=nil;
}

-(void)countDown
{
    time = time - 1;
	theLives.text = [NSString stringWithFormat:@"Next question in...%i!", time];
        
	if(time == 0)
	{
		[timer invalidate];
		theLives.text = @"";
		[self askQuestion];
	}
}


// Check for the answer (this is not written right, but it runs)
-(void)checkAnswer:(int)theAnswerValue
{
	if(rightAnswer == theAnswerValue)
	{
		theQuestion.textAlignment = NSTextAlignmentCenter;
		theQuestion.textColor = [UIColor greenColor];
		theQuestion.text = @"Correct!";
		myScore = myScore + 50;
        
        
        if ([self.quizDelegate respondsToSelector:@selector(userDidPassQuiz:)])
        {
            [self.quizDelegate userDidPassQuiz:YES];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
	}
	else
	{
		theQuestion.textAlignment = NSTextAlignmentCenter;
		theQuestion.textColor = [UIColor redColor];
		theQuestion.text = @"FAIL!";
		[self updateScore];
	}
	//
}

-(void)updateScore
{
	// If the score is being updated, the question is not live
	questionLive = NO;
	
	[timer invalidate];
	
	
	// Hide the answers from the previous question
	//[self moveButtonsOut];
	[answerOne setHidden:YES];
	[answerTwo setHidden:YES];
	[answerThree setHidden:YES];
	[answerFour setHidden:YES];
	NSString *scoreUpdate = [[NSString alloc] initWithFormat:@"Score: %d", myScore];
	theScore.text = scoreUpdate;
	scoreUpdate=nil;
	
	// END THE GAME.
    // Give a short rest between questions
    time = 3.0;
        
    // Initialize the timer
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}


- (IBAction)buttonOne:(id)sender {
    
	if(questionNumber == 0){
        
		// This means that we are at the startup-state
		// We need to make the other buttons visible, and start the game.
		[answerTwo setHidden:NO];
		[answerThree setHidden:NO];
		[answerFour setHidden:NO];
		[self askQuestion];
	}
	else
	{
		NSInteger theAnswerValue = 1;
		[self checkAnswer:(int)theAnswerValue];
		if(restartGame==YES)
		{
			// Create a restart game function.
		}
	}
}

- (IBAction)buttonTwo:(id)sender {
	NSInteger theAnswerValue = 2;
	[self checkAnswer:(int)theAnswerValue];
}

- (IBAction)buttonThree:(id)sender {
	NSInteger theAnswerValue = 3;
	[self checkAnswer:(int)theAnswerValue];
}

- (IBAction)buttonFour:(id)sender {
	NSInteger theAnswerValue = 4;
	[self checkAnswer:(int)theAnswerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
