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
  SysUtils, Variants, System.Math, Classes, StrUtils;

const
  STARTPOSITION = 1;
  CHARSIZE = SizeOf(char);

type
  TCharCompareFun = function(aChar1, aChar2: Char): Boolean;

  TGoTokenFun = function(const aWord: string): Boolean of object; stdcall;

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
    function ExistsToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;

    // 跳转
    function GoToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function GoNextToken(const aWord: string): Boolean; stdcall;
    function GoPrevToken(const aWord: string): boolean; stdcall;
    function GoFirstToken(const aWord: string): Boolean; stdcall;
    function GoLastToken(const aWord: string): Boolean; stdcall;

    // 内容
    function GetToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function GetNextToken(const aWord: string): boolean; stdcall;
    function GetPrevToken(const aWord: string): Boolean; stdcall;
    function GetFirstToken(const aWord: string): Boolean; stdcall;
    function GetLastToken(const aWord: string): Boolean; stdcall;

    ///
    /// Tag
    ///
    // 检测
    function ExistsTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;

    // Tag 跳转
    function GoTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function GoNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoLastTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;

    // Tag 内容
    function GetTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function GetNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetLastTag(const aLeftTag, aRightTag: string): Boolean; stdcall;

    // 获取字符串 - 从当前位置直到尾部结束
    function GetStringToEof: Boolean; stdcall;
    // 获取字符串 - 从字符串开始(第一个)到当前位置
    function GetStringFromFirst: Boolean; stdcall;
    // 当前位置的字符
    function CurrentChar: Char; stdcall;
    // 移动位置 +-
    function Move(const aMoveCount: Integer; const aDirection: TTMDDirection = Next): Boolean; stdcall;
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
  TTMDStringTokenTag = class(TinterfacedObject, IStringTokenTag)
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
    function ScanNextToken(const aWord: string): Integer; overload; inline;
    function ScanNextToken(const aWord: string; const aOffset: Integer): Integer; overload; inline;
    function ScanNextToken(const aWord: string; const aOffset: Integer; const aIgnoreCase: Boolean): Integer; overload; inline;
    function ScanPrevToken(const aWord: string): Integer; overload; inline;
    function ScanPrevToken(const aWord: string; const aOffset: Integer): Integer; overload; inline;
    function ScanPrevToken(const aWord: string; const aOffset: Integer; const aIgnoreCase: Boolean): Integer; overload; inline;
    procedure SetIgnoreCase(const Value: Boolean); stdcall;
    procedure SetPosition(const Value: Integer); stdcall;
    procedure SetSource(const Value: string);
    function SkipBlankSpace(const aDirection: TTMDDirection; const aMaxSkipChars: Integer = 0): Boolean;
  protected
  public
    constructor Create(const aSource: string; const aIgnoreCase: Boolean = False); overload;
    constructor Create; overload;
    function CurrentChar: Char; stdcall;
    function ExistsTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function ExistsToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function GetFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetFirstToken(const aWord: string): Boolean; stdcall;
    function GetLastTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetLastToken(const aWord: string): Boolean; stdcall;
    function GetLength: Integer; stdcall;
    function GetNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GetNextToken(const aWord: string): boolean; stdcall;
    function GetPrevToken(const aWord: string): Boolean; stdcall;
    function GetSize: Integer; stdcall;
    function GetStr(aStartPosition, aCount: Integer): string; stdcall; inline;
    function GetStringFromFirst: Boolean; stdcall;
    function GetStringToEof: Boolean; stdcall;
    function GetTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function GetToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    procedure GoFirst; stdcall;
    function GoFirstTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoFirstToken(const aWord: string): Boolean; stdcall;
    procedure GoLast; stdcall;
    function GoLastTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoLastToken(const aWord: string): Boolean; stdcall;
    function GoNextTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoPrevTag(const aLeftTag, aRightTag: string): Boolean; stdcall;
    function GoNextToken(const aWord: string): Boolean; stdcall;
    function GoPrevToken(const aWord: string): boolean; stdcall;
    function GoTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function GoToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean; stdcall;
    function IsEof: Boolean; stdcall;
    function IsFirst: Boolean; stdcall;
    function Move(const aMoveCount: Integer; const aDirection: TTMDDirection = Next): Boolean; stdcall;
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

function GetCharCompareFun(aIgnoreCase: Boolean = false): TCharCompareFun; inline;

function CharLeftScan(aStr: PChar; aChar: Char; aIgnoreCase: Boolean = False): PChar;

function CharRightScan(aStr: Pchar; aChar: Char; aIgnoreCase: Boolean = False): PChar;

function StrNextPos(const Source, SubStr: PChar; const aIgnoreCase: Boolean = False): Pchar;

function StrPrevPos(const Source: Pchar; SubStr: pchar; Offset: Integer = 0; aIgnoreCase: Boolean = False): PChar;

function StringPrevScan(const aSource: string; aScanStr: string; aOffset: Integer = 1; aIgnoreCase: Boolean = False): Integer;

function StringNextScan(const aSource, aScanStr: string; const aOffset: Integer = 1; const aIgnoreCase: Boolean = False): Integer;

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

function GetCharCompareFun(aIgnoreCase: Boolean = false): TCharCompareFun;
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
function CharRightScan(aStr: Pchar; aChar: Char; aIgnoreCase: Boolean = False): PChar;
var
  LCharCompareFun: TCharCompareFun;
  LPStr: Pchar;
begin
  Result := nil;
  if (aStr^ = #0) or (aChar = #0) then
  begin
    Exit;
  end;

  LCharCompareFun := GetCharCompareFun(aIgnoreCase);
  LPStr := aStr + StrLen(aStr);
  while true do
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
  LPStr: Pchar;
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
function StrNextPos(const Source, SubStr: PChar; const aIgnoreCase: Boolean = False): Pchar;
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
function StrPrevPos(const Source: Pchar; SubStr: pchar; Offset: Integer = 0; aIgnoreCase: Boolean = False): PChar;
var
  LMatchStart, LStr1, LStr2: PChar;
  LPSub: Pchar;
  LPSubBase: Pchar;
  LStrLen: cardinal;
  LSubLen: cardinal;
  LCompareFun: TCharCompareFun;
begin
  Result := nil;
  LStrLen := Strlen(Source);
  LSubLen := Strlen(SubStr);
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

function StringNextScan(const aSource, aScanStr: string; const aOffset: Integer = 1; const aIgnoreCase: Boolean = False): Integer;
var
  LLen, LScanLen, LStart, I, I2: Integer;
  LSourceRemainLen, LScanRemainLen: Integer;
  LCharCompareFun: TCharCompareFun;
begin
  LLen := Length(aSource);
  LScanLen := Length(aScanStr);
  LStart := Max(aOffset, 1);

  Result := 0;
  if (LLen = 0) or (LScanLen = 0) or (LStart < 1) or (LStart > LLen) or (((LStart - 1) + LScanLen) > LLen) then
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

function StringPrevScan(const aSource: string; aScanStr: string; aOffset: Integer = 1; aIgnoreCase: Boolean = False): Integer;
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
  if (LLen = 0) or (LScanLen = 0) or (LStart < 1) or (LStart > LLen) or (LStart - LScanLen < 0) then
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

constructor TTMDStringTokenTag.Create(const aSource: string; const aIgnoreCase: Boolean = False);
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

function TTMDStringTokenTag.ExistsTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean;
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

function TTMDStringTokenTag.ExistsToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean;
var
  LSave: Integer;
begin
  LSave := GetPosition;
  Result := GoToken(aWord, aMoveDirection);
  if Result then
  begin
    SetPosition(LSave);
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

function TTMDStringTokenTag.GetFirstToken(const aWord: string): Boolean;
var
  LSave: Integer;
begin
  LSave := GetPosition;
  GoFirst;
  Result := GetNextToken(aWord);
  if not Result then
  begin
    SetPosition(LSave);
  end;
end;

function TTMDStringTokenTag.GetGetTagFun(const aMoveDirection: TTMDDirection = Next): TGetTagFun;
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

function TTMDStringTokenTag.GetGoTagFun(const aMoveDirection: TTMDDirection = Next): TGoTagFun;
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

function TTMDStringTokenTag.GetGetTokenFun(const aMoveDirection: TTMDDirection): TGetTokenFun;
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

function TTMDStringTokenTag.GetGoTokenFun(const aMoveDirection: TTMDDirection): TGoTokenFun;
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

function TTMDStringTokenTag.GetLastTag(const aLeftTag, aRightTag: string): Boolean;
var
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
    Result := (Result and (GetPosition >= LSave));

    if Result then
    begin
      LStart := GetPosition + Length(aLeftTag) + 1;
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

function TTMDStringTokenTag.GetLastToken(const aWord: string): Boolean;
var
  LStart, LPos, LEnd, LCount: Integer;
begin
  LStart := GetPosition;
  GoLast;
  Result := GoPrevToken(aWord);
  LPos := GetPosition;
  Result := (Result and (LPos >= LStart));

  if not Result then
  begin
    SetPosition(LStart);
    Exit;
  end;

  LEnd := LPos;
  LCount := LEnd - LStart + 1;
  FValue := GetStr(LStart, LCount);
  Move(Length(aWord) + 1);
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
  LLen := GetLength {+ 1};
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
  LScanPos, LStart, LLen, LCount: Integer;
begin
  Result := (not IsEof);
  if Result then
  begin
    LScanPos := ScanNextToken(aLeftTag);
    Result := (LScanPos > 0);
    if Result then
    begin
      LStart := LScanPos + Length(aLeftTag);
      LLen := GetLength;
      Result := (LStart <= LLen);
      if Result then
      begin
        LScanPos := ScanNextToken(aRightTag, LStart);
        Result := (LScanPos > 0);
        if Result then
        begin
          LCount := (LScanPos - LStart);
          if LCount > 0 then
          begin
            FValue := GetStr(LStart, LCount);
          end
          else
          begin
            FValue := '';
          end;
          SetPosition(Min(LScanPos + Length(aRightTag), LLen));
        end;
      end;
    end;

  end;

end;

function TTMDStringTokenTag.GetPrevTag(const aLeftTag, aRightTag: string): Boolean;
var
  LScanPos, LEnd, LPosition, LStart, LCount: Integer;
begin
  Result := (not IsFirst);
  if Result then
  begin
    LScanPos := ScanPrevToken(aRightTag);
    Result := (LScanPos > 0);
    if Result then
    begin
      LEnd := LScanPos - Length(aRightTag);
      Result := (LEnd >= 1);
      if Result then
      begin
        LScanPos := ScanPrevToken(aLeftTag, LEnd);
        Result := (LScanPos > 0);
        if Result then
        begin
          LPosition := LScanPos;
          LStart := LPosition + 1;
          LCount := LEnd - LStart + 1;

          if LCount > 0 then
          begin
            FValue := GetStr(LStart, LCount);
          end
          else
          begin
            FValue := '';
          end;
          SetPosition(Max(LPosition - Length(aLeftTag), 1));
        end;

      end;
    end;
  end;
end;

function TTMDStringTokenTag.GetNextToken(const aWord: string): boolean;
var
  LScanPos, LStart: Integer;
begin
  Result := (not IsEof);
  if Result then
  begin
    LScanPos := ScanNextToken(aWord);
    Result := (LScanPos > 0);
    if Result then
    begin
      LStart := GetPosition;
      FValue := GetStr(LStart, LScanPos - LStart);
      SetPosition(Min(LScanPos + Length(aWord), GetLength));
    end;
  end;
end;

function TTMDStringTokenTag.GetPrevToken(const aWord: string): Boolean;
var
  LScanPos, LEnd: Integer;
begin
  Result := (not IsFirst);
  if Result then
  begin
    LEnd := GetPosition;
    LScanPos := ScanPrevToken(aWord);
    Result := (LScanPos > 0);
    if Result then
    begin
      FValue := GetStr(Min(LEnd, LScanPos + 1), LEnd - LScanPos);
      SetPosition(Max(LScanPos - Length(aWord), 1));
    end;
  end;

end;

function TTMDStringTokenTag.GetSize: Integer;
begin
  Result := (Self.GetLength * CHARSIZE);
end;

function TTMDStringTokenTag.GetStr(aStartPosition, aCount: Integer): string;
begin
  Result := Copy(FSource, aStartPosition, aCount);
end;

function TTMDStringTokenTag.GetStringFromFirst: Boolean;
begin
  Result := (not IsFirst);
  if Result then
  begin
    FValue := GetStr(1, GetPosition);
    //GoFirst
    //Result := IsFirst;
  end;
end;

function TTMDStringTokenTag.GetStringToEof: Boolean;
begin
  // 从当前指针位置拷贝字符串直到结束
  Result := (not IsEof);
  if Result then
  begin
    FValue := GetStr(FPosition, GetLength - FPosition + 1);
    GoLast;
    Result := IsEof;
  end;
end;

function TTMDStringTokenTag.GetTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean;
var
  LFun: TGetTagFun;
begin
  LFun := GetGetTagFun(aMoveDirection);
  Result := LFun(aLeftTag, aRightTag);
end;

function TTMDStringTokenTag.GetToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean;
var
  LFun: TGetTokenFun;
begin
  LFun := GetGetTokenFun(aMoveDirection);
  Result := LFun(aWord);
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

function TTMDStringTokenTag.GoFirstToken(const aWord: string): Boolean;
var
  LSave: Integer;
begin
  LSave := GetPosition;
  GoFirst;
  Result := Self.GoNextToken(aWord);
  if not Result then
  begin
    SetPosition(LSave);
  end;
end;

procedure TTMDStringTokenTag.GoLast;
begin
  SetPosition(GetLength);
end;

function TTMDStringTokenTag.GoLastTag(const aLeftTag, aRightTag: string): Boolean;
var
  LPos, LEnd: Integer;
begin
  LPos := GetPosition;

  Result := GoLastToken(aRightTag);
  if Result then
  begin
    LEnd := GetPosition;
    Result := GoPrevToken(aLeftTag);
    Result := (Result and (GetPosition >= LPos));
    if Result then
    begin
      LPos := LEnd;
    end;
  end;
  SetPosition(LPos);
end;

function TTMDStringTokenTag.GoLastToken(const aWord: string): Boolean;
var
  LStart, LPos: Integer;
begin
  LStart := GetPosition;
  GoLast();
  Result := GoPrevToken(aWord);
  LPos := GetPosition;
  Result := (Result and (LPos >= LStart));
  if Result then
  begin
    LPos := Min(LPos + Length(aWord) + 1, GetLength);
  end
  else
  begin
    LPos := LStart;
  end;
  SetPosition(LPos);
end;

function TTMDStringTokenTag.GoNextTag(const aLeftTag, aRightTag: string): Boolean;
var
  LScanPos, LStart: Integer;
begin
  Result := (not IsEof);
  if Result then
  begin
    LScanPos := ScanNextToken(aLeftTag);
    Result := (LScanPos > 0);
    if Result then
    begin
      LStart := LScanPos + Length(aLeftTag);
      Result := (LStart <= GetLength);
      if Result then
      begin
        LScanPos := ScanNextToken(aRightTag, LStart);
        Result := (LScanPos > 0);
        if Result then
        begin
          SetPosition(LScanPos + Length(aRightTag));
        end;
      end;
    end;
  end;

end;

function TTMDStringTokenTag.GoPrevTag(const aLeftTag, aRightTag: string): Boolean;
var
  LScanPos, LEnd: Integer;
begin
  Result := (not IsFirst);
  if Result then
  begin
    LScanPos := ScanPrevToken(aRightTag);
    Result := (LScanPos > 0);
    if Result then
    begin
      LEnd := LScanPos - Length(aRightTag);
      Result := (LEnd >= 1);
      if Result then
      begin
        LScanPos := ScanPrevToken(aLeftTag, LEnd);
        Result := (LScanPos > 0);
        if Result then
        begin
          SetPosition(Max(LScanPos - Length(aLeftTag), 1));
        end;
      end;

    end;
  end;
end;

function TTMDStringTokenTag.GoNextToken(const aWord: string): Boolean;
var
  LScanPos: Integer;
begin
  Result := (not IsEof);
  if Result then
  begin
    LScanPos := ScanNextToken(aWord);
    Result := (LScanPos > 0);
    if Result then
    begin
      SetPosition(Min(GetLength, LScanPos + Length(aWord)));
    end;
  end;

end;

function TTMDStringTokenTag.GoPrevToken(const aWord: string): boolean;
var
  LScanPos: Integer;
begin
  Result := (not IsFirst);
  if Result then
  begin
    LScanPos := ScanPrevToken(aWord);
    Result := (LScanPos > 0);
    if Result then
    begin
      SetPosition(Max(LScanPos - Length(aWord), 1));
    end;
  end;

end;

function TTMDStringTokenTag.GoTag(const aLeftTag, aRightTag: string; const aMoveDirection: TTMDDirection = Next): Boolean;
var
  LFun: TGoTagFun;
begin
  LFun := GetGoTagFun(aMoveDirection);
  Result := LFun(aLeftTag, aRightTag);
end;

function TTMDStringTokenTag.GoToken(const aWord: string; const aMoveDirection: TTMDDirection = Next): Boolean;
var
  LFun: TGoTokenFun;
begin
  LFun := GetGoTokenFun(aMoveDirection);
  Result := LFun(aWord);
end;

function TTMDStringTokenTag.Move(const aMoveCount: Integer; const aDirection: TTMDDirection = Next): Boolean;
var
  LPos: Integer;
begin
  if aDirection = Next then
  begin
    LPos := GetPosition + aMoveCount;
    Result := (LPos <= GetLength);
  end
  else
  begin
    LPos := GetPosition - aMoveCount;
    Result := (LPos >= 1);
  end;
  if Result then
  begin
    SetPosition(LPos);
  end;
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

function TTMDStringTokenTag.ScanNextToken(const aWord: string; const aOffset: Integer): Integer;
begin
  Result := StringNextScan(FSource, aWord, aOffset, FIgnoreCase);
end;

function TTMDStringTokenTag.ScanNextToken(const aWord: string; const aOffset: Integer; const aIgnoreCase: Boolean): Integer;
begin
  Result := StringNextScan(FSource, aWord, aOffset, aIgnoreCase);
end;

function TTMDStringTokenTag.ScanPrevToken(const aWord: string): Integer;
begin
  Result := StringPrevScan(FSource, aWord, GetPosition, FIgnoreCase);
end;

function TTMDStringTokenTag.ScanPrevToken(const aWord: string; const aOffset: Integer): Integer;
begin
  Result := StringPrevScan(FSource, aWord, aOffset, FIgnoreCase);
end;

function TTMDStringTokenTag.ScanPrevToken(const aWord: string; const aOffset: Integer; const aIgnoreCase: Boolean): Integer;
begin
  Result := StringPrevScan(FSource, aWord, aOffset, aIgnoreCase);
end;

procedure TTMDStringTokenTag.SetIgnoreCase(const Value: Boolean);
begin
  FIgnoreCase := Value;
end;

function TTMDStringTokenTag.SkipBlankSpace(const aDirection: TTMDDirection; const aMaxSkipChars: Integer = 0): Boolean;
var
  LMove, LChange: Integer;
begin
  LMove := 0;
  Result := false;

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

