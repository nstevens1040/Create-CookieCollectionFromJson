function Create-CookieCollectionFromJson
{
    [Cmdletbinding(DefaultParameterSetName="FilePath")]
    Param(
        [switch]$ReturnCSharp=$false,
        [Parameter(ValueFromPipeline=$true,ParameterSetName="FilePath")]
        [string]$JsonFilePath,
        [Parameter(ValueFromPipeline=$true,ParameterSetName="String")]
        [string]$JsonString
    )
    if(![string]::IsNullOrEmpty($JsonFilePath))
    {
        $json = [io.file]::ReadAllText($JsonFilePath)
        $site = (@($JSON | ConvertFrom-Json)[0][0].domain -replace "^\.",'').Split('.')[0]
    }
    if(![string]::IsNullOrEmpty($JsonString))
    {
        $json = $JsonString
        $site = (@($JsonString | ConvertFrom-Json)[0][0].domain -replace "^\.",'').Split('.')[0]
    }
    $namespace = [string]::Join(
        '',
        @(for($i = 0; $i -lt $site.ToCharArray().Count; $i++)
        {
            switch($i)
            {
                0 { $site.ToCharArray()[$i].ToString().ToUpper() }
                default { $site.ToCharArray()[$i].ToString().ToLower() }
            }
        })
    )
    $varname = $namespace.ToLower()
    $TOP = "namespace $($namespace)`n{`n    using System.Net;`n    using System;`n    public class Cookies`n    {`n        public static CookieCollection $($varname)_cookies = new CookieCollection(){"
    $BOTTOM = "        };`n    }`n}`n"
    $REPLACE = [ordered]@{}
    $REPLACE += @{'(\s*)"(.*)":(\s*)"(.*)"'='$1"$2" =$3"$4"';}
    $REPLACE += @{'(\s*)"(.*)":(\s*)(.*)'='$1"$2" =$3$4';}
    $REPLACE += @{'"domain"'='Domain';}
    $REPLACE += @{'"expirationDate"'='Expires';}
    $REPLACE += @{'(\s*)"hostOnly"(.+)'='';}
    $REPLACE += @{'"httpOnly"'='HttpOnly';}
    $REPLACE += @{'"name"'='Name';}
    $REPLACE += @{'"path"'='Path';}
    $REPLACE += @{'(\s*)"sameSite"(.+)'='';}
    $REPLACE += @{'"secure"'='Secure';}
    $REPLACE += @{'(\s*)"session"(.+)'='';}
    $REPLACE += @{'(\s*)"storeId"(.+)'='';}
    $REPLACE += @{'"value"(.+),'='Value$1';}
    $REPLACE += @{'(\s*)"id"(.+)'='';}
    $REPLACE += @{'\{'='new Cookie(){';}
    $REPLACE += @{'Expires = (.*),'='Expires = DateTime.Parse(@"1970-01-01").AddSeconds($1),'}
    $REPLACE.Keys.ForEach({
        $json = [regex]::New($_.ToString()).Replace($json,$REPLACE[$_].ToString())
    })
    $json_noclrf = [regex]::New("`n").Replace($json,"\n")
    $json_noclrf = $json_noclrf -replace "^\[",'' -replace "\]$",''
    $json_clrf = [regex]::New("\\n").Replace($json_noclrf,"`n")
    $cs = [regex]::New('(?m)^(.+)$').Replace($json_clrf,'            $1')
    $TypeDefinition = $TOP + $CS + $BOTTOM
    if($ReturnCSharp)
    {
        return $TypeDefinition
    } else
    {
        try {
            Add-Type -TypeDefinition $TypeDefinition
        }
        catch {
            write-host $_ 
        }
        if($?)
        {
            write-host "Success! " -ForeGroundColor Yellow -NoNewLine
            write-host "Access $($namespace) cookies by calling: " -ForeGroundColor Green -NoNewLine
            Write-Host "[$($namespace).Cookies]::$($varname)_cookies"
        }
    }
}
