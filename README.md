# hken

patch cn hsr client to en

## tutorial

1. open powershell

2. run `cd path` where path is the path to your folder with StarRail.exe

3. paste this script in powershell and press enter:

    ```powershell
    $DIR_PATH="./StarRail_Data/StreamingAssets/DesignData/Windows/";$FONT_PAT=[System.Text.Encoding]::ASCII.GetBytes("SpriteOutput/UI/Fonts/RPG_CN.ttf");$LANG_PAT=[System.Text.Encoding]::ASCII.GetBytes("Korean");$REPLACE=[System.Text.Encoding]::ASCII.GetBytes("en");function F($B,$P){for($i=0;$i-le($B.Length-$P.Length);$i++){ $m=$true;for($j=0;$j-lt $P.Length;$j++){if($B[$i+$j]-ne $P[$j]){$m=$false;break}};if($m){return $i}};-1};function A($B,$S,$G,$C){0..($C-1)|%{ $o=$S+($_*($G+$REPLACE.Length));[Array]::Copy($REPLACE,0,$B,$o,$REPLACE.Length)}};Get-ChildItem -Path $DIR_PATH -File|%{ $f=$_.FullName;[byte[]]$c=[System.IO.File]::ReadAllBytes($f);$p1=F $c $FONT_PAT;$p2=F $c $LANG_PAT;if($p1-ge 0 -and $p2-ge 0){Write-Host "found: $($_.Name)";Write-Host "patching...";$b=$p2+14;A $c $b 1 4;$n=$b+(4*3)+6;A $c $n 1 2;$n2=$n+(2*3)+6;A $c $n2 1 5;$n3=$n2+(5*3)+5;A $c $n3 1 2;[System.IO.File]::WriteAllBytes($f,$c);Write-Host "done.";break}}
    ```

    If that looks suspicious, it is a minified version of `main.ps1` which you can check in this repository.

## old binary

i've deleted the source (main.c) of hken.exe (the one in prebuilt), but you can still find them in older commits.
