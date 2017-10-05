unit TMDStringTokenTagTest;

{
 DUnitX 测试单元
}

interface

uses
  DUnitX.TestFramework, TMDTokenTag;

const
  // 测试字符串源
  TestSource = '@CDAB@CD@CD@EF@GH@;   TheEnd';
  // 测试是否大小写敏感
  TestIgnoreCase = True;
  // 表示没有偏移量,临时使用
  NOMOVE = -1;

  // 错误提示
  StrCallError = '执行失败';
  StrTTValueError = 'TokenTag Value 不正确';
  StrValueError = '值不正确';
  StrPositionError = 'Position 不正确';
  StrBoundsOut = '越界';

type
  [TestFixture('Test', '测试')]
  [IgnoreMemoryLeaks(False)]
  TTMDStringTokenTagTest = class(TObject)
  private
    FTT: IStringTokenTag;
    procedure CheckCallResult(const aCondition: Boolean);
    procedure CheckPosition(const aMustPosition: Integer);
    procedure CheckTTValue(const aMustValue: string; const aIgnoreCase: Boolean = False);
    procedure CheckValue<T>(const aValue, aMustValue: T);
    procedure MoveTo(const aOffset: Integer);
    procedure Status(const aStr: string);
  public
    ///
    /// Go
    ///

    [Test]
    procedure GoFirst;
    [Test]
    procedure GoLast;

    ///
    /// Is
    ///
    [TestCaseAttribute('IsEof 1', 'false,18')]
    [TestCaseAttribute('IsEof 2', 'true,28')]
    procedure IsEof(const aMustValue: Boolean; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('IsFirst 1', 'true,1')]
    [TestCaseAttribute('IsFirst 2', 'false,11')]
    procedure IsFirst(const aMustValue: Boolean; const aOffset: Integer = NOMOVE);

    ///
    /// Move
    ///
    [TestCaseAttribute('Move 1', '18,19,1')]
    [TestCaseAttribute('Move 2', '1,3,2')]
    procedure Move(const aMoveCount, aMustPosition: integer; const aOffset: integer = NOMOVE);
    [TestCaseAttribute('NextChar 1', 'D,10')]
    [TestCaseAttribute('NextChar 2', 'G,15')]
    [TestCaseAttribute('NextChar 3', ';,18')]
    [TestCaseAttribute('NextChar 4', ' ,19')]
    [TestCaseAttribute('NextChar 5', ' ,-1')]
    [TestCaseAttribute('NextChar 6', ' ,-1')]
    [TestCaseAttribute('NextChar 7', 'T,-1')]
    procedure NextChar(const aMustValue: Char; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('PrevChar 1', '@,1')]
    [TestCaseAttribute('PrevChar 2', '@,10')]
    [TestCaseAttribute('PrevChar 3', 'B,6')]
    [TestCaseAttribute('PrevChar 4', 'A,5')]
    [TestCaseAttribute('PrevChar 5', 'D,-1')]
    procedure PrevChar(const aMustValue: Char; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('NextSkipBlankSpace 1', '0,23,20')]
    [TestCaseAttribute('NextSkipBlankSpace 2', '0,23,21')]
    procedure NextSkipBlankSpace(const aMaxSkipChars, aMustPosition: integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('PrevSkipBlankSpace 1', '4,24,24')]
    [TestCaseAttribute('PrevSkipBlankSpace 2', '12,23,23')]
    procedure PrevSkipBlankSpace(const aMaxSkipChars, aMustPosition: integer; const aOffset: Integer = NOMOVE);

    ///
    /// CurrentChar
    ///
    [TestCase('CurrentChar 1', 'C,7')]
    [TestCase('CurrentChar 2', ';,19')]
    procedure CurrentChar(const aMustValue: Char; const aOffset: Integer = NOMOVE);

    ///
    /// Value
    ///
    [TestCaseAttribute('GetStringFromFirst 1', '@CDAB@CD@CD@,12')]
    procedure GetStringFromFirst(const aMustValue: string; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GetStringToEof 1', '@EF@GH@;   TheEnd,-1')]
    [TestCaseAttribute('GetStringToEof 2', '@CDAB@CD@CD@EF@GH@;   TheEnd,1')]
    [TestCaseAttribute('GetStringToEof 3', 'TheEnd,23')]
    [TestCaseAttribute('GetStringToEof 4', 'nd,27')]
    procedure GetStringToEof(const aMustValue: string; const aOffset: Integer = NOMOVE);

    ///
    /// Token
    ///

    // Exists

    [TestCase('ExistsNextToken 1', 'D,1')]
    [TestCase('ExistsNextToken 2', '@EF,12')]
    procedure ExistsNextToken(const aWord: string; const aOffset: Integer = NOMOVE);
    [TestCase('ExistsPrevToken 1', '@,19')]
    [TestCase('ExistsPrevToken 2', '@,2')]
    procedure ExistsPrevToken(const aWord: string; const aOffset: Integer = NOMOVE);

    // Go

    [TestCaseAttribute('GoNextToken 1', '@,2,1')]
    [TestCaseAttribute('GoNextToken 2', ' ,21,1')]
    [TestCaseAttribute('GoNextToken 3', 'End,28,1')]
    procedure GoNextToken(const aWord: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GoPreToken 1', 'The,22,-1')]
    [TestCaseAttribute('GoPreToken 2', '   ,19,-1')]
    [TestCaseAttribute('GoPreToken 3', '@EF,11,-1')]
    [TestCaseAttribute('GoPreToken 4', '@,8,-1')]
    [TestCaseAttribute('GoPreToken 5', '@,5,-1')]
    [TestCaseAttribute('GoPreToken 6', 'AB,3,-1')]
    [TestCaseAttribute('GoPreToken 7', '@,1,-1')]
    [TestCaseAttribute('GoPreToken 8', '@CD,1,3')]
    procedure GoPrevToken(const aWord: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GoFirstToken 1', 'AB,6')]
    [TestCaseAttribute('GoFirstToken 2', 'AB@,7')]
    [TestCaseAttribute('GoFirstToken 3', 'AB@CD,9')]
    [TestCaseAttribute('GoFirstToken 4', 'TheEnd,28')]
    procedure GoFirstToken(const aWord: string; const aMustPosition: Integer);
    [TestCaseAttribute('GoLastToken 1', 'DAB,6,1')]
    [TestCaseAttribute('GoLastToken 2', '@CD,12,-1')]
    [TestCaseAttribute('GoLastToken 3', '@,19,-1')]
    [TestCaseAttribute('GoLastToken 4', '@,19,1')]
    [TestCaseAttribute('GoLastToken 5', 'd,28,1')]
    procedure GoLastToken(const aWord: string; const aMustPosition: Integer; const aOffset: integer = NOMOVE);


    // Get
    [TestCaseAttribute('GetFirstToken 1', '@,,2')]
    [TestCaseAttribute('GetFirstToken 2', 'DAB,@C,6')]
    [TestCaseAttribute('GetFirstToken 3', ';,@CDAB@CD@CD@EF@GH@,20')]
    procedure GetFirstToken(const aWord: string; const aMustValue: string; const aMustPosition: integer);
    [TestCaseAttribute('GetLastToken 1', '@,@CDAB@CD@CD@EF@GH,19,1')]
    [TestCaseAttribute('GetLastToken 2', ' ,;  ,23,-1')]
    [TestCaseAttribute('GetLastToken 3', '@CD,@CDAB@CD,12,1')]
    procedure GetLastToken(const aWord, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GetNextToken 1', 'AB,@CD,6,1')]
    [TestCaseAttribute('GetNextToken 2', 'CD,@,9,-1')]
    [TestCaseAttribute('GetNextToken 3', '@E,@CD,14,-1')]
    [TestCaseAttribute('GetNextToken 4', ' ,F@GH@;,21,-1')]
    [TestCaseAttribute('GetNextToken 5', ' ,,21,20')]
    [TestCaseAttribute('GetNextToken 6', 'End,  The,28,-1')]
    procedure GetNextToken(const aWord, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GetPrevToken 1', '@CD,@EF@GH@;,8,19')]
    [TestCaseAttribute('GetPrevToken 2', '@CD,,5,-1')]
    [TestCaseAttribute('GetPrevToken 3', '@,CDAB,1,-1')]
    procedure GetPrevToken(const aWord, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);

    ///
    /// Tag
    ///

    // Exists
    [TestCaseAttribute('ExistsNextTag 1', 'CD@,@;,1')]
    [TestCaseAttribute('ExistsNextTag 2', 'CD@,@;,10')]
    procedure ExistsNextTag(const aLeftTag, aRightTag: string; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('ExistsPrevTag 1', '@,@,6')]
    [TestCaseAttribute('ExistsPrevTag 2', '@,@,9')]
    [TestCaseAttribute('ExistsPrevTag 3', '@,@,12')]
    [TestCaseAttribute('ExistsPrevTag 4', '; ,  The,28')]
    procedure ExistsPrevTag(const aLeftTag, aRightTag: string; const aOffset: Integer = NOMOVE);

    // Go
    [TestCaseAttribute('GoNextTag 1', 'D,B,6,1')]
    [TestCaseAttribute('GoNextTag 2', 'C,@,10,-1')]
    [TestCaseAttribute('GoNextTag 3', 'C,EF,15,-1')]
    [TestCaseAttribute('GoNextTag 4', '@;,The,26,-1')]
    procedure GoNextTag(const aLeftTag, aRightTag: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GoPrevTag 1', 'The,End,22,28')]
    [TestCaseAttribute('GoPrevTag 2', '@, ,17,-1')]
    [TestCaseAttribute('GoPrevTag 3', '@,@,11,-1')]
    [TestCaseAttribute('GoPrevTag 4', 'AB,@,3,-1')]
    [TestCaseAttribute('GoPrevTag 5', '@,C,1,-1')]
    procedure GoPrevTag(const aLeftTag, aRightTag: string; const aMustPosition: integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GoFirstTag 1', '@,@,7')]
    [TestCaseAttribute('GoFirstTag 2', 'CD,CD,9')]
    [TestCaseAttribute('GoFirstTag 3', '@CD,@CD,9')]
    [TestCaseAttribute('GoFirstTag 4', 'AB@,@,10')]
    procedure GoFirstTag(const aLeftTag, aRightTag: string; const aMustPosition: Integer);
    [TestCaseAttribute('GoLastTag 1', '@,@,19,1')]
    [TestCaseAttribute('GoLastTag 2', 'D,d,28,1')]
    [TestCaseAttribute('GoLastTag 3', '@,@,19,1')]
    [TestCaseAttribute('GoLastTag 4', 'e,d,28,-1')]
    [TestCaseAttribute('GoLastTag 5', '@,E,27,1')]
    procedure GoLastTag(const aLeftTag, aRightTag: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);

    //Get
    [TestCaseAttribute('GetNextTag 1', '@,C,,3,1')]
    [TestCaseAttribute('GetNextTag 2', 'AB,CD,@,9,-1')]
    [TestCaseAttribute('GetNextTag 3', '@,EF,CD@,15,-1')]
    [TestCaseAttribute('GetNextTag 4', '@,@,GH,19,-1')]
    [TestCaseAttribute('GetNextTag 5', '; ,End,  The,28,-1')]
    procedure GetNextTag(const aLeftTag, aRightTag, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GetPrevTag 1', 'E,d,n,25,28')]
    [TestCaseAttribute('GetPrevTag 2', 'T,e,h,22,-1')]
    [TestCaseAttribute('GetPrevTag 3', ';, ,  ,18,-1')]
    [TestCaseAttribute('GetPrevTag 4', '@,@,GH,14,-1')]
    [TestCaseAttribute('GetPrevTag 5', '@CD,@,,8,-1')]
    [TestCaseAttribute('GetPrevTag 6', '@,B,CDA,1,-1')]
    procedure GetPrevTag(const aLeftTag, aRightTag, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [TestCaseAttribute('GetFirstTag 1', '@,@,CDAB,7')]
    [TestCaseAttribute('GetFirstTag 2', '@C,@C,DAB,8')]
    [TestCaseAttribute('GetFirstTag 3', 'D@,@,CD,13')]
    [TestCaseAttribute('GetFirstTag 4', 'E,E,F@GH@;   Th,26')]
    procedure GetFirstTag(const aLeftTag, aRightTag: string; const aMustValue: string; const aMustPosition: Integer);
    [TestCaseAttribute('GetLastTag 1', '@,@,GH,19,1')]
    [TestCaseAttribute('GetLastTag 2', 'e,E,,27,-1')]
    [TestCaseAttribute('GetLastTag 3', 'The,End,,28,1')]
    procedure GetLastTag(const aLeftTag, aRightTag, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
    [SetupFixture]
    procedure Setup;
  published
  end;

implementation

uses
  System.Classes, System.SysUtils, Vcl.Dialogs;

procedure TTMDStringTokenTagTest.CheckCallResult(const aCondition: Boolean);
begin
  Status(Concat('Call Result: ', BoolToStr(aCondition, True)));
  Assert.IsTrue(aCondition, StrCallError);

end;

procedure TTMDStringTokenTagTest.CheckPosition(const aMustPosition: Integer);
begin
  Status(Concat('Position: ', IntToStr(FTT.Position), ' MustPosition: ', IntToStr(aMustPosition)));
  Assert.AreEqual(FTT.Position, aMustPosition, Concat(StrPositionError, ' [ TokenTag 值为: ', IntToStr(FTT.Position), ' 你的预期值为: ', IntToStr(aMustPosition), ' ]'));

end;

procedure TTMDStringTokenTagTest.CheckTTValue(const aMustValue: string; const aIgnoreCase: Boolean = False);
begin
  Status(Concat('Value: ', FTT.Value, ' MustValue: ', aMustValue));
  Assert.AreEqual(FTT.Value, aMustValue, aIgnoreCase, Concat(StrTTValueError, ' [ TokenTag 值为: ', FTT.Value, ' 你的预期值为: ', aMustValue, ' ]'));

end;

procedure TTMDStringTokenTagTest.CheckValue<T>(const aValue, aMustValue: T);
begin
  Assert.AreEqual(aValue, aMustValue, StrValueError);
end;

procedure TTMDStringTokenTagTest.CurrentChar(const aMustValue: Char; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckValue(FTT.CurrentChar, aMustValue);
end;

procedure TTMDStringTokenTagTest.ExistsNextTag(const aLeftTag, aRightTag: string; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.ExistsTag(aLeftTag, aRightTag, Next));
end;

procedure TTMDStringTokenTagTest.ExistsNextToken(const aWord: string; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.ExistsToken(aWord, Next));
end;

procedure TTMDStringTokenTagTest.ExistsPrevTag(const aLeftTag, aRightTag: string; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.ExistsTag(aLeftTag, aRightTag, Prev));
end;

procedure TTMDStringTokenTagTest.ExistsPrevToken(const aWord: string; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.ExistsToken(aWord, Prev));
end;

procedure TTMDStringTokenTagTest.GetFirstTag(const aLeftTag, aRightTag, aMustValue: string; const aMustPosition: Integer);
begin
  CheckCallResult(FTT.GetFirstTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetFirstToken(const aWord, aMustValue: string; const aMustPosition: integer);
begin
  CheckCallResult(FTT.GetFirstToken(aWord));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetLastTag(const aLeftTag, aRightTag, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetLastTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetLastToken(const aWord, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetLastToken(aWord));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetNextTag(const aLeftTag, aRightTag, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetNextTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetNextToken(const aWord, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetNextToken(aWord));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetPrevTag(const aLeftTag, aRightTag, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetPrevTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetPrevToken(const aWord, aMustValue: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetPrevToken(aWord));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GetStringFromFirst(const aMustValue: string; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetStringFromFirst);
  CheckTTValue(aMustValue);
end;

procedure TTMDStringTokenTagTest.GetStringToEof(const aMustValue: string; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GetStringToEof);
  CheckTTValue(aMustValue);
end;

procedure TTMDStringTokenTagTest.GoFirst;
begin
  FTT.GoFirst;
  CheckPosition(1);
end;

procedure TTMDStringTokenTagTest.GoFirstTag(const aLeftTag, aRightTag: string; const aMustPosition: Integer);
begin
  CheckCallResult(FTT.GoFirstTag(aLeftTag, aRightTag));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GoFirstToken(const aWord: string; const aMustPosition: Integer);
begin
  CheckCallResult(FTT.GoFirstToken(aWord));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GoLast;
begin
  FTT.GoLast;
  CheckPosition(FTT.SourceLength);
end;

procedure TTMDStringTokenTagTest.GoLastTag(const aLeftTag, aRightTag: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GoLastTag(aLeftTag, aRightTag));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GoLastToken(const aWord: string; const aMustPosition: Integer; const aOffset: integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GoLastToken(aWord));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GoNextTag(const aLeftTag, aRightTag: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GoNextTag(aLeftTag, aRightTag));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GoNextToken(const aWord: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GoNextToken(aWord));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GoPrevTag(const aLeftTag, aRightTag: string; const aMustPosition: integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GoPrevTag(aLeftTag, aRightTag));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.GoPrevToken(const aWord: string; const aMustPosition: Integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.GoPrevToken(aWord));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.IsEof(const aMustValue: Boolean; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckValue(FTT.IsEof, aMustValue);
end;

procedure TTMDStringTokenTagTest.IsFirst(const aMustValue: Boolean; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckValue(FTT.IsFirst, aMustValue);
end;

procedure TTMDStringTokenTagTest.Move(const aMoveCount, aMustPosition: integer; const aOffset: integer = NOMOVE);
begin
  MoveTo(aOffset);
 // if not (aOffset = NOMOVE) then
 // begin
  CheckCallResult(FTT.Move(aMoveCount));
 // end;
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.MoveTo(const aOffset: Integer);
begin
  // 不知道别的方法,暂时用这个数来表示不移动
  if not (aOffset = NOMOVE) then
  begin
    // 右越界
    Assert.IsTrue(aOffset <= FTT.SourceLength, StrBoundsOut);
    // 左越界
    Assert.IsTrue(aOffset >= 0, StrBoundsOut);

    FTT.Position := aOffset;
  end;

end;

procedure TTMDStringTokenTagTest.NextChar(const aMustValue: Char; const aOffset: Integer = NOMOVE);
var
  LCurrentChar: Char;
begin
  MoveTo(aOffset);
  LCurrentChar := FTT.NextChar;
  Status(LCurrentChar + ' Position: ' + inttostr(FTT.Position));
  CheckValue(LCurrentChar, aMustValue);
end;

procedure TTMDStringTokenTagTest.PrevChar(const aMustValue: Char; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckValue(FTT.PrevChar, aMustValue);
end;

procedure TTMDStringTokenTagTest.Setup;
begin
  FTT := TTMDStringTokenTag.Create(TestSource, TestIgnoreCase);
  Status('初始化');
  Status('-------- TestSource --------');
  Status(TestSource);
  Status('--------            --------');
  Status(Concat('Length: ', IntToStr(FTT.SourceLength)));
  Status(Concat('IgnoreCase: ', booltostr(FTT.IgnoreCase, True)));

end;

procedure TTMDStringTokenTagTest.NextSkipBlankSpace(const aMaxSkipChars, aMustPosition: integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.NextSkipBlankSpace(aMaxSkipChars));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.PrevSkipBlankSpace(const aMaxSkipChars, aMustPosition: integer; const aOffset: Integer = NOMOVE);
begin
  MoveTo(aOffset);
  CheckCallResult(FTT.PrevSkipBlankSpace(aMaxSkipChars));
  CheckPosition(aMustPosition);
end;

procedure TTMDStringTokenTagTest.Status(const aStr: string);
begin
  TDUnitX.CurrentRunner.Status(aStr);
end;

initialization
  TDUnitX.RegisterTestFixture(TTMDStringTokenTagTest);

end.

