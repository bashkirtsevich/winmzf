ÿ
 TOTPFORM 0Ò  TPF0TOTPFormOTPFormLeftÍ Top BorderIconsbiSystemMenu
biMinimize BorderStylebsSingleCaptionRFC2289/2444 One Time PasswordClientHeight1ClientWidthFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Heightõ	Font.NameMS Sans Serif
Font.Style PositionpoScreenCenterOnClose	FormCloseOnCreate
FormCreatePixelsPerInch`
TextHeight TShapeShape1LeftTopWidthÙ Height)Brush.ColorclBlue	Pen.ColorclWhite	Pen.StylepsDot  TLabelLabel1LeftTopWidth HeightCaptionClient (means You)Font.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Heightó	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTransparent	  TShapeShape3Left(TopWidthÙ Height)Brush.ColorclRed	Pen.ColorclWhite	Pen.StylepsDot  TShapeShape4Left,TopWidthÑ HeightoBrush.Color	clBtnFace	Pen.StylepsClearShapestRoundRect  TLabelLabel2Left,TopWidtheHeightCaptionSever to LoginFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Heightó	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTransparent	  TShapeShape5LeftTopWidthÑ HeightoBrush.Color	clBtnFace	Pen.StylepsClearShapestRoundRect  TLabelLabel6LeftTop WidthkHeightCaptionInput Your Passphrase  TShapeShape2Leftô TopWidthHeight)	Pen.StylepsDot  TLabelLabel3Leftø TopWidthÁ HeightCaptionInsecure Channel (the WEB)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Heightó	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTransparent	  TLabelLabel4Left0Top)WidthHeightCaptionSeed:  TLabelLabel5LeftTop)Width0HeightCaption	Accounts:  TLabelLabel8Left0TopAWidthHeightCaptionIdent:  TLabelLabel9Left0TopYWidthHeightCaptionHash:  TLabelLabel7Left0ToptWidth+HeightCaptionAccount:  TLabelLAccountLeft`ToptWidthHeightCaption0  TShapeShape6Leftà TopWidthHeight)Brush.ColorclSilver	Pen.StylepsDot  TShapeShape7LeftTopWidthHeight)Brush.ColorclSilver	Pen.StylepsDot  TImageImage1Leftà Top WidthHeightCenter	Picture.Data
  TBitmapö   BMö       v   (                                                ÀÀÀ   ÿ ÀÀÀ  ÿÿ ÿ   ÀÀÀ ÿÿ  ÿÿÿ à    îîîîîàîîîîà    îàTransparent	  TImageImage2LeftTop WidthHeightCenter	Picture.Data
  TBitmapö   BMö       v   (                                                ÀÀÀ   ÿ ÀÀÀ  ÿÿ ÿ   ÀÀÀ ÿÿ  ÿÿÿ à    îîîîîàîîîîà    îàTransparent	  TImageImage3Leftà Top WidthHeightCenter	Picture.Data
  TBitmapö   BMö       v   (                                                ÀÀÀ   ÿ ÀÀÀ  ÿÿ ÿ   ÀÀÀ ÿÿ  ÿÿÿ î    îîîîàîîîîàî    Transparent	  TImageImage4LeftTopWidthHeightCenter	Picture.Data
  TBitmapö   BMö       v   (                                                ÀÀÀ   ÿ ÀÀÀ  ÿÿ ÿ   ÀÀÀ ÿÿ  ÿÿÿ î    îîîîàîîîîàî    Transparent	  TLabelLabel10Leftü TopWidthì HeightCursorcrHandPointCaption(View RFC1760,RFC1938,RFC2289 and RFC2444Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Heightõ	Font.NameMS Sans Serif
Font.StylefsUnderline 
ParentFontTransparent	OnMouseDownLabel10MouseDown  TButtonBtnLoginLeftTopHWidth]HeightCaptionLog inTabOrder OnClickDoLoginClick  TEdit	EPasswordLeftTop0Width½ HeightTabOrderTextDelphi Encryption CompendiumOnChangeEPasswordChange  	TRichEdit
ClientInfoLeftTop WidthÑ Height BorderStylebsNoneColorclBlueFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Heightõ	Font.NameMS Sans Serif
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrder  	TRichEdit
ServerInfoLeft,Top WidthÑ Height BorderStylebsNoneColorclRedFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Heightõ	Font.NameMS Sans Serif
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrder  	TRichEditChannelInfoLeftü TopWidthHeightù BorderStylebsNoneColorclWhiteLines.Strings2This demonstrate the Work of the TOneTimePassword 0Component. One Time Passwords (short OTP's) are 3used in many Login Protocols. The here implemented 'Version is RFC1760,RFC1938,RFC2289 and RFC2444 Standard compatible. The Trick is follow:6A Client build from a secure Password (> 9 Chars) and -any Seed (> 0 Chars) with a Hash Function an 2InitialSeed S0. From these S0 was computed S1 and 5so on. The latest computed SX (X is the Count from a 3Challenge) is the first used Password, SX-1 is the 7second and so on. Only the Client can compute the full 3Table of all SX's. Now, the Server stores the last 5Clientpassword, the new Clientpassword SX is used on 5the Server as S0 and these can compute SX+1, iff the 5SX+1 equal with the last,stored, Clientpassword then accepts the Server the Login. 
ScrollBars
ssVerticalTabOrder  	TCheckBoxCBPassphraseCheckLeftTopbWidthµ HeightCaptionCheck Passphrase on the ClientTabOrder  TEditESeedLeftTTop%Width5HeightTabOrderTextDEC01OnChangeServerParamsChange  TEditEAccountLeftÈTop%Width)HeightTabOrderText10OnChangeServerParamsChange  	TCheckBoxCBExtLeftTop?WidthiHeightCaptionRFC2444 FormatTabOrderOnClickServerParamsChange  	TComboBoxEIdentLeftTTop=Width5Height
ItemHeightItems.Stringsotp-s/key TabOrder	Textotp-OnChangeServerParamsChangeOnClickServerParamsChange  	TComboBoxCBHashLeftTTopUWidth HeightStylecsDropDownListDropDownCount
ItemHeightTabOrder
OnChangeServerParamsChangeOnClickServerParamsChange  	TCheckBoxCBFormatLeftTopuWidthÀ HeightCaptionuse RFC1760 Six Word FormatTabOrderOnClickCBFormatClick  TButtonBtnPassphrasesLeftpTopHWidth]HeightCaptionPasswordlistTabOrderOnClickBtnPassphrasesClick  TOneTimePassword	ClientOTPFormat	Challengeotp-MD4 0 4805 extLeftTop  TOneTimePassword	ServerOTPFormat(	Challengeotp-MD5 0 DEC01 extLeft0Top   