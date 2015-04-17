//
//  ViewController.m
//  Foodicorn
//
//  Created by tim on 4/13/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "JustinViewController.h"
#import "Yummly.h"
#import "DetailViewController.h"

@interface JustinViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic)  NSArray *recipes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Yummly *yummly;


@end

@implementation JustinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Yummly recipeArrayFromDictionaryArray:self.urlText completeHandler:^(NSArray *array) {
        self.recipes = array;

        NSLog(@"%@", self.recipes);
    }];


    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];


}

-(void)setRecipes:(NSArray *)recipes
{
    _recipes = recipes;
    [self.tableView reloadData];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipe"];
    self.yummly = [self.recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = self.yummly.recipeName;
    cell.detailTextLabel.text = self.yummly.sourceId;
    if (indexPath.row %2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }

    NSString *thumnailImage = self.yummly.thumbnailString;
    NSURL *url = [NSURL URLWithString:thumnailImage];
    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
    cell.imageView.image = [UIImage imageWithData:data];
    cell.imageView.frame = CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50, 50, 50);
    cell.imageView.layer.borderColor = [UIColor colorWithRed:87/255.0 green:215/255.0 blue:255/255.0 alpha:2].CGColor;
    cell.imageView.layer.borderWidth = 2.0f;
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
    cell.imageView.clipsToBounds = YES;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipes.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    DetailViewController *detailVC= [storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    [self.navigationController pushViewController:detailVC animated:YES];
    self.yummly = [self.recipes objectAtIndex:indexPath.row];
    detailVC.recipeID = self.yummly.recipeId;
}


@end

