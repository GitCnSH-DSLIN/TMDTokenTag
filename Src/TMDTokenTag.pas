//
//                   _ooOoo_
//                  o8888888o
//                  88" . "88
//                  (| -_- |)
//                  O\  =  /O
//               ____/`---'\____
//             .'  \\|     |//  `.
//            /  \\|||  :  |||//  \
//           /  _||||| -:- |||||-  \
//           |   | \\\  -  /// |   |
//           | \_|  ''\---/''  |   |
//           \  .-\__  `-`  ___/-. /
//         ___`. .'  /--.--\  `. . __
//      ."" '<  `.___\_<|>_/___.'  >'"".
//     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//     \  \ `-.   \_ __\ /__ _/   .-` /  /
//======`-.____`-.___\_____/___.-`____.-'======
//                   `=---='
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//     佛祖保佑       永无BUG     永不修改

///
/// TMDTokenTag
/// 实用文本处理单元,用做解析场合
/// 作者: 推云童子 QQ:179033731
/// 本单元可随意更改,如果发展了新的分支请给我发一份来用用
///

unit TMDTokenTag;

interface

uses
  SysUtils,
  Variants,
  System.Math,
  Classes,
  StrUtils;

const
  STARTPOSITION = 1;
  CHARSIZE = SizeOf(Char);

type
  TCharCompareFun = function(aChar1, aChar2: Char): Boolean;

  TGoTokenFun = function(const aWord: string; const aWithSkipToken: Boolean =
    True): Boolean of object; stdcall;

  TGetTokenFun = TGoTokenFun;

  TGoTagFun = function(const aLeftTag, aRightTag: string): Boolean of object; stdcall;

  TGetTagFun = TGoTagFun;

  ///
  /// 移动方向
  ///
  TTMDDirection = (Prev, Next);

  ///
  /// 接口定义
  ///
  IStringTokenTag = interface
    // 设置字符串源
    function GetSource: string; stdcall;
    procedure SetSource(const Value: string);
    property Source: string read GetSource write SetSource;

    // 获取字符串源长度
    function GetLength: Integer; stdcall;
    property SourceLength: Integer read GetLength;

    // 设置是否大小写敏感
    function GetIgnoreCase: Boolean; stdcall;
    procedure SetIgnoreCase(const Value: Boolean); stdcall;
    property IgnoreCase: Boolean read GetIgnoreCase write SetIgnoreCase;

    // 获取字符串源大小
    function GetSize: Integer; stdcall;
    property Size: Integer read GetSize;

    // 获取值
    function GetValue: string; stdcall;
    property Value: string read GetValue;

    // 设置当前位置
    function GetPosition: Integer; stdcall;
    procedure SetPosition(const Value: Integer); stdcall;
    property Position: Integer read GetPosition write SetPosition;

    // 位置判断 起点和终点
    function IsFirst(): Boolean; stdcall;
    function IsEof: Boolean; stdcall;

    ///
    /// Token
    ///
    // 检测 方向默认向前
    function ExistsToken(const aWord: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;

    // 跳转
    function GoToken(const aWord: string; const aMoveDirection: TTMDDirection =
      Next; const aWithSkipToken: Boolean = True): Boolean; stdcall;
    function GoNextToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GoPrevToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GoFirstToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GoLastToken(const aWord: string; const aStartWithCurrent: Boolean =
      True; const aWithSkipToken: Boolean = True): Boolean; stdcall;

    // 内容
    function GetToken(const aWord: string; const aMoveDirection: TTMDDirection =
      Next; const aWithSkipToken: Boolean = True): Boolean; stdcall;
    function GetNextToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GetPrevToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GetFirstToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GetLastToken(const aWord: string; const aStartWithCurrent: Boolean
      = True; const aWithSkipToken: Boolean = True): Boolean; stdcall;

    ///
    /// Tag
    ///
    // 检测
    function ExistsTag(const aLeftTag, aRightTag: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;

    // Tag 跳转
    function GoTag(const aLeftTag, aRightTag: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;
    function GoNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoLastTag(const aLeftTag, aRightTag: string; const
      aStartWithCurrent: Boolean = True): Boolean; stdcall;
    function GoFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;

    // Tag 内容
    function GetTag(const aLeftTag, aRightTag: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;
    function GetNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetLastTag(const aLeftTag, aRightTag: string; const
      aStartWithCurrent: Boolean = True): Boolean; stdcall;

    // 获取字符串 - 从当前位置直到尾部结束
    procedure GetStringToEof; stdcall;
    // 获取字符串 - 从字符串开始(第一个)到当前位置
    procedure GetStringFromFirst; stdcall;
    // 当前位置的字符
    function CurrentChar: Char; stdcall;
    // 移动位置 +-
    function Move(const aMoveCount: Integer; const aDirection: TTMDDirection =
      Next; const aFarAsPossible: Boolean = True): Boolean; stdcall;
    // 跳转到字符串 头部 或者 尾部
    procedure GoFirst; stdcall;
    procedure GoLast; stdcall;
    // 字符移动控制
    function NextChar: Char; stdcall;
    function PrevChar: Char; stdcall;
    // 跳过指定数量的空白字符
    function NextSkipBlankSpace(const aMaxSkipChars: Integer = 0): Boolean; stdcall;
    function PrevSkipBlankSpace(const aMaxSkipChars: Integer = 0): Boolean; stdcall;
  end;

  ///
  /// 接口实现
  ///
  TTMDStringTokenTag = class(TInterfacedObject, IStringTokenTag)
  strict private
  private
    FIgnoreCase: Boolean;
    FPosition: Integer;
    FSource: string;
    FValue: string;
    function GetGetTagFun(const aMoveDirection: TTMDDirection = Next): TGetTagFun;
    function GetGoTagFun(const aMoveDirection: TTMDDirection = Next): TGoTagFun;
    function GetGetTokenFun(const aMoveDirection: TTMDDirection): TGetTokenFun;
    function GetGoTokenFun(const aMoveDirection: TTMDDirection): TGoTokenFun;
    function GetIgnoreCase: Boolean; stdcall;
    function GetPosition: Integer; stdcall;
    function GetSource: string; stdcall;
    function GetValue: string; stdcall;
    function MoveNext(const aMoveCount: Integer; const aFarAsPossible: Boolean =
      True): Boolean;
    function MovePrev(const aMoveCount: Integer; const aFarAsPossible: Boolean =
      True): Boolean;
    function PreparNextToken(const aWord: string; out aTokenPosition: Integer): Boolean;
    function PreparPrevToken(const aWord: string; out aTokenPosition: Integer): Boolean;
    function ScanNextToken(const aWord: string): Integer; overload; inline;
    function ScanNextToken(const aWord: string; const aOffset: Integer): Integer;
      overload; inline;
    function ScanNextToken(const aWord: string; const aOffset: Integer; const
      aIgnoreCase: Boolean): Integer; overload; inline;
    function ScanPrevToken(const aWord: string): Integer; overload; inline;
    function ScanPrevToken(const aWord: string; const aOffset: Integer): Integer;
      overload; inline;
    function ScanPrevToken(const aWord: string; const aOffset: Integer; const
      aIgnoreCase: Boolean): Integer; overload; inline;
    procedure SetIgnoreCase(const Value: Boolean); stdcall;
    procedure SetPosition(const Value: Integer); stdcall;
    procedure SetSource(const Value: string);
    function SkipBlankSpace(const aDirection: TTMDDirection; const aMaxSkipChars:
      Integer = 0): Boolean;
  protected
  public
    constructor Create(const aSource: string; const aIgnoreCase: Boolean = False);
      overload;
    constructor Create; overload;
    function CurrentChar: Char; stdcall;
    function ExistsTag(const aLeftTag, aRightTag: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;
    function ExistsToken(const aWord: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;
    function GetFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetFirstToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GetLastTag(const aLeftTag, aRightTag: string; const
      aStartWithCurrent: Boolean = True): Boolean; stdcall;
    function GetLastToken(const aWord: string; const aStartWithCurrent: Boolean
      = True; const aWithSkipToken: Boolean = True): Boolean; stdcall;
    function GetLength: Integer; stdcall;
    function GetNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetNextToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GetPrevToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GetSize: Integer; stdcall;
    function GetStr(aStartPosition, aCount: Integer): string; stdcall; inline;
    procedure GetStringFromFirst; stdcall;
    procedure GetStringToEof; stdcall;
    function GetTag(const aLeftTag, aRightTag: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;
    function GetToken(const aWord: string; const aMoveDirection: TTMDDirection =
      Next; const aWithSkipToken: Boolean = True): Boolean; stdcall;
    procedure GoFirst; stdcall;
    function GoFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoFirstToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    procedure GoLast; stdcall;
    function GoLastTag(const aLeftTag, aRightTag: string; const
      aStartWithCurrent: Boolean = True): Boolean; stdcall;
    function GoLastToken(const aWord: string; const aStartWithCurrent: Boolean =
      True; const aWithSkipToken: Boolean = True): Boolean; stdcall;
    function GoNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoNextToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GoPrevToken(const aWord: string; const aWithSkipToken: Boolean =
      True): Boolean; stdcall;
    function GoTag(const aLeftTag, aRightTag: string; const aMoveDirection:
      TTMDDirection = Next): Boolean; stdcall;
    function GoToken(const aWord: string; const aMoveDirection: TTMDDirection =
      Next; const aWithSkipToken: Boolean = True): Boolean; stdcall;
    function IsEof: Boolean; stdcall;
    function IsFirst: Boolean; stdcall;
    function Move(const aMoveCount: Integer; const aDirection: TTMDDirection =
      Next; const aFarAsPossible: Boolean = True): Boolean; stdcall;
    // 字符移动控制
    function NextChar: Char; stdcall;
    // 跳过指定数量的空白字符
    function NextSkipBlankSpace(const aMaxSkipChars: Integer = 0): Boolean; stdcall;
    function PrevChar: Char; stdcall;
    function PrevSkipBlankSpace(const aMaxSkipChars: Integer = 0): Boolean; stdcall;
    property IgnoreCase: Boolean read GetIgnoreCase write SetIgnoreCase;
    property SourceLength: Integer read GetLength;
    property Position: Integer read GetPosition write SetPosition;
    property Size: Integer read GetSize;
    property Source: string read GetSource write SetSource;
    property Value: string read GetValue;
  end;

function CharCompare(aChar1, aChar2: Char): Boolean;

function CharICompare(aChar1, aChar2: Char): Boolean;

function GetCharCompareFun(aIgnoreCase: Boolean = False): TCharCompareFun; inline;

function CharLeftScan(aStr: PChar; aChar: Char; aIgnoreCase: Boolean = False): PChar;

function CharRightScan(aStr: PChar; aChar: Char; aIgnoreCase: Boolean = False): PChar;

function StrNextPos(const Source, SubStr: PChar; const aIgnoreCase: Boolean =
  False): PChar;

function StrPrevPos(const Source: PChar; SubStr: PChar; Offset: Integer = 0;
  aIgnoreCase: Boolean = False): PChar;

function StringPrevScan(const aSource: string; aScanStr: string; aOffset:
  Integer = 1; aIgnoreCase: Boolean = False): Integer;

function StringNextScan(const aSource, aScanStr: string; const aOffset: Integer
  = 1; const aIgnoreCase: Boolean = False): Integer;

const
  Char_StartIndex = 1;

implementation
///
/// 比对字符 区分大小写版本
///

function CharCompare(aChar1, aChar2: Char): Boolean;
begin
  Result := (aChar1 = aChar2);
end;

///
/// 比对字符 不区分大小写版本
///
function CharICompare(aChar1, aChar2: Char): Boolean;
begin
  Result := (UpCase(aChar1) = UpCase(aChar2));
end;

function GetCharCompareFun(aIgnoreCase: Boolean = False): TCharCompareFun;
begin
  if aIgnoreCase then
  begin
    Result := CharICompare;
  end
  else
  begin
    Result := CharCompare;
  end;
end;

///
/// 从右往左扫描字符
///
function CharRightScan(aStr: PChar; aChar: Char; aIgnoreCase: Boolean = False): PChar;
var
  LCharCompareFun: TCharCompareFun;
  LPStr: PChar;
begin
  Result := nil;
  if (aStr^ = #0) or (aChar = #0) then
  begin
    Exit;
  end;

  LCharCompareFun := GetCharCompareFun(aIgnoreCase);
  LPStr := aStr + StrLen(aStr);
  while True do
  begin

    if (LPStr = aStr) then
    begin
      Exit;
    end;

    if (LCharCompareFun(LPStr^, aChar)) then
    begin
      Exit(LPStr);
    end;
    Dec(LPStr);
  end;
end;

///
/// 从左往右扫描字符
///
function CharLeftScan(aStr: PChar; aChar: Char; aIgnoreCase: Boolean = False): PChar;
var
  LPStr: PChar;
  LCharCompareFun: TCharCompareFun;
begin
  Result := nil;
  if (aStr^ = #0) or (aChar = #0) then
  begin
    Exit;
  end;

  LCharCompareFun := GetCharCompareFun(aIgnoreCase);

  LPStr := aStr;
  while True do
  begin
    if (LPStr^ = #0) then
    begin
      Exit;
    end;
    if (LCharCompareFun(LPStr^, aChar)) then
    begin
      Exit(LPStr);
    end;
    Inc(LPStr);
  end;
end;

///
/// 向前查找字符串
///
function StrNextPos(const Source, SubStr: PChar; const aIgnoreCase: Boolean =
  False): PChar;
var
  LMatchStart, LStr1, LStr2: PChar;
  LCharCompareFun: TCharCompareFun;
begin
  // 置 返回值 为 nil
  Result := nil;
  if (Source^ = #0) or (SubStr^ = #0) then
  begin
    Exit;
  end;

  LMatchStart := Source;

  //根据是否大小写敏感设置 字符比对函数指针
  LCharCompareFun := GetCharCompareFun(aIgnoreCase);

  //递进比对
  while LMatchStart^ <> #0 do
  begin
    if LCharCompareFun(LMatchStart^, SubStr^) then
    begin
      LStr1 := LMatchStart + 1;
      LStr2 := SubStr + 1;
      // 循环对比
      while True do
      begin
        if LStr2^ = #0 then
        begin
        //  inc(LMatchStart);
          Exit(LMatchStart);
        end;
        if (not LCharCompareFun(LStr1^, LStr2^)) or (LStr1^ = #0) then
        begin
          Break;
        end;
        Inc(LStr1);
        Inc(LStr2);
      end;
    end;
    Inc(LMatchStart);
  end;
end;

///
/// 向后查找字符串
///
function StrPrevPos(const Source: PChar; SubStr: PChar; Offset: Integer = 0;
  aIgnoreCase: Boolean = False): PChar;
var
  LMatchStart, LStr1, LStr2: PChar;
  LPSub: PChar;
  LPSubBase: PChar;
  LStrLen: Cardinal;
  LSubLen: Cardinal;
  LCompareFun: TCharCompareFun;
begin
  Result := nil;
  LStrLen := StrLen(Source);
  LSubLen := StrLen(SubStr);
  if (LStrLen = 0) or (LSubLen = 0) then
  begin
    Exit;
  end;

  LPSubBase := SubStr;

  LMatchStart := (Source + LStrLen) - Offset - 1;
  LPSub := LPSubBase + LSubLen - 1;

  LCompareFun := GetCharCompareFun(aIgnoreCase);
  while LMatchStart >= Source do
  begin
    if LCompareFun(LMatchStart^, LPSub^) then
    begin
      LStr1 := LMatchStart;
      LStr2 := LPSub;
      while True do
      begin
        if LCompareFun(LStr1^, LStr2^) then
        begin
          if (LStr2) = (LPSubBase) then
          begin
            Exit(LMatchStart - LSubLen + 1);
          end;
        end
        else
        begin
          Break;
        end;

        // 递减指针
        Dec(LStr1);
        Dec(LStr2);
      end;
    end;
    Dec(LMatchStart);
  end;
end;

function StringNextScan(const aSource, aScanStr: string; const aOffset: Integer
  = 1; const aIgnoreCase: Boolean = False): Integer;
var
  LLen, LScanLen, LStart, I, I2: Integer;
  LSourceRemainLen, LScanRemainLen: Integer;
  LCharCompareFun: TCharCompareFun;
begin
  LLen := Length(aSource);
  LScanLen := Length(aScanStr);
  LStart := Max(aOffset, 1);

  Result := 0;
  if (LLen = 0) or (LScanLen = 0) or (LStart < 1) or (LStart > LLen) or (((LStart
    - 1) + LScanLen) > LLen) then
  begin
    Exit;
  end;

  LCharCompareFun := GetCharCompareFun(aIgnoreCase);

  for I := LStart to LLen do
  begin
    if LCharCompareFun(aScanStr[1], aSource[I]) then
    begin
      LSourceRemainLen := LLen - I;
      LScanRemainLen := LScanLen - 1;
      if LSourceRemainLen < LScanRemainLen then
      begin
        Exit;
      end;

      while LScanRemainLen > 0 do
      begin
        I2 := LScanLen - LScanRemainLen;
        if not (LCharCompareFun(aScanStr[I2 + 1], aSource[I + I2])) then
        begin
          Break;
        end;
        Dec(LScanRemainLen);
      end;

      if LScanRemainLen = 0 then
      begin
        Exit(I);
      end;
    end;

  end;

end;

function StringPrevScan(const aSource: string; aScanStr: string; aOffset:
  Integer = 1; aIgnoreCase: Boolean = False): Integer;
var
  LLen, LScanLen, LStart: Integer;
  LSourceRemainLen, LScanRemainLen: Integer;
  LCharCompareFun: TCharCompareFun;
  I, I2: Integer;
begin
  LLen := Length(aSource);
  LScanLen := Length(aScanStr);
  LStart := aOffset;

  Result := 0;
  if (LLen = 0) or (LScanLen = 0) or (LStart < 1) or (LStart > LLen) or (LStart
    - LScanLen < 0) then
  begin
    Exit;
  end;

  LCharCompareFun := GetCharCompareFun(aIgnoreCase);

  for I := LStart downto 1 do
  begin
    if LCharCompareFun(aScanStr[LScanLen], aSource[I]) then
    begin
      LSourceRemainLen := I - 1;
      LScanRemainLen := LScanLen - 1;

      if LSourceRemainLen < LScanRemainLen then
      begin
        Exit;
      end;

      while LScanRemainLen > 0 do
      begin
        I2 := LScanLen - LScanRemainLen;
        if not (LCharCompareFun(aScanStr[LScanRemainLen], aSource[I - I2])) then
        begin
          Break;
        end;
        Dec(LScanRemainLen);
      end;

      if LScanRemainLen = 0 then
      begin
        Exit(I);
      end;

    end;
  end;

end;

constructor TTMDStringTokenTag.Create(const aSource: string; const aIgnoreCase:
  Boolean = False);
begin
  Create();
  SetSource(aSource);
  SetIgnoreCase(aIgnoreCase);
end;

constructor TTMDStringTokenTag.Create;
begin
  inherited;
  FSource := '';
  FIgnoreCase := False;

end;

function TTMDStringTokenTag.CurrentChar: Char;
begin
  Result := FSource[FPosition];
end;

function TTMDStringTokenTag.ExistsTag(const aLeftTag, aRightTag: string; const
  aMoveDirection: TTMDDirection = Next): Boolean;
var
  LSave: Integer;
begin
  LSave := GetPosition;
  Result := GoTag(aLeftTag, aRightTag, aMoveDirection);
  if Result then
  begin
    SetPosition(LSave);
  end;

end;

function TTMDStringTokenTag.ExistsToken(const aWord: string; const
  aMoveDirection: TTMDDirection = Next): Boolean;
var
  LPosition: Integer;
  LSave: Integer;
  LTokenPosition: Integer;
begin
  if aMoveDirection = TTMDDirection.Next then
  begin
    Result := PreparNextToken(aWord, LTokenPosition);
  end
  else
  begin
    Result := PreparPrevToken(aWord, LTokenPosition);
  end;
end;

function TTMDStringTokenTag.GetFirstTag(const aLeftTag, aRightTag: string): Boolean;
var
  LSave: Integer;
begin
  LSave := GetPosition;
  GoFirst;
  Result := GetNextTag(aLeftTag, aRightTag);
  if not Result then
  begin
    SetPosition(LSave);
  end;
end;

function TTMDStringTokenTag.GetFirstToken(const aWord: string; const
  aWithSkipToken: Boolean = True): Boolean;
var
  LSave: Integer;
begin
  LSave := GetPosition;
  GoFirst;
  Result := GetNextToken(aWord, aWithSkipToken);
  if not Result then
  begin
    SetPosition(LSave);
  end;
end;

function TTMDStringTokenTag.GetGetTagFun(const aMoveDirection: TTMDDirection =
  Next): TGetTagFun;
begin
  if aMoveDirection = Next then
  begin
    Result := GetNextTag;
  end
  else
  begin
    Result := GetPrevTag;
  end;
end;

function TTMDStringTokenTag.GetGoTagFun(const aMoveDirection: TTMDDirection =
  Next): TGoTagFun;
begin
  if aMoveDirection = Next then
  begin
    Result := GoNextTag;
  end
  else
  begin
    Result := GoPrevTag;
  end;
end;

function TTMDStringTokenTag.GetGetTokenFun(const aMoveDirection: TTMDDirection):
  TGetTokenFun;
begin
  if aMoveDirection = Next then
  begin
    Result := GetNextToken;
  end
  else
  begin
    Result := GetPrevToken;
  end;
end;

function TTMDStringTokenTag.GetGoTokenFun(const aMoveDirection: TTMDDirection):
  TGoTokenFun;
begin
  if aMoveDirection = Next then
  begin
    Result := Self.GoNextToken;
  end
  else
  begin
    Result := Self.GoPrevToken;
  end;

end;

function TTMDStringTokenTag.GetIgnoreCase: Boolean;
begin
  Result := FIgnoreCase;
end;

function TTMDStringTokenTag.GetLastTag(const aLeftTag, aRightTag: string; const
  aStartWithCurrent: Boolean = True): Boolean;
var
  LOldPosition, LPosition: Integer;
  LSave, LStart, LEnd, LCount: Integer;
begin
  LSave := GetPosition;
  LEnd := LSave;
  GoLast;

  ////
  Result := GoPrevToken(aRightTag);
  if Result then
  begin
    LEnd := GetPosition + 1;
    Result := GoPrevToken(aLeftTag);
    Result := (Result and MoveNext(1) and (GetPosition >= LSave));

    if Result then
    begin
      LStart := GetPosition + Length(aLeftTag);
      LCount := LEnd - LStart;
      FValue := GetStr(LStart, LCount);
      LEnd := LEnd + Length(aRightTag);
    end
    else
    begin
      LEnd := LSave;
    end;
  end;

  SetPosition(LEnd);
end;

function TTMDStringTokenTag.GetLastToken(const aWord: string; const
  aStartWithCurrent: Boolean = True; const aWithSkipToken: Boolean = True): Boolean;
var
  LStart, LPos, LEnd, LCount: Integer;
begin
  LStart := GetPosition;
  Result := GoLastToken(aWord, aStartWithCurrent, False);
  if Result then
  begin
    FValue := GetStr(LStart, (GetPosition - LStart));
    if aWithSkipToken then
    begin
      MoveNext(Length(aWord), True);
    end;
  end;
end;

function TTMDStringTokenTag.GetPosition: Integer;
begin
  Result := FPosition;
end;

function TTMDStringTokenTag.GetSource: string;
begin
  Result := FSource;
end;

function TTMDStringTokenTag.GetValue: string;
begin
  Result := FValue;
end;

procedure TTMDStringTokenTag.GoFirst;
begin
  SetPosition(STARTPOSITION);
end;

function TTMDStringTokenTag.IsEof: Boolean;
begin
  Result := (GetPosition >= Self.GetLength);
end;

function TTMDStringTokenTag.IsFirst: Boolean;
begin
  Result := (GetPosition = STARTPOSITION);
end;

procedure TTMDStringTokenTag.SetPosition(const Value: Integer);
var
  LLen: Cardinal;
begin
  if Value <> GetPosition then
  begin
    LLen := GetLength;
    if Value <= LLen then
    begin
      FPosition := Value;
    end
    else
    begin
      FPosition := LLen;
    end;

    // 预防没测试到的极端情况
    if FPosition <= 0 then
    begin
      FPosition := 1;
    end;
  end;
end;

procedure TTMDStringTokenTag.SetSource(const Value: string);
begin
  FSource := Value;
  GoFirst;
end;

function TTMDStringTokenTag.GetLength: Integer;
begin
  Result := Length(FSource);
end;

function TTMDStringTokenTag.GetNextTag(const aLeftTag, aRightTag: string): Boolean;
var
  LOldPosition, LStart: Integer;
begin
  LOldPosition := GetPosition;
  Result := GoNextToken(aLeftTag, True);
  if Result then
  begin
    LStart := GetPosition;
    Result := GoNextToken(aRightTag, False);
    if Result then
    begin
      FValue := GetStr(LStart, GetPosition - LStart);
      MoveNext(Length(aRightTag));
    end
    else
    begin
      SetPosition(LOldPosition);
    end;
  end;
end;

function TTMDStringTokenTag.GetPrevTag(const aLeftTag, aRightTag: string): Boolean;
var
  LOldPosition: Integer;
begin
  LOldPosition := GetPosition;
  Result := GoPrevToken(aRightTag, True);
  if Result then
  begin
    if IsFirst then
    begin
      Result := ((Length(aLeftTag) = 1) and (CurrentChar = aLeftTag));
    end
    else
    begin
      Result := GetPrevToken(aLeftTag, True);
    end;

    if not Result then
    begin
      SetPosition(LOldPosition);
    end;
  end;
end;

function TTMDStringTokenTag.GetNextToken(const aWord: string; const
  aWithSkipToken: Boolean = True): Boolean;
var
  LStart: Integer;
begin
  LStart := GetPosition;
  Result := GoNextToken(aWord, False);
  if Result then
  begin
    FValue := GetStr(LStart, (GetPosition - LStart));
    if aWithSkipToken then
    begin
      MoveNext(Length(aWord), True);
    end;
  end;
end;

function TTMDStringTokenTag.GetPrevToken(const aWord: string; const
  aWithSkipToken: Boolean = True): Boolean;
var
  LScanPos: Integer;
  LEnd, LStart: Integer;
begin
  LEnd := GetPosition;
  Result := GoPrevToken(aWord, False);
  if Result then
  begin
    LStart := GetPosition;
    FValue := GetStr(LStart + 1, LEnd - LStart);

    if aWithSkipToken then
    begin
      MovePrev(Length(aWord), True);
    end;
  end;

end;

function TTMDStringTokenTag.GetSize: Integer;
begin
  Result := (Self.GetLength * CHARSIZE);
end;

function TTMDStringTokenTag.GetStr(aStartPosition, aCount: Integer): string;
begin
  if aCount > 0 then
  begin
    Result := Copy(FSource, aStartPosition, aCount);
  end;
end;

procedure TTMDStringTokenTag.GetStringFromFirst;
begin
  FValue := GetStr(STARTPOSITION, GetPosition);
end;

procedure TTMDStringTokenTag.GetStringToEof;
begin
  // 从当前指针位置拷贝字符串直到结束
  FValue := GetStr(FPosition, GetLength - FPosition + 1);
  GoLast;
end;

function TTMDStringTokenTag.GetTag(const aLeftTag, aRightTag: string; const
  aMoveDirection: TTMDDirection = Next): Boolean;
var
  LFun: TGetTagFun;
begin
  LFun := GetGetTagFun(aMoveDirection);
  Result := LFun(aLeftTag, aRightTag);
end;

function TTMDStringTokenTag.GetToken(const aWord: string; const aMoveDirection:
  TTMDDirection = Next; const aWithSkipToken: Boolean = True): Boolean;
var
  LFun: TGetTokenFun;
begin
  LFun := GetGetTokenFun(aMoveDirection);
  Result := LFun(aWord, aWithSkipToken);
end;

function TTMDStringTokenTag.GoFirstTag(const aLeftTag, aRightTag: string): Boolean;
var
  FSave: Integer;
begin
  FSave := GetPosition;
  GoFirst;
  Result := Self.GoNextTag(aLeftTag, aRightTag);
  if not Result then
  begin
    SetPosition(FSave);
  end;
end;

function TTMDStringTokenTag.GoFirstToken(const aWord: string; const
  aWithSkipToken: Boolean = True): Boolean;
var
  LSave: Integer;
begin
  LSave := GetPosition;
  GoFirst;
  Result := Self.GoNextToken(aWord, aWithSkipToken);
  if not Result then
  begin
    SetPosition(LSave);
  end;
end;

procedure TTMDStringTokenTag.GoLast;
begin
  SetPosition(GetLength);
end;

function TTMDStringTokenTag.GoLastTag(const aLeftTag, aRightTag: string; const
  aStartWithCurrent: Boolean = True): Boolean;
var
  LOldPosition, LPosition: Integer;
begin
  LOldPosition := GetPosition;
  Result := GoLastToken(aRightTag, aStartWithCurrent, True);
  if Result then
  begin
    LPosition := GetPosition;
    Result := GoPrevToken(aLeftTag, True);

    if aStartWithCurrent then
    begin
      Result := (Result and (GetPosition >= LOldPosition));
    end
    else
    begin
      Result := (Result and True);
    end;

    if not Result then
    begin
      LPosition := LOldPosition;
    end;

    SetPosition(LPosition);
  end;
end;

function TTMDStringTokenTag.GoLastToken(const aWord: string; const
  aStartWithCurrent: Boolean = True; const aWithSkipToken: Boolean = True): Boolean;
var
  LOldPosition, LTokenPosition: Integer;
  LWordLen: Integer;
begin
  //转到最后一个 token, aStartWithCurrent 开关可以设定是否从当前位置开始,默认是关闭的

  LOldPosition := GetPosition;
  GoLast();

  Result := GoPrevToken(aWord, False);
  if Result then
  begin
    LWordLen := Length(aWord);
    LTokenPosition := GetPosition - LWordLen + 1;

    if aStartWithCurrent then
    begin
      Result := (LTokenPosition >= LOldPosition);
    end
    else
    begin
      Result := True;
    end;

    if Result then
    begin
      SetPosition(LTokenPosition);
      if aWithSkipToken then
      begin
        MoveNext(LWordLen, True);
      end;
    end
    else
    begin
      SetPosition(LOldPosition);
    end;
  end;
end;

function TTMDStringTokenTag.GoNextTag(const aLeftTag, aRightTag: string): Boolean;
var
  LOldPosition: Integer;
begin
  LOldPosition := GetPosition;
  Result := GoNextToken(aLeftTag, True);
  if Result then
  begin
    Result := GoNextToken(aRightTag, True);
    if not Result then
    begin
      SetPosition(LOldPosition);
    end;
  end;
end;

function TTMDStringTokenTag.GoPrevTag(const aLeftTag, aRightTag: string): Boolean;
var
  LOldPosition: Integer;
begin
  LOldPosition := GetPosition;
  Result := GoPrevToken(aRightTag, True);
  if Result then
  begin
    // todo: 这个条件补丁很low.
    if IsFirst then
    begin
      Result := ((Length(aLeftTag) = 1) and (CurrentChar = aLeftTag));
    end
    else
    begin
      Result := GoPrevToken(aLeftTag, True);
    end;

    if not Result then
    begin
      SetPosition(LOldPosition);
    end;
  end;
end;

function TTMDStringTokenTag.GoNextToken(const aWord: string; const
  aWithSkipToken: Boolean = True): Boolean;
var
  LTokenPosition: Integer;
begin
  Result := PreparNextToken(aWord, LTokenPosition);
  if Result then
  begin
    SetPosition(LTokenPosition);
    if aWithSkipToken then
    begin
      MoveNext(Length(aWord), True);
    end;
  end;
end;

function TTMDStringTokenTag.GoPrevToken(const aWord: string; const
  aWithSkipToken: Boolean = True): Boolean;
var
  LTokenPosition: Integer;
begin
  Result := PreparPrevToken(aWord, LTokenPosition);
  if Result then
  begin
    SetPosition(LTokenPosition);
    if aWithSkipToken then
    begin
      MovePrev(Length(aWord), True);
    end;
  end;
end;

function TTMDStringTokenTag.GoTag(const aLeftTag, aRightTag: string; const
  aMoveDirection: TTMDDirection = Next): Boolean;
var
  LFun: TGoTagFun;
begin
  LFun := GetGoTagFun(aMoveDirection);
  Result := LFun(aLeftTag, aRightTag);
end;

function TTMDStringTokenTag.GoToken(const aWord: string; const aMoveDirection:
  TTMDDirection = Next; const aWithSkipToken: Boolean = True): Boolean;
var
  LFun: TGoTokenFun;
begin
  LFun := GetGoTokenFun(aMoveDirection);
  Result := LFun(aWord, aWithSkipToken);
end;

function TTMDStringTokenTag.Move(const aMoveCount: Integer; const aDirection:
  TTMDDirection = Next; const aFarAsPossible: Boolean = True): Boolean;
begin
  // todo: 当 aFarAsPossible 设定后不论是否足够移动指定的字符,依旧最大化尽可能移动,但是返回值会反馈结果.
  if aDirection = Next then
  begin
    Result := MoveNext(aMoveCount, aFarAsPossible);
  end
  else
  begin
    Result := MovePrev(aMoveCount, aFarAsPossible);
  end;
end;

function TTMDStringTokenTag.MoveNext(const aMoveCount: Integer; const
  aFarAsPossible: Boolean = True): Boolean;
var
  LPosition, LNewPosition: Integer;
begin
  LPosition := GetPosition;
  LNewPosition := (LPosition + aMoveCount);
  Result := (LNewPosition <= GetLength);

  if (not Result) then
  begin
    if (not aFarAsPossible) then
    begin
      Exit;
    end;
  end;

  SetPosition(Min(LNewPosition, GetLength));
end;

function TTMDStringTokenTag.MovePrev(const aMoveCount: Integer; const
  aFarAsPossible: Boolean = True): Boolean;
var
  LPosition, LNewPosition: Integer;
begin
  LPosition := GetPosition;
  LNewPosition := (LPosition - aMoveCount);
  Result := (LNewPosition >= 1);

  if (not Result) then
  begin
    if (not aFarAsPossible) then
    begin
      Exit;
    end;
  end;

  SetPosition(Max(LNewPosition, 1));
end;

function TTMDStringTokenTag.NextChar: Char;
begin
  Move(1);
  Result := CurrentChar;
end;

function TTMDStringTokenTag.NextSkipBlankSpace(const aMaxSkipChars: Integer = 0): Boolean;
begin
  Result := SkipBlankSpace(Next, aMaxSkipChars);
end;

function TTMDStringTokenTag.PreparNextToken(const aWord: string; out
  aTokenPosition: Integer): Boolean;
begin
  Result := (not IsEof);
  if Result then
  begin
    aTokenPosition := ScanNextToken(aWord, GetPosition, FIgnoreCase);
    Result := (aTokenPosition > 0);
  end;
end;

function TTMDStringTokenTag.PreparPrevToken(const aWord: string; out
  aTokenPosition: Integer): Boolean;
begin
  Result := (not IsFirst);
  if Result then
  begin
    aTokenPosition := ScanPrevToken(aWord, GetPosition, FIgnoreCase);
    Result := (aTokenPosition > 0);
  end;
end;

function TTMDStringTokenTag.PrevChar: Char;
begin
  Move(-1);
  Result := CurrentChar;
end;

function TTMDStringTokenTag.PrevSkipBlankSpace(const aMaxSkipChars: Integer = 0): Boolean;
var
  LMove: Integer;
begin
  Result := SkipBlankSpace(Prev, aMaxSkipChars);
end;

function TTMDStringTokenTag.ScanNextToken(const aWord: string): Integer;
begin
  Result := StringNextScan(FSource, aWord, GetPosition, FIgnoreCase);
end;

function TTMDStringTokenTag.ScanNextToken(const aWord: string; const aOffset:
  Integer): Integer;
begin
  Result := StringNextScan(FSource, aWord, aOffset, FIgnoreCase);
end;

function TTMDStringTokenTag.ScanNextToken(const aWord: string; const aOffset:
  Integer; const aIgnoreCase: Boolean): Integer;
begin
  Result := StringNextScan(FSource, aWord, aOffset, aIgnoreCase);
end;

function TTMDStringTokenTag.ScanPrevToken(const aWord: string): Integer;
begin
  Result := StringPrevScan(FSource, aWord, GetPosition, FIgnoreCase);
end;

function TTMDStringTokenTag.ScanPrevToken(const aWord: string; const aOffset:
  Integer): Integer;
begin
  Result := StringPrevScan(FSource, aWord, aOffset, FIgnoreCase);
end;

function TTMDStringTokenTag.ScanPrevToken(const aWord: string; const aOffset:
  Integer; const aIgnoreCase: Boolean): Integer;
begin
  Result := StringPrevScan(FSource, aWord, aOffset, aIgnoreCase);
end;

procedure TTMDStringTokenTag.SetIgnoreCase(const Value: Boolean);
begin
  FIgnoreCase := Value;
end;

function TTMDStringTokenTag.SkipBlankSpace(const aDirection: TTMDDirection;
  const aMaxSkipChars: Integer = 0): Boolean;
var
  LMove, LChange: Integer;
begin
  LMove := 0;
  Result := False;

  if aDirection = Next then
  begin
    LChange := 1;
  end
  else
  begin
    LChange := -1;
  end;

  if aMaxSkipChars = 0 then
  begin
    while True do
    begin
      if not (CurrentChar = #32) then
      begin
        Exit(True);
      end;
      Move(LChange);
    end;
  end
  else
  begin
    while (LMove < aMaxSkipChars) do
    begin

      if not (CurrentChar = #32) then
      begin
        Exit(True);
      end;
      Inc(LMove);
      Move(LChange);
    end;
  end;

end;

end.

