program Example1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  TMDTokenTag in '..\Src\TMDTokenTag.pas';

const
  CRLF = #13#10;

procedure RaiseError(const aStr: string = '解析错误');
begin
  raise Exception.Create(aStr);
end;

function GetData(const aName: string): string;
var
  LFilename: string;
  LDataSource: TStrings;
begin
  LFilename := TPath.Combine(ExtractFilePath(ParamStr(0)), aName);
  LDataSource := TStringlist.Create;
  LDataSource.LoadFromFile(LFilename);
  Result := LDataSource.Text;
  LDataSource.Free;
end;

procedure TestSimple;
var
  LSource: string;
  LTT: IStringTokenTag;
begin
  LSource := GetData('Simple.txt');
  LTT := TTMDStringTokenTag.Create(LSource, True);
  Writeln('-------- Test Simple --------');
  Writeln('## Tags');

  while LTT.GetNextTag('<Tag>', '</Tag>') do
  begin
    Writeln(LTT.Value);
  end;

  Writeln('');
  LTT.GoNextToken(CRLF);
  Writeln('## Tokens');

  while LTT.GetNextToken(';') do
  begin
    Writeln(LTT.Value);
  end;

  if not LTT.IsEof then
  begin
    LTT.GetStringToEof;
    Writeln(LTT.Value);
  end;
end;

procedure TestBaidu;
var
  LSource: string;
  LTT, LTT2: IStringTokenTag;
  LRank, LTitle, LURL, LCount: string;
begin
  LSource := GetData('Baidu.txt');
  LTT := TTMDStringTokenTag.Create(LSource, True);

  Writeln('-------- Test Baidu 搜索排行 --------');
  Writeln('');
  // 开始解析
  while LTT.GetNextTag('<td>', '</i></td>') do
  begin
    LTT2 := TTMDStringTokenTag.Create(LTT.Value, True);
    if not LTT2.GetNextTag('c-gap-icon-right-small">', '<') then
    begin
      RaiseError;
    end;
    LRank := LTT2.Value;
    if not LTT2.GetNextTag('title="', '"') then
    begin
      RaiseError;
    end;
    LTitle := LTT2.Value;

    if not LTT2.GetNextTag('href="', '"') then
    begin
      RaiseError;
    end;
    LURL := Concat('https://www.baidu.com/', LTT2.Value);

    if not LTT2.GetNextTag('<td class="opr-toplist-right">', '<i') then
    begin
      RaiseError;
    end;
    LCount := LTT2.Value;

    Writeln('# ', LRank, ' - ', LTitle, ' 点击率: ', LCount);
    Writeln('  ', LURL);
    Writeln('');

  end;
end;

procedure TestDouban;
var
  LSource: string;
  LTT, LTT2: IStringTokenTag;
  LTitle, LCover, LURL, LContent, LStar, LEvaluate: string;
  LCount: Integer;
begin
  LSource := GetData('Douban.txt');
  LTT := TTMDStringTokenTag.Create(LSource, True);

  Writeln('-------- Test Douban 电影排行 --------');
  Writeln('');
  // 开始解析
  LCount := 0;
  while LTT.GetNextTag('<tr class="item">', '</tr>') do
  begin
    Inc(LCount);

    LTT2 := TTMDStringTokenTag.Create(LTT.Value, True);

    if not LTT2.GetNextTag('<a class="nbg" href="', '"') then
    begin
      RaiseError;
    end;
    LURL := LTT2.Value;

    if not LTT2.GetNextTag('<img src="', '"') then
    begin
      RaiseError;
    end;
    LCover := LTT2.Value;

    if not LTT2.GoToken('<div class="pl2">') then
    begin
      RaiseError;
    end;
    if not LTT2.GetNextTag('class="">' + CRLF, CRLF) then
    begin
      RaiseError;
    end;
    LTitle := Trim(LTT2.Value);

    if not LTT2.GetNextTag('<span style="font-size:13px;">', '</span>') then
    begin
      RaiseError;
    end;
    LTitle := Concat(LTitle, ' / ', Trim(LTT2.Value));

    if not LTT2.GetNextTag('<p class="pl">', '</p>') then
    begin
      RaiseError;
    end;
    LContent := LTT2.Value;

    if not LTT2.GetNextTag('<span class="rating_nums">', '</span>') then
    begin
      RaiseError;
    end;
    LStar := LTT2.Value;

    if not LTT2.GetNextTag('<span class="pl">(', ')</span>') then
    begin
      RaiseError;
    end;
    LEvaluate := LTT2.Value;

    Writeln('#', LCount, ': ', LTitle, ' - 评分: ', LStar, ' 评分数量: ', LEvaluate);
    Writeln('内容: ', LContent);
    Writeln('');

  end;
end;

begin
  try
    TestSimple;
    TestBaidu;
    TestDouban;
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

