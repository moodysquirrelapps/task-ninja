# Purpose
An iOS mobile application for managing todo lists and providing completion analytics.

# Implementation

<img src="/Screenshots/system-design.png" style="width: 100%">

Please refer to the system diagram above.

For User Interface:
1. Launch Screen: A launch screen with an image of the application icon, title and author.
2. Home Screen: A table view controller where the user can add categories, proceed to Tasks Screen or proceed to Analytics Screen.
3. Tasks Screen: A table view controller where the user can add tasks, mark a task as active or done, search partially for a task or return to Home Screen.
4. Analytics Screen: A SwiftUI scroll view with bar charts for each category showing the count of active and done tasks; user can reutn to Home Screen.

For Core Data Model:
1. Category Entity:
   * name: Name of category
   * cellBackgroundColorHexString: Stores the random-generated background color of the table view cell in Hex format.
3. Task Entity:
   * name: Name of task
   * categoryName: Name of category associated with the task
   * creationDate: Creation date of the task
   * isDone: True for "Done" or False for "Active"
   * completionDate: Completion date of the task when the user marks as done; if user marks as done multiple times, the latest value is kept.

# Conclusion

<div style="display:flex">
    <img src="/Screenshots/iPhone_Launch.png" style="width: 18%">
    <img src="/Screenshots/iPhone_Home.png" style="width: 18%">
    <img src="/Screenshots/iPhone_Tasks.png" style="width: 18%">
    <img src="/Screenshots/iPhone_Search.png" style="width: 18%">
    <img src="/Screenshots/iPhone_Analytics.png" style="width: 18%">
</div>

By using the mobile application above, a user can keep track of his/her todo lists i.e. categories and tasks as well as see his/her completion analytics i.e. how many tasks are marked as active or done for each category.

Here are some areas for improvement:
1. Analytics Screen: Can add a Navigation View for additional charts such as number of active and done tasks over time for a category.
2. Tasks Screen: Can add a sort button or dropdown to allow the user to automatically order by category or task name; perhaps, also implement a manual ordering preference.
