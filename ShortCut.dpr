program ShortCut;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  StrUtils,
  {��������Ԫ�Ǳ����}
  ComObj, ActiveX, ShlObj;

procedure CreateLink(ProgramPath, ProgramArg, LinkPath, Descr: String);
var
  AnObj: IUnknown;
  ShellLink: IShellLink;
  AFile: IPersistFile;
  FileName: WideString;
begin
  if UpperCase(ExtractFileExt(LinkPath)) <> '.LNK' then // �����չ���Ƿ���ȷ
  begin
    raise Exception.Create('��ݷ�ʽ����չ�������� lnk!');
    // ������������쳣
  end;
  try
    OleInitialize(nil); // ��ʼ��OLE�⣬��ʹ��OLE����ǰ������ó�ʼ��
    AnObj := CreateComObject(CLSID_ShellLink); // ���ݸ�����ClassID����
    // һ��COM���󣬴˴��ǿ�ݷ�ʽ
    ShellLink := AnObj as IShellLink; // ǿ��ת��Ϊ��ݷ�ʽ�ӿ�
    AFile := AnObj as IPersistFile; // ǿ��ת��Ϊ�ļ��ӿ�
    // ���ÿ�ݷ�ʽ���ԣ��˴�ֻ�����˼������õ�����
    ShellLink.SetPath(PChar(ProgramPath)); // ��ݷ�ʽ��Ŀ���ļ���һ��Ϊ��ִ���ļ�
    ShellLink.SetArguments(PChar(ProgramArg)); // Ŀ���ļ�����
    ShellLink.SetWorkingDirectory(PChar(ExtractFilePath(ProgramPath)));
    // Ŀ���ļ��Ĺ���Ŀ¼
    ShellLink.SetDescription(PChar(Descr)); // ��Ŀ���ļ�������
    FileName := LinkPath; // ���ļ���ת��ΪWideString����
    AFile.Save(PWChar(FileName), False); // �����ݷ�ʽ
  finally
    OleUninitialize; // �ر�OLE�⣬�˺���������OleInitialize�ɶԵ���
  end;

end;

procedure OutputError;
begin
  writeln('Use:');
  writeln('  shortcut <app.exe> <app.lnk> [-param:<param>] [-desc:<desc>]');
  writeln('Samples:');
  writeln('  shortcut full_path_app.exe app.lnk');
  writeln('  shortcut full_path_app.exe app.lnk -param:<param>');
  writeln('  shortcut full_path_app.exe app.lnk -desc:<desc>');
  writeln('  shortcut full_path_app.exe app.lnk -param:<param> -desc:<desc>');
  writeln('  shortcut full_path_app.exe app.lnk -desc:<desc> -param:<param>');
end;

var
  appName: string;
  appLnkName: string;
  appParam: string;
  appDesc: string;

begin
  try
    if (paramcount <> 2) and (paramcount <> 3) and (paramcount <> 4) then
    begin
      OutputError;
      // readln;
      exit;
    end;
    if paramcount >= 2 then
    begin
      appName := paramstr(1);
      appLnkName := paramstr(2);
    end;
    if lowercase(rightstr(appLnkName, 3)) <> 'lnk' then
    begin
      writeln('Invalid <app.lnk> name.');
      exit;
    end;

    if (paramcount >= 3) and (MidStr(paramstr(3), 0, 7) = '-param:') then
    begin
      appParam := MidStr(paramstr(3), length('-param:') + 1, length(paramstr(3)) - length('-param:'));
    end
    else if (paramcount >= 3) and (MidStr(paramstr(3), 0, 6) = '-desc:') then
    begin
      appDesc := MidStr(paramstr(3), length('-desc:') + 1, length(paramstr(3)) - length('-desc:'));
    end;

    if (paramcount >= 4) and (MidStr(paramstr(4), 0, 6) = '-desc:') then
    begin
      appDesc := MidStr(paramstr(4), length('-desc:') + 1, length(paramstr(4)) - length('-desc:'));
    end
    else if (paramcount >= 4) and (MidStr(paramstr(4), 0, 7) = '-param:') then
    begin
      appParam := MidStr(paramstr(4), length('-param:') + 1, length(paramstr(4)) - length('-param:'));
    end;

    CreateLink(appName, appParam, appLnkName, appDesc);
    //writeln(appName);
    //writeln(appLnkName);
    //writeln(appParam);
    //writeln(appDesc);
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
