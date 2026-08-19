### RaxSounds

A Bash-based Linux utility for automatically organizing FLAC music files using their embedded metadata.
The script reads metadata from FLAC files and organizes music into an **Artist / Album** directory structure, making large music libraries easier to maintain and manage.

## Features

* Reads FLAC metadata using `metaflac`
* Automatically creates Artist/Album directories
* Uses embedded metadata to determine file organization
* Handles album artwork embedded in FLAC files
* Automates repetitive music-library management
* Designed for Linux systems
* Runs entirely from the command line
* Can be integrated into automated server workflows

## Example
Before running the script:
```text
Music/
├── track01.flac
├── track02.flac
├── track03.flac
└── track04.flac
```
After processing:
```text
Music/
├── Artist A/
│   └── Album A/
│       ├── track01.flac
│       ├── track02.flac
│       └── cover.jpg
│
└── Artist B/
    └── Album B/
        ├── track03.flac
        ├── track04.flac
        └── cover.jpg
```
The resulting structure makes the library easier to browse and is particularly useful for self-hosted media servers.
## Technologies

* **Bash**
* **Linux**
* **metaflac**
* **GNU/Linux command-line utilities**
* **FLAC metadata**

## Requirements
A Linux system with:
* Bash
* FLAC command-line tools (`metaflac`)
* Standard GNU utilities
* 
## Usage

```bash
git clone https://github.com/FamillialSheep33/raxsounds.git
cd raxsounds
chmod +x raxsounds.sh
./raxsounds.sh
```

> The exact configuration and directory paths depend on the version of the script being used.


##  How It Works

The script follows a simple automation pipeline:

```text
              FLAC files
                   │
                   ▼
        ┌────────────────────┐
        │ Find FLAC files    │
        └─────────┬──────────┘
                  │
                  ▼
        ┌────────────────────┐
        │ Read FLAC metadata │
        │     metaflac       │
        └─────────┬──────────┘
                  │
                  ▼
        ┌────────────────────┐
        │ Extract Artist &   │
        │ Album information  │
        └─────────┬──────────┘
                  │
                  ▼
        ┌────────────────────┐
        │ Create directories │
        └─────────┬──────────┘
                  │
                  ▼
        ┌────────────────────┐
        │ Organize library   │
        └────────────────────┘
```

The important part of the project is that the filesystem structure is generated from the metadata contained within the music files rather than relying on manually created directories.

## Linux / Server Use

This project was designed with Linux environments in mind.
It can be useful on a home server where music files are continuously added to a library.
For example, the script can be combined with a scheduler such as `cron` to periodically check a directory for new files.
Example:
```cron
*/5 * * * * /path/to/flac-organizer.sh
```
This allows the organizer to run automatically every five minutes.

## Safety Considerations
Because this script modifies files and directories, it should be tested on a copy of a music library before being used on important data.
Recommended practices:
* Keep backups of important files.
* Test with a small directory first.
* Avoid running the script as `root` unless necessary.
* Verify metadata before processing a large library.

  
## What I Learned
This project gave me practical experience with Linux automation and shell scripting.
Through the project I worked with:
* Bash scripting
* Linux filesystem operations
* Process automation
* File manipulation
* Metadata extraction
* Command-line utilities
* Shell pipelines
* Directory management
* Automation with `cron`
* Debugging scripts on Linux
It also helped me understand how relatively small command-line tools can be combined to automate larger workflows.

## Author

**Angel Edell **

IT & Digital Innovation Engineering Student

Interested in:

* Linux
* Systems Administration
* DevOps
* Infrastructure
* Automation
* Networking
* Open Source

GitHub: **[@FamillialSheep33](https://github.com/FamillialSheep33)**

---

> A small Linux automation project built to solve a real problem in my personal music library.
