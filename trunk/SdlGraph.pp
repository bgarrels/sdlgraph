Unit SDLGraph;

interface

{ Public things and function prototypes }

Const

   SDLgraph_version = '0.1';


{ Constants for mode selection }

   Detect=0;
   D1bit = 11;
   D2bit = 12;
   D4bit = 13;
   D6bit = 14;  { 64 colors Half-brite mode - Amiga }
   D8bit = 15;
   D12bit = 16; { 4096 color modes HAM mode - Amiga }
   D15bit = 17;
   D16bit = 18;
   D24bit = 19; { not yet supported }
   D32bit = 20; { not yet supported }
   D64bit = 21; { not yet supported }

   lowNewDriver = 11;
   highNewDriver = 21;

   detectMode = 30000;
   m320x200 = 30001;
   m320x256 = 30002; { amiga resolution (PAL) }
   m320x400 = 30003; { amiga/atari resolution }
   m512x384 = 30004; { mac resolution }
   m640x200 = 30005; { vga resolution }
   m640x256 = 30006; { amiga resolution (PAL) }
   m640x350 = 30007; { vga resolution }
   m640x400 = 30008;
   m640x480 = 30009;
   m800x600 = 30010;
   m832x624 = 30011; { mac resolution }
   m1024x768 = 30012;
   m1280x1024 = 30013;
   m1600x1200 = 30014;
   m2048x1536 = 30015;
   sdlgraph_windowed
             = 100000; {This constant can be used to point, that we want to use windowed graph mode, instead of fullscreen.
			Usage: when setting video mode variable, you should add it to mode constant. (like blink colors made in TP Graph)
			Example: GM:=m800x600+sdlgraph_windowed;
			Do you like an idea?}

   lowNewMode = 30001;
   highNewMode = 30015;



  Procedure InitGraph (var GraphDriver,GraphMode : integer; const PathToDriver : string);

  Procedure CloseGraph;

  function GraphResult: SmallInt;

  function GraphErrorMsg(ErrorCode: SmallInt):String;

implementation
  Uses SDL, SDL_video, SDL_types;

  Var screen:PSDL_Surface;
      sdlgraph_graphresult:SmallInt;

    function GraphResult: SmallInt;
      Begin
        GraphResult:=sdlgraph_graphresult;
      End;

    function GraphErrorMsg(ErrorCode: SmallInt):String;
      Begin
        case sdlgraph_graphresult of
          0:  GraphErrorMsg:='Everything is OK';
          -1: GraphErrorMsg:='Detect has not found proper graphic mode';
          End;
      End;
    Procedure InitGraph(var GraphDriver,GraphMode : integer; const PathToDriver : string);
      Var width, height, bpp:Integer;
	  flags:Uint32;
	  ra: PSDL_RectArray;
      Begin
	flags:=SDL_HWSURFACE;
        SDL_Init(SDL_INIT_VIDEO);

	if(GraphMode>=sdlgraph_windowed) then
	  Dec(GraphMode, sdlgraph_windowed)
	else
	  flags:= flags or SDL_FULLSCREEN;
	if GraphDriver=Detect then
	  Begin
  	    ra:= SDL_ListModes(Nil, flags);
            if(ra=Nil) then
              Begin
              sdlgraph_graphresult:=-1;
              Exit;
              End
            else
              Begin
              with ra[0][0] do
                Begin
                width:=w;
                height:=h;
                End;
              bpp:=0;
              End;
	  End
	else
	  Begin
		case GraphDriver of
		  D16bit: bpp:=16;
		  D24bit: bpp:=24;
		  D32bit: bpp:=32;
		  End;
		case GraphMode of
		  m800x600:
	            Begin
		      width:=800;
		      height:=600;
		    End;
		  m1024x768:
	            Begin
		      width:=1024;
		      height:=768;
		    End;
		  End;
	  End;
        screen:=SDL_SetVideoMode(width, height, bpp, flags);
        sdlgraph_graphresult:=0;
      End;

    Procedure CloseGraph;
      Begin
        SDL_Quit;
      End;
Begin
  screen:=Nil;
End.