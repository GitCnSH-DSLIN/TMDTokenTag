program TestGui;

uses
  SysUtils,
  Vcl.Forms,
  DUnitX.Loggers.GUIVCL,
  TMDStringTokenTagTest in 'TMDStringTokenTagTest.pas',
  TMDTokenTag in '..\Src\TMDTokenTag.pas';

begin
  Application.Initialize;
  Application.CreateForm(TGUIVCLTestRunner, GUIVCLTestRunner);
  Application.Run;
end.

