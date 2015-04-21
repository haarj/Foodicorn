//
//  SearchViewController2.m
//  Foodicorn
//
//  Created by Justin Haar on 4/14/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "SearchViewController.h"
#import "JustinViewController.h"
#import "Yummly.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *allowedAllergies;
@property NSArray *allowedDiets;
@property NSArray *allowedCuisines;
@property NSArray *allowedCourses;
@property NSArray *allowedHolidays;
@property NSArray *allowedAllergiesStringsArray;//parallel array to add to allowed allergies
@property NSArray *allowedDietsStringsArray;
@property NSArray *allowedCuisinesStringsArray;
@property NSArray *allowedCoursesStringsArray;
@property NSArray *allowedHolidaysStringsArray;
@property NSMutableArray *stringsArray;
@property NSString *urlText;
@property NSMutableArray *cellSelectedArray;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) CGFloat lastContentOffsetY;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.urlText = @"";
    self.stringsArray = [NSMutableArray new];
    self.cellSelectedArray = [NSMutableArray new];
    self.searchBar.placeholder = @"Enter Any Food Keyword";
    self.title = @"Search Recipes";

    //TODO: Cut down number of arrays. Very difficult to manage multiple arrays in this fashion, would be better off using array of arrays. EX: NSArray *someArray = @[@[], @[], @[]];


    //TODO: Need common custom object class that will be used for all of these selections. Name? possibly SelectionObject. Properties: NSString *name, NSString *urlString, NSNumber *type.

    //TODO: create Plist to house all of this data to be pulled at run time, cut out all of this storage from this VC.


    //TODO: Make custom NSObjects that have a display name property (NSString) that will be the correct value from allowedAllergies. Second property of urlString (NSString) that will be the correct value from allowedAllergiesStringsArray. This will make one array where we were currently using two.
    self.allowedAllergies = [NSArray arrayWithObjects:@"Dairy-free", @"Egg-free", @"Gluten-free", @"Peanut-free", @"Seafood-free", @"Sesame-free", @"Soy-free", @"Sulfite-free", @"Tree nut-free", @"Wheat-free", nil];
    self.allowedAllergiesStringsArray = [NSArray arrayWithObjects:@"&allowedAllergy[]=396^Dairy-Free", @"&allowedAllergy[]=397^Egg-Free", @"&allowedAllergy[]=393^Gluten-Free", @"&allowedAllergy[]=394^Peanut-Free", @"&allowedAllergy[]=398^Seafood-Free", @"&allowedAllergy[]=399^Sesame-Free", @"&allowedAllergy[]=400^Soy-Free", @"&allowedAllergy[]=401^Sulfite-Free", @"&allowedAllergy[]=395^Tree+Nut-Free", @"&allowedAllergy[]=392^Wheat-Free", nil];

    //TODO:
    self.allowedDiets = [NSArray arrayWithObjects:@"Lacto vegetarian", @"Ovo vegetarian", @"Pescetarian", @"Vegan", @"Lacto-ovo Vegetarian", nil];
    self.allowedDietsStringsArray = [NSArray arrayWithObjects:@"&allowedDiet[]=388^Lacto+vegetarian", @"&allowedDiet[]=389^Ovo+vegetarian", @"&allowedDiet[]=390^Pescetarian", @"&allowedDiet[]=386^Vegan", @"&allowedDiet[]=387^Lacto-ovo+vegetarian", nil];

    self.allowedCuisines = [NSArray arrayWithObjects:@"American", @"Italian", @"Asian", @"Mexican", @"Southern & Soul Food", @"French", @"Southwestern", @"Barbecue", @"Indian", @"Chinese", @"Cajun & Creole", @"English", @"Mediterranean", @"Greek", @"Spanish", @"German", @"Thai", @"Moroccan", @"Irish", @"Japanese", @"Cuban", @"Hawaiin", @"Swedish", @"Hungarian", @"Portugese", nil];
    self.allowedCuisinesStringsArray = [NSArray arrayWithObjects:@"&allowedCuisine[]=cuisine^cuisine-american", @"&allowedCuisine[]=cuisine^cuisine-italian", @"&allowedCuisine[]=cuisine^cuisine-asian", @"&allowedCuisine[]=cuisine^cuisine-mexican", @"&allowedCuisine[]=cuisine^cuisine-southern", @"&allowedCuisine[]=cuisine^cuisine-french", @"&allowedCuisine[]=cuisine^cuisine-southwestern", @"&allowedCuisine[]=cuisine^cuisine-barbecue", @"&allowedCuisine[]=cuisine^cuisine-indian", @"&allowedCuisine[]=cuisine^cuisine-chinese", @"&allowedCuisine[]=cuisine^cuisine-cajun", @"&allowedCuisine[]=cuisine^cuisine-english", @"&allowedCuisine[]=cuisine^cuisine-mediterranean", @"&allowedCuisine[]=cuisine^cuisine-greek", @"&allowedCuisine[]=cuisine^cuisine-spanish", @"&allowedCuisine[]=cuisine^cuisine-german", @"&allowedCuisine[]=cuisine^cuisine-thai", @"&allowedCuisine[]=cuisine^cuisine-moroccan", @"&allowedCuisine[]=cuisine^cuisine-irish", @"&allowedCuisine[]=cuisine^cuisine-japanese", @"&allowedCuisine[]=cuisine^cuisine-cuban", @"&allowedCuisine[]=cuisine^cuisine-hawaiin", @"&allowedCuisine[]=cuisine^cuisine-swedish", @"&allowedCuisine[]=cuisine^cuisine-hungarian", @"&allowedCuisine[]=cuisine^cuisine-portugese", nil];

    self.allowedCourses = [NSArray arrayWithObjects:@"Main Dishes", @"Desserts", @"Side Dishes", @"Lunch and Snacks", @"Appetizers", @"Salads", @"Breads", @"Breakfast and Brunch", @"Soups", @"Beverages", @"Condiments and Sauces", @"Cocktails", nil];
    self.allowedCoursesStringsArray = [NSArray arrayWithObjects:@"&allowedCourse[]=course^course-Main+Dishes", @"&allowedCourse[]=course^course-Desserts", @"&allowedCourse[]=course^course-Side+Dishes", @"&allowedCourse[]=course^course-Lunch+And+Snacks", @"&allowedCourse[]=course^course-Appetizers", @"&allowedCourse[]=course^course-Salads", @"&allowedCourse[]=course^course-Breads", @"&allowedCourse[]=course^course-Breakfast+And+Brunch", @"&allowedCourse[]=course^course-Soups", @"&allowedCourse[]=course^course-Beverages", @"&allowedCourse[]=course^course-Condiments+And+Sauces", @"&allowedCourse[]=course^course-Cocktails", nil];

    self.allowedHolidays = [NSArray arrayWithObjects:@"Christmas", @"Summer", @"Thanksgiving", @"New Year", @"Super Bowl / Game+Day", @"Halloween", @"Hanukkah", @"4th of July", nil];
    self.allowedHolidaysStringsArray = [NSArray arrayWithObjects:@"&allowedHoliday[]=holiday^holiday-christmas", @"&allowedholiday[]=holiday^holiday-summer", @"&allowedHoliday[]=holiday^holiday-thanksgiving", @"&allowedHoliday[]=holiday^holiday-new+year", @"&allowedHoliday[]=holiday^holiday-super-bowl", @"&allowedHoliday[]=holiday^holiday-halloween", @"&allowedHoliday[]=holiday^holiday-hanukkah", @"&allowedHoliday[]=holiday^holiday-4th+of+july", nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.stringsArray removeAllObjects];
    self.searchBar.text = nil;
    NSLog(@"the array is %@", self.stringsArray);

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"Select Any Allergies";
    }
    else if (section == 1) {
        return @"Select Any Diets";
    }
    else if (section == 2) {
        return @"Select Any Cuisines";
    }
    else if (section == 3) {
        return @"Select Any Courses";
    }
    else {
        return @"Select Any Holidays";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];

    if ([self.cellSelectedArray containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }


    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.allowedAllergies[indexPath.row];

    } else if (indexPath.section == 1)
    {
        cell.textLabel.text = self.allowedDiets[indexPath.row];

    } else if (indexPath.section == 2)
    {
        cell.textLabel.text = self.allowedCuisines[indexPath.row];

    } else if (indexPath.section == 3)
    {
        cell.textLabel.text = self.allowedCourses[indexPath.row];

    } else
    {
        cell.textLabel.text = self.allowedHolidays[indexPath.row];
    }

    //TODO: if object should be selected/checked then show the check in the cell. else it should not show the detail disclosure.
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.allowedAllergies.count;
    } else if (section == 1)
    {
        return self.allowedDiets.count;
    }else if (section == 2)
    {
        return self.allowedCuisines.count;
    }else if (section == 3)
    {
        return self.allowedCourses.count;
    }else
    {
        return self.allowedHolidays.count;
    }
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *firstString = [searchBar.text mutableCopy];
    NSMutableString *searchString = [[firstString stringByReplacingOccurrencesOfString:@" " withString:@"+"]mutableCopy];
    NSString *string = [NSString stringWithFormat:@"&q=%@", searchString];
    NSLog(@"%@", string);

    [self.stringsArray addObject:string];
    self.searchBar.returnKeyType = UIReturnKeyNext;
    [searchBar resignFirstResponder];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Instead of checking the cell's accessoryType, check to see if the object has been selected or not, and then change it accordingly. Then reload the selected cell.

    //SomeObject *object = self.someArray[indexPath.section][indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.cellSelectedArray containsObject:indexPath]) {
        [self.cellSelectedArray removeObject:indexPath];
    } else
    {
        [self.cellSelectedArray addObject:indexPath];
    }
    [self.tableView reloadData];

    if (indexPath.section == 0 && cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSString *string = self.allowedAllergiesStringsArray[indexPath.row];
        [self.stringsArray addObject:string];


    } else if (indexPath.section == 1 && cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSString *string = self.allowedDietsStringsArray[indexPath.row];
        [self.stringsArray addObject:string];


    } else if (indexPath.section == 2 && cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSString *string = self.allowedCuisinesStringsArray[indexPath.row];
        [self.stringsArray addObject:string];


    } else if (indexPath.section == 3 && cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSString *string = self.allowedCoursesStringsArray[indexPath.row];
        [self.stringsArray addObject:string];


    } else if (indexPath.section == 4 && cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSString *string = self.allowedHolidaysStringsArray[indexPath.row];
        [self.stringsArray addObject:string];

    } else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.stringsArray removeLastObject];
    }

    [self.tableView reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    JustinViewController *justinVC = segue.destinationViewController;
    self.urlText = [[self.stringsArray valueForKey:@"description"] componentsJoinedByString:@""];
    justinVC.urlText = self.urlText;
    //    NSLog(@"The Url Text is %@", self.urlText);
    
}


//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//
//{
//
//    self.lastContentOffsetY = scrollView.contentOffset.y;
//
//}





//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//
//{
//
//    if (self.lastContentOffsetY > scrollView.contentOffset.y) {
//
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//    } else if (self.lastContentOffsetY < scrollView.contentOffset.y) {
//
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        
//    }
//    
//}

@end
