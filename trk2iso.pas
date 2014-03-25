{$B-,D+,H+,I+,J+,P+,Q+,R+,S+,T-,V+,W+,X+,Z-}
{&AlignCode+,AlignData-,AlignRec-,Asm-,Delphi+,Frame+,G5+,LocInfo+,Open32-}
{&Optimise+,OrgName-,SmartLink+,Speed+,Use32+,ZD-}
{$M 1048576}


uses
  VpSysLow, SysUtils;

const
  BufSize = 1024*1024;

var
  StatsWorking :Boolean;
  hSem :TSemHandle;
  f :file;


procedure WriteStats;
begin
  SysCtrlEnterCritSec;
  Write(#8#8#8#8#8#8#8#8, (FilePos(f) / FileSize(f))*100 :7:2, '%');
  SysCtrlLeaveCritSec;
end;
(**)
function StatsWriter(Param :Pointer) :LongInt;
begin
  StatsWorking := True;
  repeat
    WriteStats;
  until SemRequestMutex(hSem, 1000);
  WriteStats;
  SemCloseMutex(hSem);
  Result := 0;
  StatsWorking := False;
end;


var
  Buf :Pointer;
  Result :LongInt;
  ThreadID :LongInt;
  fn :string;

begin
  WriteLn('trk2iso, a RSJ''s TRK to ISO format convertion utility. (c) vv 2000'#13#10);

  fn := ExpandFileName(ParamStr(1));

  if fn='' then
  begin
    WriteLn('usage: trk2iso <filename>');
    Halt(1);
  end else
  begin
    try
      WriteLn('* warning: have you read the precautions in the readme file?');
      WriteLn('           if not, press Ctrl+Break NOW.');
      Write(#13#10'press <enter> to proceed.');
      ReadLn; WriteLn;
      try
        FileMode := open_access_ReadWrite or open_share_DenyReadWrite;
        Assign(f, fn); Reset(f, 1);
        GetMem(Buf, BufSize);
        FillChar(Buf^, BufSize, 0);
        hSem := SemCreateMutex(nil, False, True);
        Write('moving content by 40 bytes...        ');
        StatsWorking := BeginThread(nil, 16*1024, StatsWriter, nil, 0, ThreadId) = 0;
        repeat
          Seek(f, FilePos(f)+40);
          BlockRead(f, Buf^, BufSize, Result);
          Seek(f, FilePos(f)-Result-40);
          BlockWrite(f, Buf^, Result);
        until Result <> BufSize;
        Truncate(f);
      finally
        SemReleaseMutex(hSem);
        while StatsWorking do SysCtrlSleep(1);
        WriteLn;
        if Buf <> nil then FreeMem(Buf, BufSize);
        Close(f);
        try
          RenameFile(fn, system.Copy(fn, 1, Length(fn)-Length(ExtractFileExt(fn)))+'.iso');
        finally
          WriteLn('done.');
        end;
      end;
    except
      on E:EControlC do WriteLn(#13#10'aborted!');
    end;
  end;
end.
