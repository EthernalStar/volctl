program project1;

uses Volunit, SysUtils;

procedure DisplayUsage;
begin

  WriteLn('                                                             ');
  WriteLn('volctl Version 1.0.0 - by EthernalStar                       ');
  WriteLn('                                                             ');
  WriteLn('LICENSED under the GNU General Public License v3.0.          ');
  WriteLn('                                                             ');
  WriteLn('This CLI Tool can be used to interact with the System Volume.');
  WriteLn('It is currently able to get/set Volume and the Mute Status.  ');
  WriteLn('The Tool can be called by other Applications or over SSH.    ');
  WriteLn('                                                             ');
  WriteLn('For Updates Check the following Repositories:                ');
  WriteLn(' > https://github.com/EthernalStar/volctl                    ');
  WriteLn(' > https://codeberg.org/EthernalStar/volctl                  ');
  WriteLn('                                                             ');
  WriteLn('Write me an Email for Feedback and Questions:                 ');
  WriteLn(' > NZSoft@protonmail.com                                     ');
  WriteLn('                                                             ');
  WriteLn('Changelog:                                                   ');
  WriteLn(' > v1.0.0: Initial Release.                                  ');
  WriteLn('                                                             ');
  WriteLn('Usage:                                                       ');
  WriteLn('                                                             ');
  WriteLn('Display this Help  : volctl.exe -h                           ');
  WriteLn('Get Volume         : volctl.exe -g                           ');
  WriteLn('Set Volume         : volctl.exe -s <to value>                ');
  WriteLn('Set Volume to 0    : volctl.exe -z                           ');
  WriteLn('Set Volume Random  : volctl.exe -r                           ');
  WriteLn('Increase Volume    : volctl.exe -i <by value>                ');
  WriteLn('Decrease Volume    : volctl.exe -d <by value>                ');
  WriteLn('Get Mute Status    : volctl.exe -gm                          ');
  WriteLn('Set Mute Status    : volctl.exe -sm <1|0>                    ');
  WriteLn('Switch Mute Status : volctl.exe -sw                          ');
  WriteLn('Set w.o. Auto Mute : volctl.exe -sa <to value>               ');

end;

procedure UsageError;  //Display Message and Exit when Usage is wrong
begin
  
  WriteLn('');
  WriteLn('Error - Wrong number of Parameters!');
  WriteLn('');
  WriteLn('Try volctl.exe -h to see all possible Parameters.');

  Halt(0);  //Exit

end;

var

  tempInt: Integer = 0;  //Temp Integer used for Type Checking

{$R *.res}

begin

  if NOT (ParamCount = 1) AND NOT (ParamCount = 2) then begin  //Raise Error if number of Parameters do not match any valid action

    UsageError;  //Display Usage Error

  end;

  VolUnit.InitializeVolCtl;  //Initialize needed Objects from the VolUnit

  Randomize;  //Call Randomize once for the -sr parameter

  if ParamStr(1) = '-g' then begin  //-g Parameter

    WriteLn(Volunit.GetVolume);  //Get Volume Value and write to Output

  end
  else if ParamStr(1) = '-s' then begin  //-s Parameter

    try

      tempInt := StrToInt(ParamStr(2));  //Check if Input is Integer

    except

      UsageError;  //Display Usage Error

    end;

    Volunit.SetVolume(tempInt);  //Set Volume Value from Parameter Input

  end
  else if ParamStr(1) = '-sa' then begin  //-sa Parameter

    try

      tempInt := StrToInt(ParamStr(2));  //Check if Input is Integer

    except

      UsageError;  //Display Usage Error

    end;

    Volunit.SetVolume(tempInt, False, False);  //Set Volume Value from Parameter Input without Auto Mute Feature

  end
  else if ParamStr(1) = '-r' then begin  //-r Parameter

    Volunit.SetVolume(Random(101));  //Set Volume to random Value

  end
  else if ParamStr(1) = '-z' then begin  //-z Parameter

    Volunit.SetVolume(0);  //Set Volume Value from Parameter Input

  end
  else if ParamStr(1) = '-i' then begin  //-i Parameter

    try

      tempInt := StrToInt(ParamStr(2));  //Check if Input is Integer

    except

      UsageError;  //Display Usage Error

    end;

    Volunit.SetVolume(tempInt, True);  //Set Volume with Relative Parameter True

  end
  else if ParamStr(1) = '-d' then begin  //-d Parameter

    try

      tempInt := -1 * StrToInt(ParamStr(2));  //Check if Input is Integer and Invert

    except

      UsageError;  //Display Usage Error

    end;

    Volunit.SetVolume(tempInt, True);  //Set Volume with Relative Parameter True

  end
  else if ParamStr(1) = '-gm' then begin  //-gm Parameter

    if Volunit.GetMuteStatus = True then begin  //Check if Muted

      WriteLn('1');  //Write Script friendly Result to Output

    end
    else begin

      WriteLn('0');  //Write Script friendly Result to Output

    end;

  end
  else if ParamStr(1) = '-sm' then begin  //-sm Parameter

    try

      if StrToInt(ParamStr(2)) <> 0 then begin  //CHeck for any other Value than 0

        Volunit.SetMuteStatus(True);  //Set Mute to True

      end
      else begin

        Volunit.SetMuteStatus(False);  //Set Mute to False

      end;

    except

      UsageError;  //Display Usage Error

    end;

  end
  else if ParamStr(1) = '-sw' then begin  //-sw Parameter

    Volunit.SwitchMuteStatus;  //Switch Mute Status

  end
  else if ParamStr(1) = '-h' then begin  //-h Parameter

    DisplayUsage;  //Show Help Message

  end
  else begin

    UsageError;  //Display Usage Error

  end;

end.

