# FFconv

FFconv is an easy to use Powershell script that uses FFmpeg to re-encode and hardsub MKV files to MP4. 

### OS
Works on the following operating systems:
- Windows (tested Windows 10)
- Linux (tested Ubuntu 18.04)

### Prerequisites
The following programs have to be installed on your system:
- Powershell (tested v5.1 & 6.1)
- FFmpeg (tested v4.0)

### How To Use
The following arguments are available for ffconv:
- filename/foldername (-name/-batch; required)
- ffmpeg encoding setings (-vd_preset; required)
- output directory (-output_dir; required)
- subtitle forced styles (-sb_preset; optional)

The default subtitle font and styling can be forced to something else by changing the settings in the `subs_preset.json`. A section on how to change some of these settings is provided in a word document.

>Windows 10 CMD
```sh
powershell -executionpolicy bypass -File .\ffconv.ps1 -name "C:\path\to\awesome-video.mkv" -vd_preset "C:\path\to\video_preset.json" -output_dir "C:\path\to\output"
```

>Ubuntu 18.04 Terminal
```sh
pwsh ffconv.ps1 -name "/home/files/my-awesome-video.mkv" -vd_preset "/path/to/video_preset.json" -output_dir "/path/to/output"
```

```sh
pwsh ffconv.ps1 -name "/home/files/my-awesome-video.mkv" -vd_preset "/path/to/video_preset.json" -sb_preset "/path/to/subs_preset.json" -output_dir "/path/to/output"
```

### Possible updates
- Add audio preset (at the moment everything is encoded to 128/192 kbps AAC)
- Re-encode files that do not have a subtitle stream (at the moment the input file is required to have atleast one subtitle stream else it will throw an error-message)

### Remarks
I don't know which previous ffmpeg/powershell versions will work with this script (and I'm not going to waste time trying to figure that out). You're free to use this script however you like and adapt it to your liking (a mention would be nice).
