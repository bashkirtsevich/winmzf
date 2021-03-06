{ *********************************************************************** }
{                                                                         }
{ Delphi �ncryption Library                                               }
{ �ncryption / Decryption stream - RC5                                    }
{                                                                         }
{ Copyright (c) 2004 by Matveev Igor Vladimirovich                        }
{ With offers and wishes write: teap_leap@mail.ru                         }
{                                                                         }
{ *********************************************************************** }

unit RC5;

interface

uses
  SysUtils, Classes;

type
  TRC5Block = array[1..2] of LongWord;

const
  Rounds     = 12;
  BlockSize  = 8;
  BufferSize = 2048;
  KeySize    = 64;
  KeyLength  = 2 * (Rounds + 1);

  P32 = $b7e15163;
  Q32 = $9e3779b9;

var
  Key        : string;
  KeyPtr     : PChar;

  S : array[0..KeyLength-1] of LongWord;

////////////////////////////////////////////////////////////////////////////////
// �������������� �������

procedure Initialize(AKey: string);          // �������������
procedure CalculateSubKeys;                  // ���������� ���������
function EncipherBlock(var Block): Boolean;  // �������� ����� (8 ����)
function DecipherBlock(var Block): Boolean;  // ���������� �����


////////////////////////////////////////////////////////////////////////////////
// ������� �������

function RC5_EncryptCopy(DestStream, SourseStream : TStream; Count: Int64;
  Key : string): Boolean;    // ����������� ������ �� ������ ������ � ������

function RC5_DecryptCopy(DestStream, SourseStream : TStream; Count: Int64;
  Key : string): Boolean;    // ������������ ������ �� ������ ������ � ������

function RC5_EncryptStream(DataStream: TStream; Count: Int64;
  Key: string): Boolean;     // ����������� ���������� ������

function RC5_DecryptStream(DataStream: TStream; Count: Int64;
  Key: string): Boolean;     // ������������ ���������� ������

implementation

////////////////////////////////////////////////////////////////////////////////

function ROL(a, s: LongWord): LongWord;
asm
  mov    ecx, s
  rol    eax, cl
end;

////////////////////////////////////////////////////////////////////////////////

function ROR(a, s: LongWord): LongWord;
asm
  mov    ecx, s
  ror    eax, cl
end;

////////////////////////////////////////////////////////////////////////////////

procedure InvolveKey;
var
  TempKey : string;
  i, j    : Integer;
  K1, K2  : LongWord;
begin
 // �������������� ����� �� ������ 64 �������
 TempKey := Key;
 i := 1;
 while ((Length(TempKey) mod KeySize) <> 0) do
   begin
     TempKey := TempKey + TempKey[i];
     Inc(i);
   end;

 // Now shorten the key down to one KeySize block by combining the bytes
 i := 1;
 j := 0;
 while (i < Length(TempKey)) do
   begin
     Move((KeyPtr+j)^, K1, 4);
     Move(TempKey[i], K2, 4);
     K1 := ROL(K1, K2) xor K2;
     Move(K1, (KeyPtr+j)^, 4);
     j := (j + 4) mod KeySize;
     Inc(i, 4);
   end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure Initialize(AKey: string);
begin
 Key := AKey;
 GetMem(KeyPtr, KeySize);
 FillChar(KeyPtr^, KeySize, #0);

 InvolveKey;
end;

////////////////////////////////////////////////////////////////////////////////

{$R-,Q-}

procedure CalculateSubKeys;
var
  i, j, k : Integer;
  L       : array[0..15] of LongWord;
  A, B    : LongWord;
begin
 // Copy the key into L
 Move(KeyPtr^, L, KeySize);

 // Now initialize the S table
 S[0] := P32;
 for i := 1 to KeyLength-1 do
   S[i] := S[i-1] + Q32;

 // Now scramble the S table with the key
 i := 0;
 j := 0;
 A := 0;
 B := 0;
 for k := 1 to 3*KeyLength do
   begin
     A := ROL((S[i] + A + B), 3);
     S[i] := A;
     B := ROL((L[j] + A + B), (A + B));
     L[j] := B;
     i := (i + 1) mod KeyLength;
     j := (j + 1) mod 16;
   end;
end;

////////////////////////////////////////////////////////////////////////////////


function EncipherBlock(var Block): Boolean;
var
  RC5Block : TRC5Block absolute Block;
  i        : Integer;
begin
 Inc(RC5Block[1], S[0]);
 Inc(RC5Block[2], S[1]);

 for i := 1 to Rounds do
   begin
     RC5Block[1] := ROL((RC5Block[1] xor RC5Block[2]), RC5Block[2]) + S[2*i];
     RC5Block[2] := ROL((RC5Block[2] xor RC5Block[1]), RC5Block[1]) + S[2*i+1];
   end;

 Result := TRUE;
end;

////////////////////////////////////////////////////////////////////////////////

function DecipherBlock(var Block): Boolean;
var
  RC5Block : TRC5Block absolute Block;
  i        : Integer;
begin
 for i := Rounds downto 1 do
   begin
     RC5Block[2] := ROR((RC5Block[2]-S[2*i+1]), RC5Block[1]) xor RC5Block[1];
     RC5Block[1] := ROR((RC5Block[1]-S[2*i]),   RC5Block[2]) xor RC5Block[2];
   end;

 Dec(RC5Block[2], S[1]);
 Dec(RC5Block[1], S[0]);

 Result := TRUE;
end;

////////////////////////////////////////////////////////////////////////////////
// ���������� ������� �������

function RC5_EncryptCopy(DestStream, SourseStream : TStream; Count: Int64;
  Key : string): Boolean;
var
  Buffer   : TRC5Block;
  PrCount  : Int64;
  AddCount : Byte;
begin
 Result := True;
 try
   if Key = '' then
     begin
       DestStream.CopyFrom(SourseStream, Count);
       Exit;
     end;
   Initialize(Key);
   CalculateSubKeys;
   PrCount := 0;
   while Count - PrCount >= 8 do
     begin
       SourseStream.Read(Buffer, BlockSize);
       EncipherBlock(Buffer);
       DestStream.Write(Buffer, BlockSize);
       Inc(PrCount, 8);
     end;

   AddCount := Count - PrCount;
   if Count - PrCount <> 0 then
     begin
       SourseStream.Read(Buffer, AddCount);
       DestStream.Write(Buffer, AddCount);
     end;
 except
   Result := False;
 end;
end;

////////////////////////////////////////////////////////////////////////////////

function RC5_DecryptCopy(DestStream, SourseStream : TStream; Count: Int64;
  Key : string): Boolean;
var
  Buffer   : TRC5Block;
  PrCount  : Int64;
  AddCount : Byte;
begin
 Result := True;
 try
   if Key = '' then
     begin
       DestStream.CopyFrom(SourseStream, Count);
       Exit;
     end;
   Initialize(Key);
   CalculateSubKeys;
   PrCount := 0;
   while Count - PrCount >= 8 do
     begin
       SourseStream.Read(Buffer, BlockSize);
       DecipherBlock(Buffer);
       DestStream.Write(Buffer, BlockSize);
       Inc(PrCount, 8);
     end;

   AddCount := Count - PrCount;
   if Count - PrCount <> 0 then
     begin
       SourseStream.Read(Buffer, AddCount);
       DestStream.Write(Buffer, AddCount);
     end;
 except
   Result := False;
 end;
end;

////////////////////////////////////////////////////////////////////////////////

function RC5_EncryptStream(DataStream: TStream; Count: Int64; Key: string): Boolean;
var
  Buffer   : TRC5Block;
  PrCount  : Int64;
begin
 Result := True;
 try
   if Key = '' then
     begin
       DataStream.Seek(Count, soFromCurrent);
       Exit;
     end;
   Initialize(Key);
   CalculateSubKeys;
   PrCount := 0;
   while Count - PrCount >= 8 do
     begin
       DataStream.Read(Buffer, BlockSize);
       EncipherBlock(Buffer);
       DataStream.Seek(-BlockSize, soFromCurrent);
       DataStream.Write(Buffer, BlockSize);
       Inc(PrCount, 8);
     end;
 except
   Result := False;
 end;
end;

////////////////////////////////////////////////////////////////////////////////

function RC5_DecryptStream(DataStream: TStream; Count: Int64; Key: string): Boolean;
var
  Buffer   : TRC5Block;
  PrCount  : Int64;
begin
 Result := True;
 try
   if Key = '' then
     begin
       DataStream.Seek(Count, soFromCurrent);
       Exit;
     end;
   Initialize(Key);
   CalculateSubKeys;
   PrCount := 0;
   while Count - PrCount >= 8 do
     begin
       DataStream.Read(Buffer, BlockSize);
       DecipherBlock(Buffer);
       DataStream.Seek(-BlockSize, soFromCurrent);
       DataStream.Write(Buffer, BlockSize);
       Inc(PrCount, 8);
     end;
 except
   Result := False;
 end;
end;

// ���������� ������� ������� ...
////////////////////////////////////////////////////////////////////////////////

{$R+,Q+} 

end.