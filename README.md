# Import cookies into Windows PowerShell and start making authenticated http requests  
This script creates a **System.Net.CookieCollection** object in **Windows PowerShell** using the json exported from the [EditThisCookie](https://www.editthiscookie.com) browser extension.  
(*This will not work in PowerShell Core because the script uses .NET Framework libraries*)  

# EditThisCookie
To get started, install the [EditThisCookie](https://www.editthiscookie.com) browser extension (currently available for **Chrome** and **Opera**).  
   - [Chrome](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg)
   - [Opera](https://addons.opera.com/en/extensions/details/edit-this-cookie)  

Once it's installed, you can identify the extension by it's cookie icon <img height=50 width=50 src="https://cdn.editthiscookie.com/images/cookie_v1.png">.  

Click once on the cookie icon, then find the export button. At the top of the extension's control panel, you'll see two icons with arrows pointing to the right. The first one from the left is an **import** icon and the second one from the left is the **export** icon. Hovering your mouse over the icons will tell you what they are. Click once on the **export** icon. The extension will let say **Cookies copied to the clipboard** in a small pop-up box.  

Open your favorite text editor and paste your cookies. Save the file with a **.json** file extension.  

# Create-CookieCollectionFromJson  

Now that you have your cookies in a json file, go ahead and launch **Windows PowerShell**.  
To make the script available in your current PowerShell session, run the code below.  
```ps1
iex (irm "https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/Create-CookieCollectionFromJson.ps1")
```  
The script takes only one argument via the **-JsonFilePath** parameter.  
Run the script like so.  
```ps1
Create-CookieCollectionFromJson -JsonFilePath "$($ENV:USERPROFILE)\Path\To\JsonFile.json"
```  
The script will notify you of it's success and let you know how to access the cookies.  
The way it works is that it creates a custom c# class with a property named (*your cookie domain*)_cookies.  
