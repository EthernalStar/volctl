# ![Logo](./Icon.png?raw=true) volctl

**volctl** is a CLI Volume Control Tool.

It was written to be as simple as possible with the ability to be easily called by Scripts.
It also works over an SSH Connection.

The Tool was tested with Windows 10 and Windows 11.

## Documentation

![CLI Screenshot](./Images/volctl%2001.png?raw=true)

TBD

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

## License

* GNU General Public License v3.0. See [LICENSE](./LICENSE) for further Information.