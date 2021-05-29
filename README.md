# Import cookies into PowerShell and start making authenticated http requests  
Creates a **System.Net.CookieCollection** object in Windows PowerShell using the Json exported from the [EditThisCookie](https://www.editthiscookie.com) browser extension  
(*This will not work in PowerShell Core because the script uses .NET Framework libraries*).  

# EditThisCookie
To get started, install the [EditThisCookie](https://www.editthiscookie.com) browser extension (currently available for **Chrome** and **Opera**).  
   - [Chrome](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg)
   - [Opera](https://addons.opera.com/en/extensions/details/edit-this-cookie)  

Once it's installed, you can identify the extension by it's cookie icon <img height=50 width=50 src="https://cdn.editthiscookie.com/images/cookie_v1.png">.  

Click once on the cookie icon, then find the export button. At the top of the extension's control panel, you'll see two icons with arrows pointing to the right. The first one from the left is an **import** icon and the second one from the left is the **export** icon. Hovering your mouse over the icons will tell you what they are. Click once on the **export** icon. The extension will let say **Cookies copied to the clipboard** in a small pop-up box.  

Open your favorite text editor and paste your cookies. Save the file with a **.json** file extension.  

<img width=640 height=360 src="https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/.gitignore/3.gif">

# Create-CookieCollectionFromJson  
