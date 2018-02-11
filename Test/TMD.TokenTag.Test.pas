unit TMD.TokenTag.Test;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  TMDTokenTag;

const
  // 测试字符串源
  TEST_SOURCE = '@CDAB@CD@CD@EF@GH@;   TheEnd';
  // 测试是否忽略大小写敏感
  TEST_IGNORECASE = True;

  // 错误提示
  STR_CALL_ERROR = '执行失败';
  STR_TTVALUE_ERROR = '获取值与预期不符';
  STR_VALUE_ERROR = '值与预期不符';
  STR_TOKEN_ERROR = '';
  STR_TAG_ERROR = '';
  STR_POSITION_ERROR = 'Position 与预期不符';
  STR_BOUNDS_OUT_RIGHT = '右越界';
  STR_BOUNDS_OUT_LEFT = '左越界';

  // 表示没有偏移量,临时使用
  NOMOVE = 1;

type
  [TestFixture]
  TTestTokenTag = class(TObject)
  private
    FTT: IStringTokenTag;
    procedure CheckCallResult(const aCondition: Boolean);
    procedure CheckPosition(const aMustPosition: Integer);
    procedure CheckTTValue(const aMustValue: string; const aIgnoreCase: Boolean = False);
    procedure CheckValue<T>(const aValue, aMustValue: T);
    procedure MovePosition(const aPosition: Integer);
    procedure Status(const aStr: string);
  public

    ///
    /// CurrentChar
    ///
    [TestCase('CurrentChar 1', '@,1')]
    [TestCase('CurrentChar 2', 'C,2')]
    [TestCase('CurrentChar 3', 'D,3')]
    [TestCase('CurrentChar 4', 'A,4')]
    [TestCase('CurrentChar 5', 'B,5')]
    [TestCase('CurrentChar 6', '@,6')]
    [TestCase('CurrentChar 7', 'C,7')]
    [TestCase('CurrentChar 8', 'D,8')]
    [TestCase('CurrentChar 9', '@,9')]
    [TestCase('CurrentChar 10', 'C,10')]
    [TestCase('CurrentChar 11', 'D,11')]
    [TestCase('CurrentChar 12', '@,12')]
    [TestCase('CurrentChar 13', 'E,13')]
    [TestCase('CurrentChar 14', 'F,14')]
    [TestCase('CurrentChar 15', '@,15')]
    [TestCase('CurrentChar 16', 'G,16')]
    [TestCase('CurrentChar 17', 'H,17')]
    [TestCase('CurrentChar 18', '@,18')]
    [TestCase('CurrentChar 19', ';,19')]
    [TestCase('CurrentChar 20', ' ,20')]
    [TestCase('CurrentChar 21', ' ,21')]
    [TestCase('CurrentChar 22', ' ,22')]
    [TestCase('CurrentChar 23', 'T,23')]
    [TestCase('CurrentChar 24', 'h,24')]
    [TestCase('CurrentChar 25', 'e,25')]
    [TestCase('CurrentChar 26', 'E,26')]
    [TestCase('CurrentChar 27', 'n,27')]
    [TestCase('CurrentChar 28', 'd,28')]
    procedure CurrentChar(const aMustValue: Char; const aInitPosition: Integer = NOMOVE);

    ///
    ///  ExistsNextTag
    ///
    [TestCaseAttribute('ExistsNextTag 1', 'CD@,@;,1')]
    [TestCaseAttribute('ExistsNextTag 2', 'CD@,@;,10')]
    procedure ExistsNextTag(const aLeftTag, aRightTag: string; const
      aInitPosition: Integer = NOMOVE);

    ///
    /// ExistsNextToken
    ///

    [TestCase('ExistsNextToken 1', 'D,1')]
    [TestCase('ExistsNextToken 2', '@EF,12')]
    [TestCase('ExistsNextToken 3', 'End,26')]
    [TestCase('ExistsNextToken 4', 'd,27')]
    procedure ExistsNextToken(const aWord: string; const aInitPosition: Integer
      = NOMOVE);

    ///
    ///  ExistsPrevTag
    ///
    [TestCaseAttribute('ExistsPrevTag 1', '@,@,6')]
    [TestCaseAttribute('ExistsPrevTag 2', '@,@,9')]
    [TestCaseAttribute('ExistsPrevTag 3', '@,@,12')]
    [TestCaseAttribute('ExistsPrevTag 4', '; ,  The,28')]
    procedure ExistsPrevTag(const aLeftTag, aRightTag: string; const
      aInitPosition: Integer = NOMOVE);

    ///
    ///  GetFirstTag
    ///
    [TestCaseAttribute('GetFirstTag 1', '@,@,CDAB,7')]
    [TestCaseAttribute('GetFirstTag 2', '@C,@C,DAB,8')]
    [TestCaseAttribute('GetFirstTag 3', 'D@,@,CD,13')]
    [TestCaseAttribute('GetFirstTag 4', 'E,E,F@GH@;   Th,26')]
    procedure GetFirstTag(const aLeftTag, aRightTag: string; const aMustValue:
      string; const aMustPosition: Integer);

    ///
    ///  GetFirstToken
    ///
    [TestCaseAttribute('GetFirstToken 1', '@,true,,2')]
    [TestCaseAttribute('GetFirstToken 2', '@,false,,1')]
    [TestCaseAttribute('GetFirstToken 3', 'DAB,true,@C,6')]
    [TestCaseAttribute('GetFirstToken 4', 'DAB,false,@C,3')]
    [TestCaseAttribute('GetFirstToken 5', ';,true,@CDAB@CD@CD@EF@GH@,20')]
    [TestCaseAttribute('GetFirstToken 6', ';,false,@CDAB@CD@CD@EF@GH@,19')]
    procedure GetFirstToken(const aWord: string; const aWithSkipToken: Boolean;
      const aMustValue: string; const aMustPosition: Integer);

    ///
    ///  GetLastTag
    ///
    [TestCaseAttribute('GetLastTag 1', '@,@,GH,19,1')]
    [TestCaseAttribute('GetLastTag 2', 'e,E,,27,19')]
    [TestCaseAttribute('GetLastTag 3', 'The,End,,28,1')]
    [TestCaseAttribute('GetLastTag 3', 'n,d,,28,27')]
    [TestCaseAttribute('GetLastTag 3', '@C,DA,,5,1')]
    procedure GetLastTag(const aLeftTag, aRightTag, aMustValue: string; const
      aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GetLastToken
    ///
    [TestCaseAttribute('GetLastToken 1', '@,true,true,@CDAB@CD@CD@EF@GH,19,1')]
    [TestCaseAttribute('GetLastToken 2', '@CD,true,true,@CDAB@CD,12,1')]
    [TestCaseAttribute('GetLastToken 3', '@,true,true,@CD@CD@EF@GH,19,6')]
    [TestCaseAttribute('GetLastToken 4', '@,true,false,@CD@CD@EF@GH,18,6')]
    [TestCaseAttribute('GetLastToken 5', '@CDAB,true,true,,6,1')]
    [TestCaseAttribute('GetLastToken 6', '@CDAB,true,false,,1,1')]
    [TestCaseAttribute('GetLastToken 7', 'End,true,false,,26,26')]
    [TestCaseAttribute('GetLastToken 8', 'End,true,true,,28,26')]
    [TestCaseAttribute('GetLastToken 8', 'End,false,true,,28,28')]
    procedure GetLastToken(const aWord: string; const aStartWithCurrent,
      aWithSkipToken: Boolean; const aMustValue: string; const aMustPosition:
      Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GetNextTag
    ///
    [TestCaseAttribute('GetNextTag 1', '@,C,,3,1')]
    [TestCaseAttribute('GetNextTag 2', 'AB,CD,@,9,3')]
    [TestCaseAttribute('GetNextTag 3', '@,EF,CD@,15,9')]
    [TestCaseAttribute('GetNextTag 4', '@,@,GH,19,15')]
    [TestCaseAttribute('GetNextTag 5', '; ,End,  The,28,19')]
    [TestCaseAttribute('GetNextTag 5', '@,End,CDAB@CD@CD@EF@GH@;   The,28,1')]
    procedure GetNextTag(const aLeftTag, aRightTag, aMustValue: string; const
      aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GetNextToken
    ///
    [TestCaseAttribute('GetNextToken 1', 'AB,true,@CD,6,1')]
    [TestCaseAttribute('GetNextToken 2', 'CD,true,@,9,6')]
    [TestCaseAttribute('GetNextToken 3', '@E,true,@CD,14,9')]
    [TestCaseAttribute('GetNextToken 4', ' ,true,F@GH@;,21,14')]
    [TestCaseAttribute('GetNextToken 5', ' ,true,,21,20')]
    [TestCaseAttribute('GetNextToken 6', 'DA,false,@C,3,1')]
    [TestCaseAttribute('GetNextToken 7', 'd,false,n,28,27')]
    [TestCaseAttribute('GetNextToken 8', '@,false,,1,1')]
    procedure GetNextToken(const aWord: string; const aWithSkipToken: Boolean;
      const aMustValue: string; const aMustPosition: Integer; const
      aInitPosition: Integer = NOMOVE);

    ///
    ///  GetPrevTag
    ///
    [TestCaseAttribute('GetPrevTag 1', 'E,d,n,25,28')]
    [TestCaseAttribute('GetPrevTag 2', 'T,e,h,22,25')]
    [TestCaseAttribute('GetPrevTag 3', ';, ,  ,18,22')]
    [TestCaseAttribute('GetPrevTag 4', '@,@,GH,14,18')]
    [TestCaseAttribute('GetPrevTag 5', '@CD,@,,8,14')]
    [TestCaseAttribute('GetPrevTag 6', '@,B,CDA,1,8')]
    [TestCaseAttribute('GetPrevTag 6', '@,C,,1,3')]
    [TestCaseAttribute('GetPrevTag 6', '@C,CD,DAB@,1,8')]
    procedure GetPrevTag(const aLeftTag, aRightTag, aMustValue: string; const
      aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GetPrevToken
    ///
    [TestCaseAttribute('GetPrevToken 1', '@CD,true,@EF@GH@;,8,19')]
    [TestCaseAttribute('GetPrevToken 2', '@CD,false,@EF@GH@;,11,19')]
    [TestCaseAttribute('GetPrevToken 3', '@CDA,true,B@CD,1,8')]
    [TestCaseAttribute('GetPrevToken 4', '@CDA,false,B@CD,4,8')]
    [TestCaseAttribute('GetPrevToken 5', 'n,false,d,27,28')]
    [TestCaseAttribute('GetPrevToken 6', 'd,false,,28,28')]
    procedure GetPrevToken(const aWord: string; const aWithSkipToken: Boolean;
      const aMustValue: string; const aMustPosition: Integer; const
      aInitPosition: Integer = NOMOVE);

    ///
    /// Value
    ///
    [TestCaseAttribute('GetStringFromFirst 1', '@CDAB@CD@CD@,12')]
    [TestCaseAttribute('GetStringFromFirst 2', '@,1')]
    [TestCaseAttribute('GetStringFromFirst 3', '@C,2')]
    [TestCaseAttribute('GetStringFromFirst 4', '@CD,3')]
    [TestCaseAttribute('GetStringFromFirst 5', '@CDAB@CD@CD@EF@GH@;   TheEnd,28')]
    procedure GetStringFromFirst(const aMustValue: string; const aInitPosition:
      Integer = NOMOVE);

    ///
    /// GetStringToEof
    ///
    [TestCaseAttribute('GetStringToEof 1', 'End,26')]
    [TestCaseAttribute('GetStringToEof 2', '@CDAB@CD@CD@EF@GH@;   TheEnd,1')]
    [TestCaseAttribute('GetStringToEof 3', 'TheEnd,23')]
    [TestCaseAttribute('GetStringToEof 4', 'nd,27')]
    [TestCaseAttribute('GetStringToEof 5', 'd,28')]
    procedure GetStringToEof(const aMustValue: string; const aInitPosition:
      Integer = NOMOVE);
    ///
    /// Go
    ///

    [Test]
    procedure GoFirst;

    ///
    ///  GoFirstTag
    ///
    [TestCaseAttribute('GoFirstTag 1', '@,@,7,28')]
    [TestCaseAttribute('GoFirstTag 2', 'CD,CD,9,1')]
    [TestCaseAttribute('GoFirstTag 3', '@CD,@CD,9,2')]
    [TestCaseAttribute('GoFirstTag 4', 'AB@,@,10,8')]
    procedure GoFirstTag(const aLeftTag, aRightTag: string; const aMustPosition:
      Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GoFirstToken
    ///
    [TestCaseAttribute('GoFirstToken 1', 'AB,true,6')]
    [TestCaseAttribute('GoFirstToken 2', 'AB,false,4')]
    [TestCaseAttribute('GoFirstToken 3', 'AB@,true,7')]
    [TestCaseAttribute('GoFirstToken 4', 'AB@,false,4')]
    [TestCaseAttribute('GoFirstToken 5', 'AB@CD,true,9')]
    [TestCaseAttribute('GoFirstToken 6', 'AB@CD,false,4')]
    [TestCaseAttribute('GoFirstToken 7', 'TheEnd,true,28')]
    [TestCaseAttribute('GoFirstToken 8', 'TheEnd,false,23')]
    procedure GoFirstToken(const aWord: string; const aWithSkipToken: Boolean;
      const aMustPosition: Integer);

    ///
    ///  GoLastTag
    ///
    [TestCaseAttribute('GoLastTag 1', '@,@,true,19,1')]
    [TestCaseAttribute('GoLastTag 2', 'D,d,true,28,1')]
    [TestCaseAttribute('GoLastTag 3', '@,@,true,19,1')]
    [TestCaseAttribute('GoLastTag 4', 'e,d,true,28,19')]
    [TestCaseAttribute('GoLastTag 5', '@,E,true,27,1')]
    [TestCaseAttribute('GoLastTag 6', '@C,@,true,19,1')]
    [TestCaseAttribute('GoLastTag 6', '@C,@,false,19,20')]
    [TestCaseAttribute('GoLastTag 6', '@C,@,false,19,20')]
    procedure GoLastTag(const aLeftTag, aRightTag: string; const
      aStartWithCurrent: Boolean; const aMustPosition: Integer; const
      aInitPosition: Integer = NOMOVE);

    ///
    ///  GoLastToken
    ///
    [TestCaseAttribute('GoLastToken 1', 'DAB,true,true,6,1')]
    [TestCaseAttribute('GoLastToken 2', '@CD,true,true,12,1')]
    [TestCaseAttribute('GoLastToken 3', '@,true,true,19,1')]
    [TestCaseAttribute('GoLastToken 4', '@,true,true,19,1')]
    [TestCaseAttribute('GoLastToken 5', 'd,true,true,28,1')]
    [TestCaseAttribute('GoLastToken 6', '@CD@C,true,true,11,6')]
    [TestCaseAttribute('GoLastToken 7', '@CD@C,true,false,6,6')]
    [TestCaseAttribute('GoLastToken 8', '@CDA,true,false,1,1')]
    [TestCaseAttribute('GoLastToken 9', '@CDA,true,true,5,1')]
    [TestCaseAttribute('GoLastToken 10', 'End,true,true,28,1')]
    [TestCaseAttribute('GoLastToken 11', 'End,true,true,28,26')]
    [TestCaseAttribute('GoLastToken 12', 'End,true,false,26,1')]
    [TestCaseAttribute('GoLastToken 13', 'End,true,false,26,26')]
    [TestCaseAttribute('GoLastToken 14', 'End,false,false,26,28')]
    procedure GoLastToken(const aWord: string; const aStartWithCurrent,
      aWithSkipToken: Boolean; const aMustPosition: Integer; const aInitPosition:
      Integer = NOMOVE);

    ///
    ///  GoNextTag
    ///
    [TestCaseAttribute('GoNextTag 1', 'D,B,6,1')]
    [TestCaseAttribute('GoNextTag 2', 'C,@,10,6')]
    [TestCaseAttribute('GoNextTag 3', 'C,EF,15,10')]
    [TestCaseAttribute('GoNextTag 4', '@;,The,26,15')]
    [TestCaseAttribute('GoNextTag 5', 'D,C,11,8')]
    [TestCaseAttribute('GoNextTag 5', '@,T,24,1')]
    procedure GoNextTag(const aLeftTag, aRightTag: string; const aMustPosition:
      Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GoNextToken
    ///
    [TestCaseAttribute('GoNextToken 1', '@,true,2,1')]
    [TestCaseAttribute('GoNextToken 2', '@,false,1,1')]
    [TestCaseAttribute('GoNextToken 3', ' ,true,21,1')]
    [TestCaseAttribute('GoNextToken 4', 'End,true,28,1')]
    [TestCaseAttribute('GoNextToken 5', 'D,true,12,11')]
    [TestCaseAttribute('GoNextToken 6', 'D,false,11,11')]
    procedure GoNextToken(const aWord: string; const aWithSkipToken: Boolean;
      const aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GoPrevTag
    ///
    [TestCaseAttribute('GoPrevTag 1', 'The,End,22,28')]
    [TestCaseAttribute('GoPrevTag 2', '@, ,17,22')]
    [TestCaseAttribute('GoPrevTag 3', '@,@,11,17')]
    [TestCaseAttribute('GoPrevTag 4', 'AB,@,3,11')]
    [TestCaseAttribute('GoPrevTag 5', '@,D,1,3')]
    [TestCaseAttribute('GoPrevTag 5', '@C,D,1,3')]
    [TestCaseAttribute('GoPrevTag 5', '@,C,1,3')]
    [TestCaseAttribute('GoPrevTag 5', '@,C,5,7')]
    procedure GoPrevTag(const aLeftTag, aRightTag: string; const aMustPosition:
      Integer; const aInitPosition: Integer = NOMOVE);

    ///
    ///  GoPrevToken
    ///
    [TestCaseAttribute('GoPrevToken 1', 'The,true,22,28')]
    [TestCaseAttribute('GoPrevToken 2', 'The,false,25,28')]
    [TestCaseAttribute('GoPrevToken 3', '   ,true,19,28')]
    [TestCaseAttribute('GoPrevToken 4', '   ,false,22,28')]
    [TestCaseAttribute('GoPrevToken 5', '@EF,true,11,20')]
    [TestCaseAttribute('GoPrevToken 6', '@EF,false,14,20')]
    [TestCaseAttribute('GoPrevToken 7', '@,true,8,9')]
    [TestCaseAttribute('GoPrevToken 8', '@,false,9,9')]
    [TestCaseAttribute('GoPrevToken 9', '@,true,1,2')]
    [TestCaseAttribute('GoPrevToken 10', '@,false,1,2')]
    [TestCaseAttribute('GoPrevToken 11', '@CD,true,1,3')]
    [TestCaseAttribute('GoPrevToken 12', '@CD,false,3,3')]
    [TestCaseAttribute('GoPrevToken 13', 'AB,true,3,28')]
    [TestCaseAttribute('GoPrevToken 14', 'AB,false,5,28')]
    [TestCaseAttribute('GoPrevToken 15', '@,true,17,28')]
    [TestCaseAttribute('GoPrevToken 16', '@,false,18,28')]
    procedure GoPrevToken(const aWord: string; const aWithSkipToken: Boolean;
      const aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);

    ///
    /// MoveNext
    ///
    [TestCaseAttribute('MoveNext 1', '18,19,1')]
    [TestCaseAttribute('MoveNext 2', '1,3,2')]
    [TestCaseAttribute('MoveNext 3', '1,2,1')]
    [TestCaseAttribute('MoveNext 4', '1,28,27')]
    procedure MoveNext(const aMoveCount, aMustPosition: Integer; const
      aInitPosition: Integer = NOMOVE);

    ///
    ///  MovePrev
    ///
    [TestCaseAttribute('MovePrev 1', '1,1,2')]
    [TestCaseAttribute('MovePrev 2', '2,3,5')]
    procedure MovePrev(const aMoveCount, aMustPosition: Integer; const
      aInitPosition: Integer = NOMOVE);

    ///
    ///  NextChar
    ///
    [TestCaseAttribute('NextChar 1', 'D,10')]
    [TestCaseAttribute('NextChar 2', 'G,15')]
    [TestCaseAttribute('NextChar 3', ';,18')]
    [TestCaseAttribute('NextChar 4', ' ,19')]
    [TestCaseAttribute('NextChar 5', ' ,20')]
    [TestCaseAttribute('NextChar 6', ' ,21')]
    [TestCaseAttribute('NextChar 7', 'T,22')]
    procedure NextChar(const aMustValue: Char; const aInitPosition: Integer = NOMOVE);

    ///
    ///  PrevChar
    ///
    [TestCaseAttribute('PrevChar 1', '@,1')]
    [TestCaseAttribute('PrevChar 2', '@,10')]
    [TestCaseAttribute('PrevChar 3', 'B,6')]
    [TestCaseAttribute('PrevChar 4', 'A,5')]
    [TestCaseAttribute('PrevChar 5', 'D,4')]
    procedure PrevChar(const aMustValue: Char; const aInitPosition: Integer = NOMOVE);
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

procedure TTestTokenTag.CheckCallResult(const aCondition: Boolean);
begin
  Status(Concat('Call Result: ', BoolToStr(aCondition, True)));
  Assert.IsTrue(aCondition, STR_CALL_ERROR);

end;

procedure TTestTokenTag.CheckPosition(const aMustPosition: Integer);
begin
  Status(Concat('Position: ', IntToStr(FTT.Position), ' MustPosition: ',
    IntToStr(aMustPosition)));
  Assert.AreEqual(FTT.Position, aMustPosition, Concat(STR_POSITION_ERROR,
    ' [ 结果值为: ', IntToStr(FTT.Position), ' 你的预期值为: ', IntToStr(aMustPosition), ' ]'));

end;

procedure TTestTokenTag.CheckTTValue(const aMustValue: string; const aIgnoreCase:
  Boolean = False);
begin
  Status(Concat('Value: ', FTT.Value, ' MustValue: ', aMustValue));
  Assert.AreEqual(FTT.Value, aMustValue, aIgnoreCase, Concat(STR_TTVALUE_ERROR,
    ' [ 结果值为: ', FTT.Value, ' 你的预期值为: ', aMustValue, ' ]'));

end;

procedure TTestTokenTag.CheckValue<T>(const aValue, aMustValue: T);
begin
  Assert.AreEqual(aValue, aMustValue, STR_VALUE_ERROR);
end;

procedure TTestTokenTag.CurrentChar(const aMustValue: Char; const aInitPosition:
  Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckValue(FTT.CurrentChar, aMustValue);
end;

procedure TTestTokenTag.ExistsNextTag(const aLeftTag, aRightTag: string; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.ExistsTag(aLeftTag, aRightTag, Next));
end;

procedure TTestTokenTag.ExistsNextToken(const aWord: string; const aInitPosition:
  Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.ExistsToken(aWord, Next));
end;

procedure TTestTokenTag.ExistsPrevTag(const aLeftTag, aRightTag: string; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.ExistsTag(aLeftTag, aRightTag, Prev));
end;

procedure TTestTokenTag.GetFirstTag(const aLeftTag, aRightTag, aMustValue:
  string; const aMustPosition: Integer);
begin
  CheckCallResult(FTT.GetFirstTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetFirstToken(const aWord: string; const aWithSkipToken:
  Boolean; const aMustValue: string; const aMustPosition: Integer);
begin
  CheckCallResult(FTT.GetFirstToken(aWord, aWithSkipToken));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetLastTag(const aLeftTag, aRightTag, aMustValue: string;
  const aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GetLastTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetLastToken(const aWord: string; const
  aStartWithCurrent, aWithSkipToken: Boolean; const aMustValue: string; const
  aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GetLastToken(aWord, aStartWithCurrent, aWithSkipToken));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetNextTag(const aLeftTag, aRightTag, aMustValue: string;
  const aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GetNextTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetNextToken(const aWord: string; const aWithSkipToken:
  Boolean; const aMustValue: string; const aMustPosition: Integer; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GetNextToken(aWord, aWithSkipToken));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetPrevTag(const aLeftTag, aRightTag, aMustValue: string;
  const aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GetPrevTag(aLeftTag, aRightTag));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetPrevToken(const aWord: string; const aWithSkipToken:
  Boolean; const aMustValue: string; const aMustPosition: Integer; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GetPrevToken(aWord, aWithSkipToken));
  CheckTTValue(aMustValue);
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GetStringFromFirst(const aMustValue: string; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  FTT.GetStringFromFirst;
  CheckTTValue(aMustValue);
end;

procedure TTestTokenTag.GetStringToEof(const aMustValue: string; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  FTT.GetStringToEof;
  CheckTTValue(aMustValue);
end;

procedure TTestTokenTag.GoFirst;
begin
  FTT.GoFirst;
  CheckPosition(1);
end;

procedure TTestTokenTag.GoFirstTag(const aLeftTag, aRightTag: string; const
  aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GoFirstTag(aLeftTag, aRightTag));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GoFirstToken(const aWord: string; const aWithSkipToken:
  Boolean; const aMustPosition: Integer);
begin
  CheckCallResult(FTT.GoFirstToken(aWord, aWithSkipToken));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GoLastTag(const aLeftTag, aRightTag: string; const
  aStartWithCurrent: Boolean; const aMustPosition: Integer; const aInitPosition:
  Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GoLastTag(aLeftTag, aRightTag, aStartWithCurrent));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GoLastToken(const aWord: string; const aStartWithCurrent,
  aWithSkipToken: Boolean; const aMustPosition: Integer; const aInitPosition:
  Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GoLastToken(aWord, aStartWithCurrent, aWithSkipToken));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GoNextTag(const aLeftTag, aRightTag: string; const
  aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GoNextTag(aLeftTag, aRightTag));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GoNextToken(const aWord: string; const aWithSkipToken:
  Boolean; const aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GoNextToken(aWord, aWithSkipToken));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GoPrevTag(const aLeftTag, aRightTag: string; const
  aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GoPrevTag(aLeftTag, aRightTag));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.GoPrevToken(const aWord: string; const aWithSkipToken:
  Boolean; const aMustPosition: Integer; const aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.GoPrevToken(aWord, aWithSkipToken));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.MoveNext(const aMoveCount, aMustPosition: Integer; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.Move(aMoveCount, TTMDDirection.Next));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.MovePosition(const aPosition: Integer);
begin
  // 不知道别的方法,暂时用这个数来表示不移动
  if not (aPosition = NOMOVE) then
  begin
    // 右越界
    Assert.IsTrue(aPosition <= FTT.SourceLength, STR_BOUNDS_OUT_RIGHT);
    // 左越界
    Assert.IsTrue(aPosition >= 0, STR_BOUNDS_OUT_LEFT);

    FTT.Position := aPosition;
  end;

end;

procedure TTestTokenTag.MovePrev(const aMoveCount, aMustPosition: Integer; const
  aInitPosition: Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckCallResult(FTT.Move(aMoveCount, TTMDDirection.Prev));
  CheckPosition(aMustPosition);
end;

procedure TTestTokenTag.NextChar(const aMustValue: Char; const aInitPosition:
  Integer = NOMOVE);
var
  LCurrentChar: Char;
begin
  MovePosition(aInitPosition);
  LCurrentChar := FTT.NextChar;
  Status(LCurrentChar + ' Position: ' + IntToStr(FTT.Position));
  CheckValue(LCurrentChar, aMustValue);
end;

procedure TTestTokenTag.PrevChar(const aMustValue: Char; const aInitPosition:
  Integer = NOMOVE);
begin
  MovePosition(aInitPosition);
  CheckValue(FTT.PrevChar, aMustValue);
end;

procedure TTestTokenTag.Setup;
begin
  FTT := TTMDStringTokenTag.Create(TEST_SOURCE, TEST_IGNORECASE);
end;

procedure TTestTokenTag.Status(const aStr: string);
begin
  TDUnitX.CurrentRunner.Status(aStr);
end;

procedure TTestTokenTag.TearDown;
begin
  FTT := nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTokenTag);

end.

