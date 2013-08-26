//
//  InitialSearchTableViewController.m
//  TestFHIRPatientApp
//
//  Created by Adam Sippel on 2013-07-15.
//  Copyright (c) 2013 Adam Sippel. All rights reserved.
//

#import "InitialSearchTableViewController.h"
#import "FHIR.h"
#import "PatientInfoViewController.h"
#import "AddEditPatientViewController.h"
#import "PatientSearchTableViewCell.h"
#import "AllPatientItemReturnMethods.h"
#import "FHIRSearchAndReturnResources.h"

#define URL_STRING_TEST @"http://hl7connect.healthintersections.com.au/svc/fhir/patient/@1/history/@1?_format=json"//@"http://hl7.org/implement/standards/fhir/patient-example-a.json"

@implementation InitialSearchTableViewController

- (void)exampleGrab //delete after servers are updated
{
    JSONToDict *jsonDict = [[JSONToDict alloc] init];
    
    //check if file exists at path
    NSObject *patientJSON = [[NSObject alloc] init];
    self.patientArray = [[NSMutableArray alloc] init];
    NSURL *tempUrl = [[NSURL alloc] initWithString:URL_STRING_TEST];
    NSString *jsonString = [NSString stringWithContentsOfURL:tempUrl encoding:NSASCIIStringEncoding error:nil];
    if (jsonString)
    {
        NSLog(@"%@",URL_STRING_TEST);
        patientJSON = [jsonDict convertJsonToDictionary:URL_STRING_TEST];
        [self.patientArray addObject:patientJSON];
    }
    
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchBarMain.delegate = self;
    self.navigationController.title = @"Patient Search";
    [[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
    [[self searchBarMain] setTintColor:[UIColor blackColor]];
    self.currentServerAddress = @"http://hl7connect.healthintersections.com.au/svc/fhir/";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar delegate code

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    //[self exampleGrab];
    [self grabFromServerUsingName:searchBar.text];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.patientArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"searchMainCells";
    
    PatientSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PatientSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *cellTitle = [AllPatientItemReturnMethods returnPatientsName:[self.patientArray objectAtIndex:indexPath.row]];
    UIImage *cellDefaultImage = [AllPatientItemReturnMethods returnPatientDefaultImage:[self.patientArray objectAtIndex:indexPath.row]];
    NSString *cellDOB = [AllPatientItemReturnMethods returnPatientsDOB:[self.patientArray objectAtIndex:indexPath.row]];
    UIImage *cellGenderImage = [self returnPatientGenderImage:[self.patientArray objectAtIndex:indexPath.row]];
    FHIRPatient *tempPatient = [self.patientArray objectAtIndex:indexPath.row];
    if ([[tempPatient address] count] != 0)
    {
        FHIRString *cellLocation = [[[[tempPatient address] objectAtIndex:0] line] lastObject];
        cell.patientLocationText.text = [cellLocation value];
    }
    else
    {
        cell.patientLocationText.text = @"N/A";
    }
    
    cell.patientNameLabel.text = cellTitle;
    cell.patientProfileImageView.image = cellDefaultImage;
    cell.patientDOBText.text = cellDOB;
    cell.patientGenderImageView.image = cellGenderImage;
    
    //alternate cell colors
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor orangeColor];
    }
    
    return cell;
}

- (UIImage *)returnPatientGenderImage:(FHIRPatient *)patientToCheckImage
{
    NSString *genderTypeString = [[NSString alloc] init];
    FHIRCoding *codeToCheck = [patientToCheckImage.gender.coding objectAtIndex:0];
    genderTypeString = codeToCheck.code.value;
    
    UIImage *imageForProfile = [[UIImage alloc] init];
    
    if ([patientToCheckImage.gender class] == [NSNull class]) //patient is human male
    {
        imageForProfile = [UIImage imageNamed:@""];
    }
    else if ([genderTypeString isEqualToString:@"M"])
    {
        imageForProfile = [UIImage imageNamed:@"icon_male.png"];
    }
    else
    {
        imageForProfile = [UIImage imageNamed:@"icon_female.png"];
    }
    
    return imageForProfile;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Search controllers
- (void)grabFromServerUsingName:(NSString *)searchString
{
    NSArray *namesSeperated = [[NSArray alloc] initWithArray:[searchString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    NSMutableArray *givenNames = [[NSMutableArray alloc] init];
    NSMutableArray *familyNames = [[NSMutableArray alloc] init];
    Boolean *singleName = false;
    
    if ([searchString rangeOfString:@","].location != NSNotFound && [namesSeperated count] == 2) //if using "lastName, firstName" format
    {
        NSMutableArray *nameArrayWithoutCommas = [[NSMutableArray alloc] init];
        for (int i = 0; i < [namesSeperated count]; i++)
        {
            [nameArrayWithoutCommas addObject:[[namesSeperated objectAtIndex:i] stringByReplacingOccurrencesOfString:@"," withString:@""]];
        }
        [givenNames addObject:[nameArrayWithoutCommas objectAtIndex:1]];
        [familyNames addObject:[nameArrayWithoutCommas objectAtIndex:0]];
    }
    else if ([namesSeperated count] > 1) //check if multiple search names "Fistname middleName lastname"
    {
        for (int i = 0; i < [namesSeperated count] - 1; i++)
        {
            [givenNames addObject:[namesSeperated objectAtIndex:i]];
        }
        [familyNames addObject:[namesSeperated objectAtIndex:[namesSeperated count]-1]];
    }
    else //single search word is provided "name"
    {
        NSLog(@"SINGLE");
        singleName = true;
        [familyNames addObject:searchString];
        [givenNames addObject:searchString];
    }
    
    //search for name
    if (singleName)
    {
        self.patientArray = [[NSMutableArray alloc] init];
        
        //try family name first
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:[NSMutableString stringWithFormat:@"%@patient?_&family=%@&_format=json", self.currentServerAddress, [familyNames objectAtIndex:0]]];
        self.patientArray = [[NSMutableArray alloc] initWithArray:[FHIRSearchAndReturnResources returnArrayOfPatientsSearched:urlString]]; //grabs family names
        
        //try given names
        urlString = [[NSMutableString alloc] initWithString:[NSMutableString stringWithFormat:@"%@patient?_&given=%@&_format=json", self.currentServerAddress, [givenNames objectAtIndex:0]]];
        [self.patientArray addObjectsFromArray:[FHIRSearchAndReturnResources returnArrayOfPatientsSearched:urlString]]; //grabs given names

        [self.tableView reloadData];
         
    }
    else //multiple names
    {
        self.patientArray = [[NSMutableArray alloc] init];
        
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:[NSMutableString stringWithFormat:@"%@patient?_&family=%@&given=%@&_format=json", self.currentServerAddress, [familyNames objectAtIndex:0], [givenNames objectAtIndex:0]]];
        
        [self.patientArray addObjectsFromArray:[FHIRSearchAndReturnResources returnArrayOfPatientsSearched:urlString]];//grabs all searched names
        
        [self.tableView reloadData];
        NSLog(@"%@",self.patientArray);
        
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"patientInfoSegue"])
    {
        PatientInfoViewController *target = (PatientInfoViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        target.patient = [self.patientArray objectAtIndex:indexPath.row];
        target.currentServer = self.currentServerAddress;
    }
    else if ([segue.identifier isEqualToString:@"addPatientSegue"])
    {
        AddEditPatientViewController *target = (AddEditPatientViewController *)segue.destinationViewController;
        target.title = @"Add Patient";
        target.currentServer = self.currentServerAddress;
    }
    else if ([segue.identifier isEqualToString:@"popoverSegue"])
    {
        self.serverPopover = [(UIStoryboardPopoverSegue*)segue popoverController];
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setServerURLText:self.currentServerAddress];
    }
    else
    {
        NSIndexPath *indexPath = nil;
        if ([sender isKindOfClass:[NSIndexPath class]])
        {
            indexPath = (NSIndexPath *)sender;
        }
        else if ([sender isKindOfClass:[UITableViewCell class]])
        {
            indexPath = [self.tableView indexPathForCell:sender];
        }
        else if (!sender || (sender == self.tableView))
        {
            indexPath = [self.tableView indexPathForSelectedRow];
        }
    }
}

#pragma mark -popup protocol functions
- (void) returnFromPopup:(NSString *)popupData
{
    self.currentServerAddress = popupData;
    [self.serverPopover dismissPopoverAnimated:YES];
}

@end
