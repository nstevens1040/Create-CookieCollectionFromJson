# Using cookies in Windows PowerShell  
This script creates a **System.Net.CookieCollection** object in **Windows PowerShell** using the json exported from the [EditThisCookie](https://www.editthiscookie.com) browser extension.  
(*This will not work in PowerShell Core because the script uses .NET Framework libraries*)  

# EditThisCookie
To get started, install the [EditThisCookie](https://www.editthiscookie.com) browser extension (currently available for **Chrome** and **Opera**).  
   - [Chrome](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg)
   - [Opera](https://addons.opera.com/en/extensions/details/edit-this-cookie)  

Once it's installed, you can identify the extension by it's cookie icon.  
  
<img height=344 width=320 src="https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/.gitignore/1.PNG">  
  
Click once on the cookie icon, then find the **export** button.  
  
<img height=344 width=320 src="https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/.gitignore/2.PNG">  
  
Click once on the **export** icon. The extension will let say **Cookies copied to the clipboard** in a small pop-up box.  
  
<img height=344 width=320 src="https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/.gitignore/3.png">  
  
Open your favorite text editor and paste your cookies. Save the file with a **.json** file extension.  
    
<img height=360 width=640 src="https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/.gitignore/1.gif"/>  
  
# How to use Create-CookieCollectionFromJson  

Now that you have your cookies in a json file, go ahead and launch **Windows PowerShell**.  
**1.** To make the script available in your current PowerShell session, run the code below.  
```ps1
iex (irm "https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/Create-CookieCollectionFromJson.ps1")
```  
**2.** The script takes only one argument via the **-JsonFilePath** parameter.  
Run the script like so.  
```ps1
Create-CookieCollectionFromJson -JsonFilePath "$($ENV:USERPROFILE)\Path\To\JsonFile.json"
```  
The script will notify you of it's success and let you know how to access the cookies.  
It creates a custom c# class with a property named (*your cookie domain*)_cookies.  

Here is an example I created with [terminalizer](https://terminalizer.com) **&darr;**  

<img height=360 width=640 src="https://raw.githubusercontent.com/nstevens1040/Create-CookieCollectionFromJson/main/.gitignore/render1622658112677.gif"/>  
  
In the example above, after I create my **CookieCollection** object the script tells me that it's accessible via **[Nstevens1040.Cookies]::nstevens1040_cookies.**  
To view my CookieCollection's properties, I run  
```ps1
[Nstevens1040.Cookies]::nstevens1040_cookies | select name,value,expires,secure,path,domain | ft -AutoSize
```  
**3.** To use the CookieCollection in an HTTP request I load my other library, **[Execute.HttpRequest](https://github.com/nstevens1040/Execute.HttpRequest)**, into Windows PowerShell with the command below.  
```ps1
Add-Type -TypeDefinition ([System.Net.WebClient]::new()).DownloadString(
    "https://raw.githubusercontent.com/nstevens1040/Execute.HttpRequest/master/Execute.HttpRequest/Execute.HttpRequest.cs"
) -ReferencedAssemblies @(
    "C:\Windows\Microsoft.Net\assembly\GAC_MSIL\System.Net.Http\v4.0_4.0.0.0__b03f5f7f11d50a3a\System.Net.Http.dll",
    "C:\Windows\Microsoft.Net\assembly\GAC_MSIL\Microsoft.CSharp\v4.0_4.0.0.0__b03f5f7f11d50a3a\Microsoft.CSharp.dll"
)
```  
**4.** Send my HTTP request  
```ps1
$r = [Execute.HttpRequest]::Send(
    "https://nstevens1040.github.io/Create-CookieCollectionFromJson",
    [System.Net.Http.HttpMethod]::Get,
    $null,
    [Nstevens1040.Cookies]::nstevens1040_cookies
)
```
To view the CookieCollection returned from the HTTP request  
```ps1
$r.CookieCollection | select name,value,expires,secure,path,domain | ft -AutoSize
```  
  
