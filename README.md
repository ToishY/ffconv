# FFconv

FFconv is an easy to use Powershell script that uses FFmpeg to re-encode and hardsub MKV files to MP4. 

### OS
Works on the following operating systems:
- Windows (tested Windows 10)
- Linux (tested Ubuntu 18.04)

###  
The following programs have to be installed on your system:
- Powershell (tested v5.1 & 6.1)
- FFmpeg (tested v4.0)
- MKVmerge & MKVextract / MKVtoolnix (optional for styling subtitles to liking)

### How To Use
The following arguments are available for ffconv:
- filename/foldername (-file; required)
- ffmpeg encoding setings (-vd_preset; required)
- output directory (-output_dir; required)
- subtitle forced styles (-sb_preset; optional)
- remove original/input file (-remove_origin; optional; accepts "Y"/"y" -or "N"/"n")
- remove temporary file (-remove_temp; optional; accepts "Y"/"y" -or "N"/"n"; will only be available if -sb_preset is used)

The default subtitle font and styling can be forced to something else by changing the settings in the `subs_preset.json`. A section on how to change some of these settings is provided in a word document.

### Examples
>Windows 10 CMD
```sh
powershell -executionpolicy bypass -File .\ffconv.ps1 -file "C:\path\to\awesome-video.mkv" -vd_preset "C:\path\to\video_preset.json" -output_dir "C:\path\to\output"
```

>Ubuntu 18.04 Terminal
```sh
pwsh ffconv.ps1 -file "/home/files/my-awesome-video.mkv" -vd_preset "/path/to/video_preset.json" -output_dir "/path/to/output"
```

```sh
pwsh ffconv.ps1 -file "/home/files/my-awesome-video.mkv" -vd_preset "/path/to/video_preset.json" -sb_preset "/path/to/subs_preset.json" -remove_temp "Y" -output_dir "/path/to/output"
```

_!Notes_
- If you want to keep the input files (in case you mess something up with `-sb_preset` option) and remove temporary files (created when `-sb_preset` is set), I suggest you use `-remove_temp "Y"`. This will remove the temporary file and keep the original file (**{original_file}.{ext}**).
- Not setting `-remove_temp` or `-remove_temp "N"` will make sure that both the original (input) file and the temporary file will be kept. The filenames will then be changed in such a fasion that a zero will be appended to the original file (**{original_file}(0).{ext}**) and the temporary file will get the original filename (**{original_file}.{ext}**).

### Possible updates
- Add audio preset (at the moment everything is encoded to 128/192 kbps AAC)

### Remarks
I don't know which previous ffmpeg/powershell versions will work with this script (and I'm not going to waste time trying to figure that out). You're free to use this script however you like and adapt it to your liking (a mention would be nice).
