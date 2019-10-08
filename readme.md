Change name of Your own project:

* You can rename Your project folder first if want

Step 1 - Rename the project
- Open Xcode
- Click on the project you want to rename in the "Project navigator" on the left of the Xcode view.
- On the right select the "File inspector" and the name of your project should be in there under "Identity and Type", change it to the new name.
- Click "Rename" in a dropdown menu
- Check file AppStoryboard.swift in folder "Application/Constant" and update it OLD name to NEW name

Step 2 - Rename the Scheme
- In the top bar (near "Stop" button), there is a scheme for your OLD product, click on it, then go to "Manage schemes"
- Click on the OLD name in the scheme, and it will become editable, change the name

Step 3 - Update Pods
- Quit Xcode.
- In the master folder, delete OLD.xcworkspace
- In Xcode: choose and edit Podfile from the project navigator. You should see a target clause with the OLD name. Change it to NEW.
- Run pod install
- Open NEW.xcworkspace

● Clean and build Your Project

Reference: 
https://stackoverflow.com/a/35500038
