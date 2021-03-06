unit Main_u;

interface                                    

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Decompress_u, Advanced, 
  UniversalUnpacker_u, SignatureDetect_u, UnRAR, OverWrite_u;

//type TArchType=(atNone,atMZF,atZipTV);
function ChangeVolProc(ArcName:PChar; Mode:integer):integer; cdecl;

type
  TSFXhead=packed record
    Signature:Array[0..2] Of Char;
    Vendor:Array[0..5] Of Char;
    ArchType:TFileType;
    WndCaption:ShortString;
    ExtractDir:ShortString;
  end;

type
  TdlgExtract = class(TForm)
    btnExtract: TBitBtn;
    btnCancel: TBitBtn;
    memComment: TMemo;
    pbProgress: TProgressBar;
    imgLogo: TImage;
    lineBottom: TBevel;
    lbCopyRight: TLabel;
    cbDestDir: TComboBox;
    lbProgress: TLabel;
    lbDestDir: TLabel;
    btnBrows: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure btnExtractClick(Sender: TObject);
    procedure btnBrowsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnProgress(Sender:TObject;FProgress,AProgress:Byte;Var Abort:Boolean);
    procedure GetPass(Sender:TObject;Var Pass:ShortString);
    procedure OnError(Sender:TObject;ErrorMsg:ShortString);
    procedure RewritePromt(Sender:TObject;Var AFile:TFileHead;Var Mode:TReWriteMode);
  private
    procedure OnExtract(Sender:TObject;_FileName:ShortString);
    { Private declarations }
  public
    _Abort:Boolean;
    ArcType:TFileType;
    { Public declarations }
  end;

const
  Sign='MSi';
  VID='MADMAN';

var
  dlgExtract: TdlgExtract;
  MZFArchive:TMemoryStream;
  
implementation

{$R *.dfm}
{$R WindowsXP.res}

function ChangeVolProc(ArcName:PChar; Mode:integer):integer;
var s:string;
    p:pchar;
begin
  ChangeVolProc:=1;
  p:=@s[1];
  if (Mode=RAR_VOL_ASK) then
  begin
    s:='Insert next volume';
    if Application.messagebox(p,'Attention',mb_okcancel)=idcancel
       then ChangeVolProc:=0
  end;
end;

procedure RarExtract(ArcName:pchar;DestDir:String);
var
  hArcData:THandle;
  RHCode,PFCode:integer;
  CmtBuf:array[1..16384] of char;
  HeaderData:RARHeaderData;
  OpenArchiveData:RAROpenArchiveData;
  {GlobalUnPackSize,Maximum,}FileCount,Current:LongWord;
begin

  OpenArchiveData.ArcName:=ArcName;
  OpenArchiveData.CmtBuf:=@CmtBuf[1];
  OpenArchiveData.CmtBufSize:=sizeof(CmtBuf);
  OpenArchiveData.OpenMode:=RAR_OM_EXTRACT;
  hArcData:=RAROpenArchive(OpenArchiveData);
  if (OpenArchiveData.OpenResult<>0) then
     begin
      MessageBox(dlgExtract.Handle,'Archive is corrupt!','Error',MB_OK+MB_ICONEXCLAMATION);
      RARCloseArchive(hArcData);
      exit;
     end;
  RARSetChangeVolProc(hArcData,ChangeVolProc);
  HeaderData.CmtBuf:=NIL;
  {Maximum:=0;
  GlobalUnPackSize:=0; }
  FileCount:=0;
  Current:=0;
  While RARReadHeader(hArcData, HeaderData) <> ERAR_END_ARCHIVE do
    Begin
      RARProcessFile(hArcData,RAR_OM_LIST,Nil,Nil);
      Inc(FileCount);
    End;
  hArcData:=RAROpenArchive(OpenArchiveData);
  RARSetChangeVolProc(hArcData,ChangeVolProc);
  HeaderData.CmtBuf:=NIL;
  RHCode:=RARReadHeader(hArcData,HeaderData);
  {Inc(GlobalUnPackSize, HeaderData.UnpSize);}
  Inc(Current);
  while RHCode<>ERAR_END_ARCHIVE do
  begin
    If dlgExtract._Abort Then
      Begin
        //dlgProgress.Close;
        //dlgProgress.Free;
        //Self.Enabled:=True;
        RARCloseArchive(hArcData);
        Exit;
      End;
    {If (Not GetBoolOptions('Config','EnableSecurity',False))Then
        If (Not NameInMask(GetStringOptions('Config','ExcludeExt','*.exe;*.com;*.bat'),HeaderData.FileName)) Then}
          dlgExtract.OnExtract(dlgExtract,ShortString(HeaderData.FileName));
          PFCode:=RARProcessFile(hArcData,RAR_EXTRACT,PChar(DestDir),Nil);
    {Inc(GlobalUnPackSize, HeaderData.PackSize);}
    Inc(Current);
    if PFCode<>0 then
       begin
        MessageBox(dlgExtract.Handle,'Coud not open file','Error',MB_OK+MB_ICONSTOP);
        RARCloseArchive(hArcData);
        exit;
       end;
    RHCode:=RARReadHeader(hArcData,HeaderData);
    {dlgProgress.pbFile.Position:=GetPercentDone(0,GlobalUnPackSize,Maximum);}
    {dlgProgress.pbArchive.Position:=GetPercentDone(0,Current,FileCount);
    dlgProgress.lbFileIndex.Caption:=Format('File index %d',[Current]);
    dlgProgress.lbCurrent.Caption:='';
    dlgProgress.lbTotal.Caption:=Format('Total progress %d',[dlgProgress.pbArchive.Position]);
    dlgProgress.Update;}
    dlgExtract.pbProgress.Position:=GetPercentDone(0,Current,FileCount);
    Application.ProcessMessages;
  end;
  if (RHCode=ERAR_BAD_DATA) then
    MessageBox(dlgExtract.Handle,'Archive is corrupt','Attention',MB_OK+MB_ICONEXCLAMATION);
  RARCloseArchive(hArcData);
  {dlgProgress.Close;
  dlgProgress.Free;
  Self.Enabled:=True;}
End;

procedure TdlgExtract.btnCancelClick(Sender: TObject);
begin
  _Abort:=True;
  Close;
end;

procedure TDlgExtract.OnProgress(Sender:TObject;FProgress,AProgress:Byte;Var Abort:Boolean);
begin
  pbProgress.Position:=AProgress;
  Abort:=Abort;
end;

procedure TDlgExtract.OnExtract(Sender:TObject;_FileName:ShortString);
begin
  memComment.Lines.Add(_FileName);
end;

procedure TDlgExtract.GetPass(Sender:TObject;Var Pass:ShortString);
Var Temp:String;
Begin
  Temp:='';
  If InputQuery('Password','Enter password',Temp) Then
    Pass:=Temp
End;

procedure TDlgExtract.OnError(Sender:TObject;ErrorMsg:ShortString);
Var S:string;
Begin
  S:=ErrorMsg;
  MessageBox(Handle,PChar(S),PChar('WinMZF'),MB_OK+MB_ICONEXCLAMATION);
End;

procedure TDlgExtract.RewritePromt(Sender:TObject;Var AFile:TFileHead;Var Mode:TReWriteMode);
Begin
  Application.CreateForm(TDlgOverWrite,DlgOverWrite);
  DlgOverWrite.Label2.Caption:=Format('File name: %s',[ExtractFileName(AFile.LongFileName)]);
  DlgOverWrite.Label3.Caption:=Format('File size: %d',[AFile.Size]);
  DlgOverWrite.Label4.Caption:=Format('File attr: %s',[GetAttributesAsString(AFile.Attr)]);
  DlgOverWrite.Label5.Caption:=Format('File creation date: %s',[FormatDateTime(TimeFormat,AFile.FileCreateDate)]);
  DlgOverWrite.Label6.Caption:=Format('File modify date: %s',[FormatDateTime(TimeFormat,AFile.FileModifyDate)]);
  DlgOverWrite.Label7.Caption:=Format('File access date: %s',[FormatDateTime(TimeFormat,AFile.FileOpenDate)]);

  DlgOverWrite.ShowModal;
  If DlgOverWrite.OverWrite Then
    Begin
      If DlgOverWrite.All Then
        Mode:=omOverwriteAll Else
        Mode:=omRewrite;
    End Else
      Begin
        If DlgOverWrite.All Then
          Mode:=omSkipAll Else
          Mode:=omSkip;
      End;
  DlgOverWrite.Free;
End;

procedure TdlgExtract.btnExtractClick(Sender: TObject);
var MZFDecompressor:TMZFDecompressor;
    Unpacker:TUnPacker;
begin
  btnExtract.Enabled:=False;
  Case Self.ArcType Of
    ftMZF:
      Begin
        memComment.Clear;
        MZFDecompressor:=TMZFDecompressor.Create;
        MZFDecompressor.DestinationDir:=cbDestDir.Text;
        MZFDecompressor.ExcludeSpec:='';
        MZFDecompressor.EnableSecurityMode:=False;
        MZFDecompressor.OnProgress:=OnProgress;
        MZFDecompressor.OnGetPass:=GetPass;
        MZFDecompressor.OnOverwritePrompt:=RewritePromt;
        MZFDecompressor.OnError:=OnError;
        MZFDecompressor.ExtractAll:=True;
        MZFDecompressor.OnExtract:=OnExtract;
        MZFDecompressor.Extract(MZFArchive);
        MZFDecompressor.Free;
      End;
    ftRar:
      Begin
        LoadDll(hInstance);
        memComment.Clear;
        RarExtract(PChar(Application.ExeName),cbDestDir.Text);
        FreeDll;
      End;
    ftAce2,ftArc,ftArj,ftBh,ftCab,ftGZip,ftJar,ftLha,ftTar,ftZip,ftZoo:
      Begin
        Unpacker:=TUnpacker.Create;
        Unpacker.OnProgress:=OnProgress;
        Unpacker.OnGetPassword:=GetPass;
        Unpacker.OnFileExists:=RewritePromt;
        Unpacker.OnExtract:=OnExtract;
        Unpacker.ArchiveFile:=Application.ExeName;
        Unpacker.DestinationDir:=cbDestDir.Text;
        Unpacker.ArchiveType:=ArcType;
        Unpacker.FileSpec.Add('*.*');
        Unpacker.Extract;
        Unpacker.Free;
      End;
  End;
  btnExtract.Enabled:=True;
  Application.Terminate;
end;

procedure TdlgExtract.btnBrowsClick(Sender: TObject);
var Temp:String;
begin
  Temp:=GetSelectedDir;
  If Temp<>'' Then
    cbDestDir.Text:=Temp;
end;

procedure TdlgExtract.FormCreate(Sender: TObject);
var _Self:TMemoryStream;
    SFXHead:TSFXhead;
    _Pos:LongWord;
    Temp:TStream;
    _S:TArcHead;
    z:array[0..2]of char;
begin
  _Abort:=False;
  SFXHead.ArchType:=ftAnyFile;
  Caption:='WinMZF Self extraction archive';
  Application.Title:=Caption;
  cbDestDir.Text:=ExtractFileDir(Application.ExeName);
  _Self:=TMemoryStream.Create;
  _Self.LoadFromFile(Application.ExeName);
  _Self.Position:=0;
  For _Pos:=0 To _Self.Size Do
    Begin
      _Self.Read(SFXHead,SizeOf(TSFXhead));
      If (SFXHead.Signature=Sign)And(SFXHead.Vendor=VID) Then
        Break;
      _Self.Position:=_Pos;
    End;
  If (SFXHead.Signature<>Sign)Or(SFXHead.Vendor<>VID) Then
    Halt;
  Caption:=SFXHead.WndCaption;
  Application.Title:=Caption;
  cbDestDir.Text:=SFXHead.ExtractDir;
  ArcType:=SFXHead.ArchType;
  Case SFXHead.ArchType Of
    ftMZF:
      Begin
        MZFArchive:=TMemoryStream.Create;
        MZFArchive.CopyFrom(_Self,_Self.Size-(_Pos+SizeOf(TSFXhead)-1));
        MZFArchive.Position:=0;
      End;
    {ftAce2,ftArc,ftArj,ftBh,ftCab,ftGZip,ftJar,ftLha,ftTar,ftZip,ftZoo:;
    ftRar:;}
    ftAnyFile:Halt;
  End;
end;

end.
