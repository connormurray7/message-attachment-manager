### _Introduction_
The Messages Attachment Manager is a Mac application that allows you to select and delete the attachments that you have sent and received from people in the Messages application. This is only for people that use Messages (iMessage) on their Mac, if you haven't linked Messages up to your iCloud account then you won't have all of the files on your computer.


### _How to use_
Clone the directory and open the `Message Attachment Manager` in XCode. Build and Run.

Currently, the application has not been deployed as a .app because of the reasons that I highlight in the bottom of [my post here](https://connormurray.me/Message-Attachment-Manager/). That for every delete in the attachment table in the `chat.db` file, triggers need to be dropped and re-added due to user defined functions (UDFs). When loading the db, the functions that are embedded in the triggers are undefined because they were not saved in the table. If you're interested how the functions are created you can [read more here](http://www.sqlite.org/c3ref/create_function.html). If anyone has a more clever way around the UDF constraint, please let me know.

### _Credits_


I would like to give credit to Ray Wenderlich for the [SlidesMagic](https://www.raywenderlich.com/120494/collection-views-os-x-tutorial) tutorial that I used for the backbone of the UI of the app. In addition I used Stephen Celis' [SQLite.swift](https://github.com/stephencelis/SQLite.swift) project for SQL calls to the database. Both of their licenses are present within the project.


