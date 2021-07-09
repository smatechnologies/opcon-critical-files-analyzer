# Critical Files Analyzer
This powershell script allows to analyze one or multiple OpCon Critical files.

The analysis is done on "Invalid event" entries i.e "Invalid event (schedule not found)"

The output of the analysis can be both on the screen and on an output file.

Several information will be provided:


* Total number of 'Invalid events' 
* Count aggregated by error type (i.e.  job not running, job non on schedule, etc)
* Count aggregated by event actions (JOB:KILL, JOB:SKIP, etc)
* Count aggregated by Schedule Name 
* Possibility to list all matching rows


# Disclaimer
No Support and No Warranty are provided by SMA Technologies for this project and related material. The use of this project's files is on your own risk.

SMA Technologies assumes no liability for damage caused by the usage of any of the files offered here via this Github repository.

# Prerequisites

* Powershell v5.1

# Instructions

```
powershell.exe .\CriticalFileAnalyzer.ps1

```  
Follow the interactive menu, you will be asked to chose the path where the Critical files are stored.

The script can scan :

* A single file
* A specific folder
* A specific folder and all the underlying subfolders

# License
Copyright 2019 SMA Technologies

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Contributing
We love contributions, please read our [Contribution Guide](CONTRIBUTING.md) to get started!

# Code of Conduct
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](code-of-conduct.md)
SMA Technologies has adopted the [Contributor Covenant](CODE_OF_CONDUCT.md) as its Code of Conduct, and we expect project participants to adhere to it. Please read the [full text](CODE_OF_CONDUCT.md) so that you can understand what actions will and will not be tolerated.
