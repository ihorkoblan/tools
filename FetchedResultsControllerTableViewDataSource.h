//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;

typedef void (^FetchedResultsControllerTableViewDataSourceConfigureBlock)(id cell, id item);

@protocol FetchedResultsControllerTableViewDataSourceDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell withObject:(id)object;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)fetchedResultsControllerTableViewDataSourceDidDeleteObject:(id)object;

@end



@interface FetchedResultsControllerTableViewDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, weak) id<FetchedResultsControllerTableViewDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString* reuseIdentifier;
@property (nonatomic, copy) FetchedResultsControllerTableViewDataSourceConfigureBlock configureBlock;
@property (assign, nonatomic) BOOL editingEnabled;
@property (nonatomic) BOOL paused;

- (id)initWithTableView:(UITableView*)tableView;

- (id)initWithTableView:(UITableView*)tableView
            objectClass:(Class)objectClass
                context:(NSManagedObjectContext *)context
              predicate:(NSPredicate *)predicate
                sorting:(NSString *)sorting
              ascending:(BOOL)ascending;

- (void)setPredicate:(NSPredicate *)predicate;

- (id)selectedItem;

@end