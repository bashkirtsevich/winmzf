unit UniversalUnpacker_u;

interface

Uses ztvBase, ztvUnACE2,Classes,Advanced,SysUtils,Forms,SignatureDetect_u,
     Decompress_u, ztvGbls, ztvUnArc, ztvUnArj, ztvUnBh,ztvUnCab,ztvUnZip,
     ztvUnJar,ztvUnZoo,ztvUnGZip,ztvUnLha,ztvUnTar;

Type TUnPackerProgress=procedure (Sender:TObject;FProgress,AProgress:Byte;Var Abort:Boolean) of object;
Type TPassQuest=procedure (Sender:TObject;Var Pass:ShortString)of object;
Type TOverWritePrompt=procedure (Sender:TObject;Var AFile:TFileHead;Var Mode:TReWriteMode)of object;
Type TOnExtract=procedure (Sender:TObject;_FileName:ShortString)of object;
//Type TOverWriteMode=(omOverwrite,omSkip);


Type TUnPacker=Class (TComponent)
  Private
    AbortSignal:Boolean;
    UnACE : TUnACE;
    UnArc : TUnArc;
    UnArj : TUnArj;
    UnBh  : TUnBh;
    UnCab : TUnCab;
    UnGZip: TUnGZip;
    UnJar : TUnJar;
    UnLha : TUnLha;
    UnTar : TUnTar;
    UnZip : TUnZip;
    UnZoo : TUnZoo;
    //ExtractComponent: TUnBase;       (* Base class for decompression components *)
 	  //CompressComponent: TCompBase;
    fArchiveType:TFileType;
    fArchiveFileName:String;
    fDestDir:String;
    fOnBegin:TNotifyEvent;
    fOnEnd:TNotifyEvent;
    fOnProgress:TUnPackerProgress;
    fOnGetPassword:TPassQuest;
    fOnFileExists:TOverWritePrompt;
    fFileSpec:TStringList;
    fOverWriteMode:TReWriteMode;
    fDeleteAfterExtract:Boolean;
    fSecurity:Boolean;
    fExclude:String;
    fOnExtract:TOnExtract;
  Public
    constructor Create;
    procedure Free;
    destructor Destroy;
    property ArchiveType:TFileType read fArchiveType write fArchiveType;
    property ArchiveFile:String read fArchiveFileName write fArchiveFileName;
    property DestinationDir:String read fDestDir write fDestDir;
    property FileSpec:TStringList read fFileSpec write fFileSpec;
    property OverWriteMode:TReWriteMode read fOverWriteMode write fOverWriteMode;
    property DeleteAfterExtract:Boolean read fDeleteAfterExtract write fDeleteAfterExtract;
    property OnProgress:TUnPackerProgress read fOnProgress write fOnProgress;
    property OnGetPassword:TPassQuest read fOnGetPassword write fOnGetPassword;
    property OnFileExists:TOverWritePrompt read fOnFileExists write fOnFileExists;
    property OnBegin:TNotifyEvent read fOnBegin write fOnBegin;
    property OnEnd:TNotifyEvent read fOnEnd write fOnEnd;
    property EnableSecurity:Boolean read fSecurity write fSecurity;
    property ExcludeExt:String read fExclude write fExclude;
    property OnExtract:TOnExtract read fOnExtract write fOnExtract;
    procedure Extract;
  Protected
    procedure DecompressorsBegin(Sender: TObject; FileName: String;
                                 Count: Integer; var Extract: Boolean);
    procedure DecompressorsEnd(Sender: TObject; FileName: String;
                               CRC_PASS: Boolean);
    procedure DecompressorProgress(Sender: TObject; ProgressByFile,
                                   ProgressByArchive: Byte);
    procedure DecompressorGetPassword(Sender: TObject; FileName: String;
                                      var Password: String; var TryAgain: Boolean);
    procedure DecompressorsOnFileExists(Sender: TObject; FileName: String;
                                        var NewFileName: String; var OverwriteMode: TOverwriteMode);
    procedure FileSpeFillExtractors;
  End;

implementation

constructor TUnPacker.Create;
Begin
  AbortSignal:=False;
  UnACE := TUnACE.Create(Nil);
  UnArc := TUnArc.Create(Nil);
  UnArj := TUnArj.Create(Nil);
  UnBh  := TUnBh.Create(Nil);
  UnCab := TUnCab.Create(Nil);
  UnGZip:= TUnGZip.Create(Nil);
  UnJar := TUnJar.Create(Nil);
  UnLha := TUnLha.Create(Nil);
  UnTar := TUnTar.Create(Nil);
  UnZip := TUnZip.Create(Nil);
  UnZoo := TUnZoo.Create(Nil);
  //ExtractComponent:=TUnBase.Create(Nil);
  fFileSpec:=TStringList.Create;
End;

procedure TUnPacker.DecompressorsBegin(Sender: TObject; FileName: String;
  Count: Integer; var Extract: Boolean);
Begin
  if Assigned(fOnExtract) then
    fOnExtract(Self,FileName);
End;

procedure TUnPacker.DecompressorsEnd(Sender: TObject; FileName: String;
  CRC_PASS: Boolean);
Begin
  {If Assigned(fOnEnd) Then
    fOnEnd(Self);}
End;

procedure TUnPacker.DecompressorProgress(Sender: TObject; ProgressByFile,
  ProgressByArchive: Byte);
Begin
  If Assigned(fOnProgress) Then
    fOnProgress(Self,ProgressByFile,ProgressByArchive,AbortSignal);
    application.ProcessMessages;
    //
    //ExtractComponent.Cancel:=AbortSignal;
    UnACE.Cancel:=AbortSignal;
    UnArc.Cancel:=AbortSignal;
    UnArj.Cancel:=AbortSignal;
    UnBh.Cancel:=AbortSignal;
    UnCab.Cancel:=AbortSignal;
    UnGZip.Cancel:=AbortSignal;
    UnJar.Cancel:=AbortSignal;
    UnLha.Cancel:=AbortSignal;
    UnTar.Cancel:=AbortSignal;
    UnZip.Cancel:=AbortSignal;
    UnZoo.Cancel:=AbortSignal;
End;

procedure TUnPacker.DecompressorGetPassword(Sender: TObject; FileName: String;
  var Password: String; var TryAgain: Boolean);
Var TempPass:ShortString;
Begin
  If Assigned(fOnGetPassword) Then
    Begin
      fOnGetPassword(Self,TempPass);
      Password:=TempPass;
    End;
End;

procedure TUnPacker.DecompressorsOnFileExists(Sender: TObject; FileName: String;
  var NewFileName: String; var OverwriteMode: TOverwriteMode);
Var FileHead:TFileHead;
Begin
  If fOverWriteMode=omOverwriteAll Then
    Begin
      OverwriteMode:=TOverwriteMode(omRewrite);
      Exit;
    End;
  If fOverWriteMode=omSkipAll Then
    Begin
      OverwriteMode:=TOverwriteMode(omSkip);
      Exit;
    End;
  If Assigned(fOnFileExists)Then
    Begin
      FileHead.LongFileName:=FileName;
      fOnFileExists(Self,FileHead,fOverWriteMode);
      If fOverWriteMode=omRewrite Then OverwriteMode:=TOverwriteMode(omRewrite);
      If fOverWriteMode=omSkip Then OverwriteMode:=TOverwriteMode(omSkip);

    End;
End;

procedure TUnpacker.FileSpeFillExtractors;
Var Index:Word;
    Temp:String;
Begin
  //ExtractComponent.FileSpec.Clear;
  For Index:=0 To fFileSpec.Count-1 Do
    Begin
      Temp:=fFileSpec.Strings[Index];
      //ExtractComponent.FileSpec.Add(Temp);
      UnACE.FileSpec.Add(Temp);
      UnArc.FileSpec.Add(Temp);
      UnArj.FileSpec.Add(Temp);
      UnBh.FileSpec.Add(Temp);
      UnCab.FileSpec.Add(Temp);
      UnGZip.FileSpec.Add(Temp);
      UnJar.FileSpec.Add(Temp);
      UnLha.FileSpec.Add(Temp);
      UnTar.FileSpec.Add(Temp);
      UnZip.FileSpec.Add(Temp);
      UnZoo.FileSpec.Add(Temp);
    End;
End;

procedure TUnPacker.Extract;
{Var OverWriteMode:TOverWriteMode;}
var ExcludeSpec:TStringList;
    Index:LongWord;
Begin
  If Assigned(fOnBegin) Then
    fOnBegin(Self);
  //
  If fSecurity Then
    FillListWithMask(ExcludeSpec,fExclude);
  FileSpeFillExtractors;
  //fOverWriteMode
  {UnACE.OverwriteMode:=fOverWriteMode;
  UnArc.OverwriteMode:=fOverWriteMode;
  UnArj.OverwriteMode:=fOverWriteMode;
  UnBh.OverwriteMode:=fOverWriteMode;
  UnCab.OverwriteMode:=fOverWriteMode;
  UnGZip.OverwriteMode:=fOverWriteMode;
  UnJar.OverwriteMode:=fOverWriteMode;
  UnLha.OverwriteMode:=fOverWriteMode;
  UnTar.OverwriteMode:=fOverWriteMode;
  UnZip.OverwriteMode:=fOverWriteMode;
  UnZoo.OverwriteMode:=fOverWriteMode; }
  //
  //ExtractComponent.OnBegin:=DecompressorsBegin;
  UnACE.OnBegin:=DecompressorsBegin;
  UnArc.OnBegin:=DecompressorsBegin;
  UnArj.OnBegin:=DecompressorsBegin;
  UnBh.OnBegin:=DecompressorsBegin;
  UnCab.OnBegin:=DecompressorsBegin;
  UnGZip.OnBegin:=DecompressorsBegin;
  UnJar.OnBegin:=DecompressorsBegin;
  UnLha.OnBegin:=DecompressorsBegin;
  UnTar.OnBegin:=DecompressorsBegin;
  UnZip.OnBegin:=DecompressorsBegin;
  UnZoo.OnBegin:=DecompressorsBegin;
  //
  //ExtractComponent.OnEnd:=DecompressorsEnd;
  UnACE.OnEnd:=DecompressorsEnd;
  UnArc.OnEnd:=DecompressorsEnd;
  UnArj.OnEnd:=DecompressorsEnd;
  UnBh.OnEnd:=DecompressorsEnd;
  UnCab.OnEnd:=DecompressorsEnd;
  UnGZip.OnEnd:=DecompressorsEnd;
  UnJar.OnEnd:=DecompressorsEnd;
  UnLha.OnEnd:=DecompressorsEnd;
  UnTar.OnEnd:=DecompressorsEnd;
  UnZip.OnEnd:=DecompressorsEnd;
  UnZoo.OnEnd:=DecompressorsEnd;
  //
  //ExtractComponent.OnProgress:=DecompressorProgress;
  UnACE.OnProgress:=DecompressorProgress;
  UnArc.OnProgress:=DecompressorProgress;
  UnArj.OnProgress:=DecompressorProgress;
  UnBh.OnProgress:=DecompressorProgress;
  UnCab.OnProgress:=DecompressorProgress;
  UnGZip.OnProgress:=DecompressorProgress;
  UnJar.OnProgress:=DecompressorProgress;
  UnLha.OnProgress:=DecompressorProgress;
  UnTar.OnProgress:=DecompressorProgress;
  UnZip.OnProgress:=DecompressorProgress;
  UnZoo.OnProgress:=DecompressorProgress;
  //
  //ExtractComponent.OnGetPassword:=DecompressorGetPassword;
  UnACE.OnGetPassword:=DecompressorGetPassword;
  UnArj.OnGetPassword:=DecompressorGetPassword;
  UnBH.OnGetPassword:=DecompressorGetPassword;
  UnJar.OnGetPassword:=DecompressorGetPassword;
  UnZip.OnGetPassword:=DecompressorGetPassword;
  //
  //ExtractComponent.ArchiveFile:=fArchiveFileName;
  UnACE.ArchiveFile:=fArchiveFileName;
  UnArc.ArchiveFile:=fArchiveFileName;
  UnArj.ArchiveFile:=fArchiveFileName;
  UnBh.ArchiveFile:=fArchiveFileName;
  UnCab.ArchiveFile:=fArchiveFileName;
  UnGZip.ArchiveFile:=fArchiveFileName;
  UnJar.ArchiveFile:=fArchiveFileName;
  UnLha.ArchiveFile:=fArchiveFileName;
  UnTar.ArchiveFile:=fArchiveFileName;
  UnZip.ArchiveFile:=fArchiveFileName;
  UnZoo.ArchiveFile:=fArchiveFileName;
  //
  //ExtractComponent.ExtractDir:=fDestDir;
  UnACE.ExtractDir:=fDestDir;
  UnArc.ExtractDir:=fDestDir;
  UnArj.ExtractDir:=fDestDir;
  UnBh.ExtractDir:=fDestDir;
  UnCab.ExtractDir:=fDestDir;
  UnGZip.ExtractDir:=fDestDir;
  UnJar.ExtractDir:=fDestDir;
  UnLha.ExtractDir:=fDestDir;
  UnTar.ExtractDir:=fDestDir;
  UnZip.ExtractDir:=fDestDir;
  UnZoo.ExtractDir:=fDestDir;
  If fSecurity Then
    For Index:=0 To ExcludeSpec.Count-1 Do
      Begin
        UnACE.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnArc.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnArj.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnBh.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnCab.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnGZip.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnJar.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnLha.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnTar.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnZip.ExcludeSpec.Add(ExcludeSpec[Index]);
        UnZoo.ExcludeSpec.Add(ExcludeSpec[Index]);
      End;
  Case fArchiveType Of
    ftZoo:UnZoo.Extract;
    ftTar:UnTar.Extract;
    ftLha:UnLha.Extract;
    ftZip:UnZip.Extract;
    ftJar:UnJar.Extract;
    ftGZip:UnGZip.Extract;
    ftCab:UnCab.Extract;
    ftBH:UnBH.Extract;
    ftARJ:UnArj.Extract;
    ftArc:UnArc.Extract;
  End;
  //ExtractComponent.Extract;
  If Assigned(fOnEnd) Then
    fOnEnd(Self);
  If fDeleteAfterExtract Then
    Begin
      FileSetAttr(Self.ArchiveFile,0);
      DeleteFile(Self.ArchiveFile);
    End;
End;

procedure TUnPacker.Free;
Begin
  If Self<>Nil Then
    Destroy;
End;

destructor TUnPacker.Destroy;
Begin
  UnACE.Free;
  UnArc.Free;
  UnArj.Free;
  UnBh.Free;
  UnCab.Free;
  UnGZip.Free;
  UnJar.Free;
  UnLha.Free;
  UnTar.Free;
  UnZip.Free;
  UnZoo.Free;
  //ExtractComponent.Free;
End;

end.
