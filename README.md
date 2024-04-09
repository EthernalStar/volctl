# ![Logo](./Icon.png?raw=true) volctl

**volctl** is a CLI Volume Control Tool.

It was written to be as simple as possible with the ability to be easily called by Scripts.
It also works over an SSH Connection.

The Tool was tested with Windows 10 and Windows 11.

## Documentation

![CLI Screenshot](./Images/volctl%2001.png?raw=true)

There are three types of Commands for volctl.
Some require none, one or two parameters.
Commands wich are **BLOCKING** will freeze the CLI until Ctrl + C are pressed. 

The following flags exist:

| Flag | Parameters |             Description                      | Important |
|------|:----------:|----------------------------------------------|-----------|
| -h   |     0      | Displays the Help Screen.                    |           |
| -g   |     0      | Outputs the current Volume on CLI.           |           |
| -s   |     1      | Sets the Volume to the given Parameter.      | Auto Mutes when set to 0 and unmutes when set to > 0. |
| -i   |     1      | Increases the Volume by the given Parameter. | Can apply positive and negative values.               |
| -d   |     1      | Decreases the Volume by the given Parameter. | Can apply positive and negative values.               |
| -z   |     0      | Sets the Volume to 0.                        | Does not automatically mute the Volume.               |
| -r   |     0      | Sets the Volume to a random Value up to 100. | Auto Mutes when set to 0 and unmutes when set to > 0. |
| -l   |     2      | Limits the Volume between Parameter 1 and 2. | BLOCKING: Prevents further CLI usage until Ctrl + C.  |
| -f   |     1      | Forces the Volume to the given Parameter.    | BLOCKING: Prevents further CLI usage until Ctrl + C.  |
| -fa  |     1      | Same as -f without forcing unmute.           | BLOCKING: Prevents further CLI usage until Ctrl + C.  |
| -gm  |     0      | Displays 1 if muted and 0 if unmuted on CLI. |           |
| -sm  |     1      | Mutes for 1 and unmutes for 0 as Parameter.  |           |
| -sw  |     0      | Switches the current Mute Status.            |           |
| -sa  |     1      | Same as -s without forcing unmute or mute.   | Does not automatically mute or unmute like -s.        |

## Use Cases

Here are some situations where I use this Tool:

* Setting the System Volume easily through a Batch Script by calling volctl.
* Setting the System Volume of a PC in annother Room over an Remote Shell connection.
* Building some kind of limiter for the System Volume.

## Building

There shouldn't be any Problem building the Application because it doesn't rely on any external installed Packages.
To build the Project you need to have the [Lazarus IDE](https://www.lazarus-ide.org/) Version 2.2.6 installed.
After you have downloaded the Source Code or cloned this Repo just open the Project in your Lazarus Installation.
To do this just open the .lpr file and you should be able to edit and compile the Project.
You can also use the **Volunit.pas** Unit itself for your own Applications.

## Issues

* Currently there are no known Issues. If you find something please open an Issue on the Repository.

## Planned Features

* Currently there are no planned Features.

## Changelog

* Version 1.0.0:
  * Initial Release.
* Version 1.0.1:
  * Added Volume forcing.
  * Added Volume limiting.

## License

* GNU General Public License v3.0. See [LICENSE](./LICENSE) for further Information.