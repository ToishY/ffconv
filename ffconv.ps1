<#
    .SYNOPSIS 
      Converts input files and hardcodes subtitles using FFMPEG
    .DESCRIPTION
      This script makes it easier for users to convert files without having to change settings
      manually everytime. Depending on the amount of streams (>1 audio; >1 subtitle) in the input file,
      the user will be asked to select the desired audio/subtitle stream for the output file. With
      batch conversion these settings will be remembered after the first run.
    .EXAMPLE
      >> LINUX
      # Single file conversion (without forcing new subtitle styles)
      pwsh ffconv.ps1 -file "/my/input/file.mkv" -vd_preset "/path/to/video_preset.json" -output_dir "/my/single/dir/out"
      # Single file conversion (forcing new subtitle styles)
      pwsh ffconv.ps1 -file "/my/input/file.mkv" -vd_preset "/path/to/video_preset.json" -sb_preset "/path/to/subs_preset.json" -output_dir "/my/single/dir/out"
      # Batch conversion (without forcing new subtitle styles)
      pwsh ffconv.ps1 -file "/my/input/dir" -vd_preset "/path/to/video_preset.json" -ouput_dir "/my/batch/dir/out"
      # Batch conversion (forcing new subtitle styles)
      pwsh ffconv.ps1 -file "/my/input/dir" -vd_preset "/path/to/video_preset.json" -sb_preset "/path/to/subs_preset.json" -ouput_dir "/my/batch/dir/out"
      >> WINDOWS
      # Single file conversion (without forcing new subtitle styles)
      powershell -executionpolicy bypass -File .\ffconv.ps1 -file "/my/input/file.mkv" -vd_preset "/path/to/video_preset.json" -output_dir "helloworld"
      # Batch file conversion (forcing new subtitle styles)
      powershell -executionpolicy bypass -File .\ffconv.ps1 -file "/my/input/dir" -vd_preset "/path/to/video_preset.json" -sb_preset "/path/to/subs_preset.json" -output_dir "/my/batch/dir/out"
    .NOTES
      >> INDEXING
      In order for the script to work normally (especially in batch mode), the input files should have already been properly indexed beforehand. This is actually the task of 
      the releaser (in my opinion), but it can't be helped that even verified releasers sometimes fail when it comes to muxing. Most of the time you shouldn't have
      to worry to much about it, but it's better to be safe and check 2/3 files of a batch beforehand. You can easily change the ID/index by using the MKVToolnix GUI and
      dragging the streams in the right order and then remuxing the file.
         
      #RIGHT
      [STREAM] index=0; codec_type=video      [/STREAM]
      [STREAM] index=1; codec_type=audio      [/STREAM]
      [STREAM] index=2; codec_type=audio      [/STREAM]
      [STREAM] index=3; codec_type=subtitle   [/STREAM]
      [STREAM] index=4; codec_type=subtitle   [/STREAM]
      [STREAM] index=5; codec_type=attachment [/STREAM]
      [STREAM] index=6; codec_type=attachment [/STREAM]

      #WRONG
      [STREAM] index=0; codec_type=video      [/STREAM]
      [STREAM] index=1; codec_type=audio      [/STREAM]
      [STREAM] index=2; codec_type=subtitle   [/STREAM]
      [STREAM] index=3; codec_type=subtitle   [/STREAM]
      [STREAM] index=4; codec_type=audio      [/STREAM]
      [STREAM] index=5; codec_type=attachment [/STREAM]
      [STREAM] index=6; codec_type=attachment [/STREAM]

      #WRONG
      [STREAM] index=0; codec_type=attachment [/STREAM]
      [STREAM] index=1; codec_type=audio      [/STREAM]
      [STREAM] index=2; codec_type=video      [/STREAM]
      [STREAM] index=3; codec_type=subtitle   [/STREAM]
      [STREAM] index=4; codec_type=audio      [/STREAM]
      [STREAM] index=5; codec_type=attachment [/STREAM]
      [STREAM] index=6; codec_type=subtitle   [/STREAM]

      >> AMOUNT OF STREAMS
      Make sure that if you are going for batch mode, that your input files have the same amount of (video and) audio streams. I say this because I've seen the script
      fail sometimes when I had a batch where a few files had 2 or more audio streams while the first file that starts the batch had only 1. It tends to fail then because at the first file 
      the script will sometimes ask for user input (depending on how many streams there are) and it will then use these settings (amount of streams, specified audio/subtitle stream, etc.) 
      for all the other files in batch.
      >> OS & FFmpeg version
      * Tested on Windows 10 with the following FFmpeg version:
        ffmpeg version N-91330-ga990184007 Copyright (c) 2000-2018 the FFmpeg developers
        built with gcc 7.3.0 (GCC)
        configuration: --enable-gpl --enable-version3 --enable-sdl2 --enable-bzlib --enable-fontconfig --enable-gnutls --enable-iconv --enable-libass --enable-libbluray 
        --enable-libfreetype --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libopus --enable-libshine 
        --enable-libsnappy --enable-libsoxr --enable-libtheora --enable-libtwolame --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx264 --enable-libx265 
        --enable-libxml2 --enable-libzimg --enable-lzma --enable-zlib --enable-gmp --enable-libvidstab --enable-libvorbis --enable-libvo-amrwbenc --enable-libmysofa 
        --enable-libspeex --enable-libxvid --enable-libaom --enable-libmfx --enable-amf --enable-ffnvcodec --enable-cuvid --enable-d3d11va --enable-nvenc --enable-nvdec 
        --enable-dxva2 --enable-avisynth
        libavutil      56. 18.102 / 56. 18.102
        libavcodec     58. 20.103 / 58. 20.103
        libavformat    58. 17.100 / 58. 17.100
        libavdevice    58.  4.101 / 58.  4.101
        libavfilter     7. 25.100 /  7. 25.100
        libswscale      5.  2.100 /  5.  2.100
        libswresample   3.  2.100 /  3.  2.100
        libpostproc    55.  2.100 / 55.  2.100
      * Tested on Ubuntu 18.04 with the following FFmpeg version:
        ffmpeg version 4.0.3-1~18.04.york0 Copyright (c) 2000-2018 the FFmpeg developers
        built with gcc 7 (Ubuntu 7.3.0-27ubuntu1~18.04)
        configuration: --prefix=/usr --extra-version='1~18.04.york0' --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu 
        --arch=amd64 --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libaom 
        --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfreetype 
        --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus 
        --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora 
        --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid 
        --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opengl --enable-sdl2 --enable-libdc1394 --enable-libdrm --enable-libiec61883 
        --enable-chromaprint --enable-frei0r --enable-libopencv --enable-libx264 --enable-shared
        libavutil      56. 14.100 / 56. 14.100
        libavcodec     58. 18.100 / 58. 18.100
        libavformat    58. 12.100 / 58. 12.100
        libavdevice    58.  3.100 / 58.  3.100
        libavfilter     7. 16.100 /  7. 16.100
        libavresample   4.  0.  0 /  4.  0.  0
        libswscale      5.  1.100 /  5.  1.100
        libswresample   3.  1.100 /  3.  1.100
        libpostproc    55.  1.100 / 55.  1.100
    .CREDITS
      Made by:        YTerZ
      Github:         https://github.com/YTerZ/ffconv
      Last modified:  10-1-2019 02:24
#>

#------------- ARGUMENTS START ------------- #
param (
    [Parameter(Mandatory=$true)]
    [string]$file,
    [Parameter(Mandatory=$true)]
    [string]$output_dir,
    [Parameter(Mandatory=$true)]
    [string]$vd_preset = "",
    [string]$sb_preset = "",
    [string]$remove_origin = "N",
    [string]$remove_temp = "N",
    [string]$extension = "mp4"
)
#------------- ARGUMENTS END ------------- #

#------------- FUNCTIONS START -------------#

function Check-Presets {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$jsonFile,
        [Parameter(Mandatory=$true)]
        [int]$opt
    )

    #convert json to object
    $jsonObject = Get-Content $jsonFile | ConvertFrom-Json

    #create ordered hashtable for easy access
    $htable = [ordered]@{}

    #put content into table
    $jsonObject.psobject.properties | Foreach { $htable[$_.Name] = $_.Value }

    #put non-empty values in list
    $v = New-Object System.Collections.Generic.List[System.Object]
    foreach ($h in $htable.GetEnumerator()){
        if($($h.Value)){
            if($opt -eq 0){
                $v.Add($($h.Name) + " " + $($h.Value))
            }elseif($opt -eq 1){
                $v.Add($($h.Name) + "=" + $($h.Value))
            }
        }
    }

    if($opt -eq 0){
        $res = $v -join ' '
        #check if atleast the video codec is specified
        if($res -like "*-c:v*"){
            #OK
        }else{
            Write-Error "The JSON file was either empty or does not contain a video codec (-c:v). Please check again.";
        }
    }elseif($opt -eq 1){
        $res = $v -join ','
    }else{
        Write-Error "Invalid -opt argument given: $opt. Must be 0 (video) or 1 (audio)."
    }
    return $res
}

function Invoke-FoldArray {
  Param(
    [Parameter(Mandatory=$true)]
    [array]$myArray,
    [int]$SplitInTo = 3
  )

  $ht = [ordered]@{}
  0..($SplitInTo-1) | % {
    $ht["info_$_"] = @()
  }

  $i = 0
  $myArray | % {
    $ht["info_$i"] += $_
    $i++
    $i %= $SplitInTo
  }

  return $ht
}

function Create-Directory{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$mdir
    )

    #check if dir not yet exists
    if (!($mdir | Test-Path)){
        Write-Host ">> Given directory does not exists; creating new folder"
        New-Item -ItemType "directory" -Path "$mdir"
    }else{
        Write-Host ">> Given directory exists; not creating new folder"
    }
    return $mdir
}

function CheckOsDir{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$mpath
    )

    #check OS + append slash
    if($Env:OS -match "windows" -or $IsWindows){
        if($mpath[-1] -notmatch '\\'){
            $mpath+='\'
        }
    }elseif($Env:OS -match "linux" -or $IsLinux){
        if($mpath[-1] -notmatch '//'){
            $mpath+='/'
        }
    }
    return $mpath
}

function GetFileStreams{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$fileName
    )

    $probe_string = 'ffprobe -v error -select_streams %t0% -show_entries %t1% -of csv=s=,:p=0 "$fileName"'

    $v_p = Invoke-Expression($probe_string.Replace("%t0%","v").Replace("%t1%","stream=index,codec_long_name,pix_fmt")) #video streams
    $a_p = Invoke-Expression($probe_string.Replace("%t0%","a").Replace("%t1%","stream=index,codec_name:stream_tags=language")) #audio streams
    $s_p = Invoke-Expression($probe_string.Replace("%t0%","s").Replace("%t1%","stream=index,codec_name:stream_tags=language")) #subtitle streams

    if($v_p -and $a_p -and $s_p){
        #video
        $v_a = Invoke-FoldArray -myArray $v_p.Split(",")
        #audio
        $a_a = Invoke-FoldArray -myArray $a_p.Split(",")
        #subtitle
        $s_a = Invoke-FoldArray -myArray $s_p.Split(",")
        #return
        return $v_a, $a_a, $s_a
    }else{
        Write-Error "A video, audio and/or subtitle stream is missing from your file! Atleast 1 video, 1 audio and 1 subtitle stream are required."
    }
}

function CheckFileStreams{
    Param(
        [Parameter(Mandatory=$true)]
        $stream,
        [Parameter(Mandatory=$true)]
        [int]$opt
    )

    if($opt -eq 0){
        $var = "video"
    }elseif($opt -eq 1){
        $var = "audio"
    }elseif($opt -eq 2){
        $var = "subtitle"
    }

    #amount of streams
    $aos = $stream["info_0"].Count 

    if($aos -gt 1){ #multiple streams; user input required
        for($i = 0;$i -lt $aos;$i++){
            if($opt -eq 0){
                Write-Host ">>> Multiple $var streams: Index = "$stream["info_0"][$i]"; Codec = "$stream["info_1"][$i]"; PIX_FMT = "$stream["info_2"][$i]
            }else{
                Write-Host ">>> Multiple $var streams: Index = "$stream["info_0"][$i]"; Codec = "$stream["info_1"][$i]"; Lang = "$stream["info_2"][$i]
            }
        }
        [int]$stream_number = Read-Host ">> Multiple streams found. Please manually select your stream with the corresponding index"
        Write-Host ">> Your stream choice: $stream_number"
    }else{ #only 1 stream detected
        [int]$stream_number = $stream["info_0"][0]
        Write-Host ">> One $var stream was automatically detected for mapping."
    }
    Start-Sleep -m 300
    return $aos, $stream_number
}

function VidOptions{
    Param(
        [Parameter(Mandatory=$false)]
        [string]$video_preset
    )

    #CHECK VIDEO CODEC OPTIONS
    if($video_preset){
        $vd_string = Check-Presets -jsonFile $video_preset -opt 0
        if($vd_string -like "*-c:v*"){
            return $vd_string
        }else{
            Write-Error "The JSON file was either empty or does not contain a video codec (-c:v). Please check again."
        }
    }else{
        Write-Error "The JSON file was either empty or does not contain a video codec (-c:v). Please check again."
    }
}

function AudOpts{
    Param(
        [Parameter(Mandatory=$true)]
        $audio_array,
        [Parameter(Mandatory=$true)]
        [string]$stream_number
    )

    #audio map
    $ad_map = "-map 0:$stream_number"

    #Check audio codec
    $h = $audio_array["info_1"][$stream_number-1]
    if($h -like "aac"){ #stream copy
        $ad_string = "-c:a copy"
    }elseif(($h -like "flac") -or ($h -like "dts") -or ($h -like "ac3") -or ($h -like "eac3")){ #higher bitrate for flac/dts/ac3 releases
        $ad_string = "-c:a aac -strict 2 -ab 192k -ac 2"
    }else{ #default
        $ad_string = "-c:a aac -strict 2 -ab 128k -ac 2"
    }
    return $ad_map, $ad_string
}

function ExtractVideoSubs{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$fileName,
        [Parameter(Mandatory=$true)]
        [int]$vindex,
        [Parameter(Mandatory=$true)]
        [int]$aindex,
        [Parameter(Mandatory=$true)]
        [int]$sindex,
        [Parameter(Mandatory=$true)]
        [int]$stream_count,
        [Parameter(Mandatory=$false)]
        [string]$jsonFile
    )

    if($jsonFile){
        $tpath = CheckOsDir([System.IO.Path]::GetDirectoryName($fileName))
        $renamedOrigin = ([System.IO.Path]::GetFileNameWithoutExtension($fileName)) + "(0)" + ([System.IO.Path]::GetExtension($fileName))
        Rename-Item -LiteralPath $fileName -NewName $renamedOrigin -Force
        $renamedOriginN = "$tpath" + $renamedOrigin

        <# MKVEXTRACT #>

        #get path for temp ass subs
        $subs = "$tpath" + "tmp.ass"
    
        #double quote filename
        $renamedOrigin = '"{0}"' -f $renamedOriginN

        Write-Host ">> Starting extraction using MKVextract"
        Start-Process 'mkvextract' -ArgumentList "tracks $renamedOrigin $sindex`:$subs" -NoNewWindow -Wait
        Write-Host ">> Done extracting ASS"

        <# MKVMERGE #>

        #JSON FILE EXTRA
        $jsonObject = Get-Content $jsonFile | ConvertFrom-Json
        $htableExcp = [ordered]@{}
        $jsonObject.psobject.properties | Foreach { $htableExcp[$_.Name] = $_.Value}

        #SUBTITLE FILE
        $ASS = Get-Content -LiteralPath $subs

        #Remove non-used styles
        foreach($elem in ($ASS -match "Style:\s(\D.*)").Replace("Style: ","")){
            $tmp = $elem.split(",") | Select-Object -Index 0
            if($tmp){
                $str = ',' + $tmp + ','
                [int]$occ = (Select-String -InputObject $ASS -Pattern $str -AllMatches).Matches.Count
                #check if the first assigned actor/name is actually used, else remove
                if($occ -le 0){
                    $ASS = $ASS -ne "Style: $elem"
                    Write-Host ">>>Removed stylename '$tmp' because it does not appear in ASS"
                }
            }
        }

        #GET STYLES
        $t = ($ASS -match "Style:\s(\D.*)").Replace("Style: ","")
        [int]$xres = ($ASS -match "PlayResX:\s(\d.*)").Replace("PlayResX: ","")
        [int]$yres = ($ASS -match "PlayResY:\s(\d.*)").Replace("PlayResY: ","")
        $keys = ($ASS -match "Format:\s(\D.*)Encoding").Replace("Format: ","").split(", ").Where({ $_ -ne "" })

        $uresx = [int]$htableExcp["ResX"]
        $uresy = [int]$htableExcp["ResY"]
        $mean = (($uresy / $yres) + ($uresx / $xres)) / 2
 
        #remove first resx/resy from hash for further use
        $htableExcp.Remove("ResX")
        $htableExcp.Remove("ResY")

        #LOOP OVER STYLES
        $j = 0 #loop increment
        foreach($elem in $t){
            $tmp = $elem.split(",")
            $tmpHtable = [ordered]@{}
            for($i = 0;$i -lt $keys.Count;$i++){
                $tmpHtable[$keys[$i]] = $tmp[$i]

                #continue
                if((-not ($htableExcp["FontSize"]) -and ([string]$keys[$i] -eq "FontSize")) -or ([string]$keys[$i] -eq "MarginL") -or ([string]$keys[$i] -eq "MarginR") -or ([string]$keys[$i] -eq "MarginV")){
                    $tmpHtable[$keys[$i]] = [math]::Round([int]$tmpHtable[$keys[$i]] * $mean)
                }

                if($htableExcp[$keys[$i]]){
                    #adjust fontsize
                    if([string]$keys[$i] -eq "FontSize"){
                        #adjust all proportionally to given user fontsize
                        if($j -eq 0){
                            $font_factor = [math]::Round([int]$htableExcp[$keys[$i]] / [int]$tmpHtable[$keys[$i]],2)
                        }
                        $tmpHtable[$keys[$i]] = [math]::Round([int]$tmpHtable[$keys[$i]] * $font_factor)
                    }elseif(([string]$keys[$i] -eq "MarginL") -or ([string]$keys[$i] -eq "MarginR") -or ([string]$keys[$i] -eq "MarginV")){
                    #adjust margin
                        if([int]$htableExcp[$keys[$i]] -gt 0){ #positive; static; adjust all styles to given user margin
                            $tmpHtable[$keys[$i]] = $htableExcp[$keys[$i]]
                        }else{ #negative; dynamic; adjust all styles with subtracting user margin
                            if($j -eq 0){
                                if([string]$keys[$i] -eq "MarginV"){
                                    if([int]$tmpHtable[$keys[$i]] -gt 25){
                                        $margin_factor = [int]$htableExcp[$keys[$i]]
                                    }else{
                                        $margin_factor = 0
                                    }
                                }else{
                                    if(([int]$tmpHtable[$keys[$i]]) -gt [math]::Abs($htableExcp[$keys[$i]])){
                                        $margin_factor = [int]$htableExcp[$keys[$i]]
                                    }else{
                                        $margin_factor = 0
                                    }
                                }
                            }
                            $tmpHtable[$keys[$i]] = $tmpHtable[$keys[$i]] + $margin_factor
                        }
                    }else{
                    #all other styles force to user preference
                        $tmpHtable[$keys[$i]] = $htableExcp[$keys[$i]]
                    }
                }
            }

            $v = New-Object System.Collections.Generic.List[System.Object]
            foreach ($h in $tmpHtable.GetEnumerator()){
                $v.Add($($h.Value))
            }

            $res = $v -join ","
            $ASS = $ASS.Replace($elem,$res)
            #increment
            $j++
        }

        $ASS = $ASS -replace "PlayResX:\s(\d.*)" , "PlayResX: $uresx"
        $ASS = $ASS -replace "PlayResY:\s(\d.*)" , "PlayResY: $uresy"

        Set-Content -LiteralPath $subs -Value $ASS
        $args = ("--output '$fileName' --no-subtitles --language $vindex`:und --default-track $vindex`:yes --language $aindex`:und --default-track $aindex`:yes '(' $renamedOrigin ')' --language 0:eng --track-name 0:English '(' '$subs' ')' --track-order 0:0,0:1,1:0").Replace("'",'"')
        Write-Host ">> Starting merge of ASS & inputfile using MKVmerge"
        Start-Process 'mkvmerge' -ArgumentList $args -NoNewWindow -Wait
        Write-Host ">> Merging done"
        Remove-Item -LiteralPath $subs -Force
    }

    #escape special characters to make it windows friendly for subtitle filter
    if($Env:OS -match "windows" -or $IsWindows){
        $fileName = $fileName.Replace("\","\\").Replace(":","\:")
    }

    #subtitle offset stream from user input
    [string]$ssa = $sindex - $stream_count

    #subs map
    $subs_map = ('"{0}"' -f "subtitles='$fileName':si=$ssa")
    $subs_map = "-filter_complex $subs_map"
    return $subs_map, $renamedOriginN
}

function CleanUpFiles(){
    Param(
        [Parameter(Mandatory=$true)]
        [string]$origin_file,
        [Parameter(Mandatory=$false)]
        [string]$interm_file,
        [Parameter(Mandatory=$false)]
        [string]$olc,
        [Parameter(Mandatory=$false)]
        [string]$ilc
    )

    $origin_file = $origin_file.replace('"','')
    # Y = remove; N = kept
    if($origin_file -and $interm_file){
        if(($olc.ToLower() -eq "y") -and ($ilc.ToLower() -eq "y")){
            Remove-Item -LiteralPath $origin_file
            Remove-Item -LiteralPath $interm_file
            Write-Host ">> Input and temporary file(s) was/were kept."
        }elseif(($olc.ToLower() -eq "n") -and ($ilc.ToLower() -eq "y")){
            #remove intermediate filename (was set to original filename)
            Remove-Item -LiteralPath $origin_file -Force
            #rename the original filename
            Rename-Item -LiteralPath $interm_file -NewName (Split-Path -Path $origin_file -Leaf)
            Write-Host ">> Input file(s) was/were kept. Temporary file(s) removed."
        }elseif(($olc.ToLower() -eq "y") -and ($ilc.ToLower() -eq "n")){
            #remove intermediate filename (was set to original filename)
            Remove-Item -LiteralPath $interm_file -Force
            Write-Host ">> Input file(s) was/were removed. Temporary file(s) kept."
        }else{
            Write-Host ">> Input file(s) was/were kept."
        }
    }elseif($origin_file){
        if($olc.ToLower() -eq "y"){
            Remove-Item -LiteralPath $origin_file
        }else{
            Write-Host ">> Input file(s) was/were kept."
        }
    }else{
        Write-Host ">> Input file(s) was/were kept."
    }
}
#------------- FUNCTIONS END -------------#

if(Test-Path -LiteralPath $file -PathType Container){
    Write-Host ">> Input type: folder; batch mode"
    $batch = $file
    $files = Get-ChildItem "$batch"
    #Prepare output dir
    $morb = Create-Directory($output_dir)
    if($morb.Fullname){
        $mora = CheckOsDir($morb.Fullname)
    }else{
        $mora = CheckOsDir($output_dir)
    } 

    #Start batch loop
    for ($i=0; $i -lt $files.Count; $i++) {
        $name = $files[$i].FullName
        #Get file without extension
        $fnl = [System.IO.Path]::GetFileNameWithoutExtension($files[$i].Name)
        $output_file = '"{0}"' -f "$mora$fnl.$extension"

        if($i -eq 0){
            Write-Host "Converting file"($i+1)"in directory; Getting file info and requesting possible user input..."
            #GET STREAM INFO
            $video_stream, $audio_stream, $subtitle_stream = GetFileStreams -fileName $name

            #CHECK VIDEO STREAM INFO
            $vd_count, $vd_index = CheckFileStreams -stream $video_stream -opt 0
            #VIDEO MAP
            $video_map = "-map 0:$vd_index"

            #VIDEO JSON OPTIONS
            $vid_opts = VidOptions -video_preset $vd_preset

            #CHECK AUDIO STREAM INFO
            $ad_count, $ad_index = CheckFileStreams -stream $audio_stream -opt 1
            
            #amount of preceding video/audio streams
            $not_subs_streams = $vd_count + $ad_count
            
            #CREATE AUDIO MAP
            $audio_map, $audio_codec = AudOpts -audio_array $audio_stream -stream_number $ad_index

            #CHECK SUBTITLE STREAM INFO
            $sb_count, $sb_index = CheckFileStreams -stream $subtitle_stream -opt 2

            #CREATE SUBTITLE MAP
            $subs_map, $intermediate_file = ExtractVideoSubs -fileName $name -vindex $vd_index -aindex $ad_index -sindex $sb_index -stream_count $not_subs_streams -jsonFile $sb_preset

            $name = '"{0}"' -f $name
            Write-Host ">> File"($i+1)"..."
            #Create ffmpeg string
            $ffmpeg_command = "ffmpeg -i $name $video_map $audio_map $subs_map $vid_opts $audio_codec -movflags faststart $output_file"
            Write-Host ">> The following FFmpeg command will be run:`n"
            Write-Host $ffmpeg_command`n
            Start-Sleep -m 1500
            Write-Host ">> Start conversion..."
            #Invoke ffmpeg string
            Invoke-Expression $ffmpeg_command
            Write-Host ">> File"($i+1)"completed"

            #CLEAN UP
            CleanUpFiles -origin_file $name -olc $remove_origin -interm_file $intermediate_file -ilc $remove_temp
        }else{
            #CREATE SUBTITLE MAP
            $subs_map, $intermediate_file = ExtractVideoSubs -fileName $name -vindex $vd_index -aindex $ad_index -sindex $sb_index -stream_count $not_subs_streams -jsonFile $sb_preset

            $name = '"{0}"' -f $name
            Write-Host ">> File"($i+1)"..."
            #Create ffmpeg string
            $ffmpeg_command = "ffmpeg -i $name $video_map $audio_map $subs_map $vid_opts $audio_codec -movflags faststart $output_file"
            Write-Host ">> The following FFmpeg command will be run:`n"
            Write-Host $ffmpeg_command`n
            Start-Sleep -m 1500
            Write-Host ">> Start conversion..."
            #Invoke ffmpeg string
            Invoke-Expression $ffmpeg_command
            Write-Host ">> File"($i+1)"completed"
            
            #CLEAN UP
            CleanUpFiles -origin_file $name -olc $remove_origin -interm_file $intermediate_file -ilc $remove_temp
        }
    }
    #clear name
    Clear-Variable -name "name"
    Remove-Variable -name "name"
#------------- BATCH END -------------#

#------------- SINGLE START -------------#
}elseif(Test-Path -LiteralPath $file -PathType Leaf){
    Write-Host ">> Input type: file; single mode"
    $name = $file
    #Prepare output dir
    $morb = Create-Directory($output_dir)
    if($morb.Fullname){
        $mora = CheckOsDir($morb.Fullname)
    }else{
        $mora = CheckOsDir($output_dir)
    } 
    if(Test-Path -LiteralPath $name){
        #Get file without extension
        $fnl = [System.IO.Path]::GetFileNameWithoutExtension($name)
        $output_file = '"{0}"' -f "$mora$fnl.$extension"

        #GET STREAM INFO
        $video_stream, $audio_stream, $subtitle_stream = GetFileStreams -fileName $name

        #CHECK VIDEO STREAM INFO
        $vd_count, $vd_index = CheckFileStreams -stream $video_stream -opt 0
        #VIDEO MAP
        $video_map = "-map 0:$vd_index"

        #VIDEO JSON OPTIONS
        $vid_opts = VidOptions -video_preset $vd_preset

        #CHECK AUDIO STREAM INFO
        $ad_count, $ad_index = CheckFileStreams -stream $audio_stream -opt 1
            
        #amount of preceding video/audio streams
        $not_subs_streams = $vd_count + $ad_count
            
        #CREATE AUDIO MAP
        $audio_map, $audio_codec = AudOpts -audio_array $audio_stream -stream_number $ad_index

        #CHECK SUBTITLE STREAM INFO
        $sb_count, $sb_index = CheckFileStreams -stream $subtitle_stream -opt 2

        #CREATE SUBTITLE MAP
        $subs_map, $intermediate_file = ExtractVideoSubs -fileName $name -vindex $vd_index -aindex $ad_index -sindex $sb_index -stream_count $not_subs_streams -jsonFile $sb_preset

        $name = '"{0}"' -f $name
        #Create ffmpeg string
        $ffmpeg_command = "ffmpeg -i $name $video_map $audio_map $subs_map $vid_opts $audio_codec -movflags faststart $output_file"
        Write-Host ">> The following FFmpeg command will be run:`n"
        Write-Host $ffmpeg_command`n
        Start-Sleep -m 1500
        Write-Host ">> Start conversion..."
        #Invoke ffmpeg string
        Invoke-Expression $ffmpeg_command
        Write-Host ">> DONE"

        #CLEAN UP
        CleanUpFiles -origin_file $name -olc $remove_origin -interm_file $intermediate_file -ilc $remove_temp
    }else{
        Write-Error "This file does not exist in the specified directory, please check again"
    }
#------------- SINGLE END -------------#
}else{
    Write-Error "No (valid) filename was passed as input argument, please check again"
}
