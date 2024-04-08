unit Volunit;

{$mode objfpc}{$H+}

interface

uses
Windows, ActiveX, ComObj;
             
function GetVolume: Integer;
function GetMuteStatus: Boolean;
function VolumeBoundaryCheck(volume: Integer = 0): Integer;
                         
procedure SetVolume(volume: Integer; relative: Boolean = False; auto_unmute: Boolean = True);
procedure SetMuteStatus(muteStatus: Boolean);
procedure SwitchMuteStatus;

procedure InitializeVolCtl;

implementation

const
  CLASS_IMMDeviceEnumerator : TGUID = '{BCDE0395-E52F-467C-8E3D-C4579291692E}';
  IID_IMMDeviceEnumerator   : TGUID = '{A95664D2-9614-4F35-A746-DE8DB63617E6}';
  IID_IAudioEndpointVolume  : TGUID = '{5CDF2C82-841E-4546-9722-0CF74078229A}';
  eRender                           = $00000000;
  eConsole                          = $00000000;

type
  IAudioEndpointVolumeCallback = interface(IUnknown) ['{657804FA-D6AD-4496-8A60-352752AF4F89}'] end;

  IAudioEndpointVolume = interface(IUnknown) ['{5CDF2C82-841E-4546-9722-0CF74078229A}']
    function RegisterControlChangeNotify(AudioEndPtVol: IAudioEndpointVolumeCallback): HRESULT; stdcall;
    function UnregisterControlChangeNotify(AudioEndPtVol: IAudioEndpointVolumeCallback): HRESULT; stdcall;
    function GetChannelCount(out PInteger): HRESULT; stdcall;
    function SetMasterVolumeLevel(fLevelDB: single; pguidEventContext: PGUID): HRESULT; stdcall;
    function SetMasterVolumeLevelScalar(fLevelDB: single; pguidEventContext: PGUID): HRESULT; stdcall;
    function GetMasterVolumeLevel(out fLevelDB: single): HRESULT; stdcall;
    function GetMasterVolumeLevelScaler(out fLevelDB: single): HRESULT; stdcall;
    function SetChannelVolumeLevel(nChannel: Integer; fLevelDB: double; pguidEventContext: PGUID): HRESULT; stdcall;
    function SetChannelVolumeLevelScalar(nChannel: Integer; fLevelDB: double; pguidEventContext: PGUID): HRESULT; stdcall;
    function GetChannelVolumeLevel(nChannel: Integer; out fLevelDB: double): HRESULT; stdcall;
    function GetChannelVolumeLevelScalar(nChannel: Integer; out fLevel: double): HRESULT; stdcall;
    function SetMute(bMute: Boolean; pguidEventContext: PGUID): HRESULT; stdcall;
    function GetMute(out bMute: Boolean): HRESULT; stdcall;
    function GetVolumeStepInfo(pnStep: Integer; out pnStepCount: Integer): HRESULT; stdcall;
    function VolumeStepUp(pguidEventContext: PGUID): HRESULT; stdcall;
    function VolumeStepDown(pguidEventContext: PGUID): HRESULT; stdcall;
    function QueryHardwareSupport(out pdwHardwareSupportMask): HRESULT; stdcall;
    function GetVolumeRange(out pflVolumeMindB: double; out pflVolumeMaxdB: double; out pflVolumeIncrementdB: double): HRESULT; stdcall;
  end;

  IPropertyStore = interface(IUnknown) end;

  IMMDevice = interface(IUnknown) ['{D666063F-1587-4E43-81F1-B948E807363F}']
    function Activate(const refId: TGUID; dwClsCtx: DWORD;  pActivationParams: PInteger; out pEndpointVolume: IAudioEndpointVolume): HRESULT; stdCall;
    function OpenPropertyStore(stgmAccess: DWORD; out ppProperties: IPropertyStore): HRESULT; stdcall;
    function GetId(out ppstrId: PLPWSTR): HRESULT; stdcall;
    function GetState(out State: Integer): HRESULT; stdcall;
  end;

  IMMDeviceCollection = interface(IUnknown) ['{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}'] end;

  IMMNotificationClient = interface(IUnknown) ['{7991EEC9-7E89-4D85-8390-6C703CEC60C0}'] end;

  IMMDeviceEnumerator = interface(IUnknown) ['{A95664D2-9614-4F35-A746-DE8DB63617E6}']
    function EnumAudioEndpoints(dataFlow: TOleEnum; deviceState: SYSUINT; DevCollection: IMMDeviceCollection): HRESULT; stdcall;
    function GetDefaultAudioEndpoint(EDF: SYSUINT; ER: SYSUINT; out Dev :IMMDevice ): HRESULT; stdcall;
    function GetDevice(pwstrId: pointer; out Dev: IMMDevice): HRESULT; stdcall;
    function RegisterEndpointNotificationCallback(pClient: IMMNotificationClient): HRESULT; stdcall;
  end;

var
  volctl : IAudioEndpointVolume = Nil;
  devEnum: IMMDeviceEnumerator  = Nil;
  device : IMMDevice            = Nil;
  vlLevel: Single               =   0;

procedure InitializeVolCtl;  //Initializes all needed Objects
begin

  CoCreateInstance(CLASS_IMMDeviceEnumerator, Nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, devEnum);
  devEnum.GetDefaultAudioEndpoint(eRender, eConsole, device);
  device.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, Nil, volctl);

end;

function VolumeBoundaryCheck(volume: Integer = 0): Integer;  //Check if the value of the Integer is between 0 and 100 and change acordingly
begin

  Result := volume;  //Set volume as Result

  if volume < 0 then begin  //Check for volume < 0

    Result := 0;  //Set Result to 0

  end
  else if volume > 100 then begin  //Check for volume > 100

    Result := 100;  //Set Result to 100

  end;

end;

procedure SetVolume(volume: Integer; relative: Boolean = False; auto_unmute: Boolean = True);  //Function to set the volume Level
begin

  if relative = True then begin  //Check for Relative mode of operation

    volume := GetVolume + volume;  //Add current volume Value

  end;

  volctl.SetMasterVolumeLevelScalar(VolumeBoundaryCheck(volume) / 100, Nil);  //Apply Volume within the Boundaries of 0 - 100

  if auto_unmute = True then begin  //Automatic unmute for values > 0 and mute for volume = 0

    if VolumeBoundaryCheck(volume) <> 0 then begin  //Check if volume is not 0

      SetMuteStatus(False);  //unmute

    end
    else begin

      SetMuteSTatus(True);  //mute

    end;

  end;

end;

function GetMuteStatus: Boolean;  //Wraper Function for getting Mute Status
begin

  volctl.GetMute(Result);  //Get Mute Status and write it to Result

end;

procedure SetMuteStatus(muteStatus: Boolean);  //Wraper Function for setting Mute Status
begin

  volctl.SetMute(muteStatus, Nil);  //Set Mute Status

end;

procedure SwitchMuteStatus;  //Wraper Function for switching Mute Status
begin

  volctl.SetMute(NOT GetMuteStatus, Nil);  //Invert previous Mute Status

end;

function GetVolume: Integer;  //Wraper Function for getting Volume Value and normalizing it
begin

  volctl.GetMasterVolumeLevelScaler(vlLevel);  //Get Volume
  Result := Round(vlLevel * 100);  //Normalizing

end;

end.
