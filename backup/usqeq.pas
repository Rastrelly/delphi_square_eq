unit usqeq;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  TAGraph, TASeries;

type

  { TForm1 }

  point2 = record
    x,y:real;
  end;

  TForm1 = class(TForm)
    L_B: TLabel;
    vert_0: TLineSeries;
    hor_0: TLineSeries;
    edX1: TEdit;
    edX2: TEdit;
    Root1: TLabel;
    Root2: TLabel;
    Solve: TButton;
    L_C: TLabel;
    Chart1: TChart;
    edA: TEdit;
    edB: TEdit;
    edC: TEdit;
    L_A: TLabel;
    series_roots: TLineSeries;
    series_func: TLineSeries;
    Panel1: TPanel;
    procedure SolveClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  funcArr:array of point2;

  a,b,c:real;
  roots:point2;
  root1p:point2;
  root2p:point2;
  sol:boolean;

implementation


procedure solver(a,b,c:real; var x1,x2:real; var has_solution:boolean);
var d:real;
begin
  if (a<>0) then
  begin
    d:=sqr(b)-4*a*c;
    if (d>0) then
    begin
      x1:=(-b-sqrt(d))/(2*a);
      x2:=(-b+sqrt(d))/(2*a);
      has_solution:=true;
    end
    else
    begin
      x1:=0; x2:=0; has_solution:=false;
    end;
  end
  else
  begin
    x1:=0; x2:=0; has_solution:=false;
  end;
end;

function func(a,b,c,x:real):real;
begin
  result:=a*sqr(x)+b*x+c;
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.SolveClick(Sender: TObject);
var canwork:boolean;
    rd,cx1,cx2,step:real;
    i:integer;
    do_h,do_v:boolean;
    cx,cy,ymin,ymax:real;
begin
  canwork:=TryStrToFloat(edA.text,a);
  if(canwork) then
  canwork:=TryStrToFloat(edB.text,b);
  if (canwork) then
  canwork:=TryStrToFloat(edC.text,c);
  if (canwork) then
  begin
    solver(a,b,c,roots.x,roots.y,sol);
  end
  else
  begin
    sol:=false;
  end;

  series_roots.Clear;
  if(sol) then
  begin
    root1p.x:=roots.x;
    root1p.y:=func(a,b,c,root1p.x);
    root2p.x:=roots.y;
    root2p.y:=func(a,b,c,root2p.x);
    series_roots.AddXY(root1p.x,root1p.y);
    series_roots.AddXY(root2p.x,root2p.y);
  end;

  cx1:=-10; cx2:=10;
  if (sol) then
  begin
    rd:=(abs(root1p.x-root2p.x)/2);
    if(root1p.x>root2p.x) then
    begin
      cx1:=root2p.x-rd;
      cx2:=root1p.x+rd;
    end
    else
    begin
      cx1:=root1p.x-rd;
      cx2:=root2p.x+rd;
    end;
  end;

  step:=abs(cx2-cx1)/100;

  SetLength(funcArr, 101);

  series_func.Clear;

  for i:=0 to 100 do
  begin
    cx:=cx1+i*step;
    cy:=func(a,b,c,cx);
    series_func.AddXY(cx,cy);
    if (i=0) then
    begin
      ymin:=cy; ymax:=cy;
    end
    else
    begin
      if cy<ymin then ymin:=cy;
      if cy>ymax then ymax:=cy;
    end;
  end;

  hor_0.Clear;
  vert_0.Clear;

  do_v:=false;
  do_h:=false;

  if(cx1<0) and (cx2>0) then do_v:=true;
  if(ymin<0) and (ymax>0) then do_h:=true;

  if (do_h or not sol) then
  begin
    hor_0.AddXY(cx1,0);
    hor_0.AddXY(cx2,0);
  end;

  if (do_v and sol) then
  begin
    vert_0.AddXY(0,ymin);
    vert_0.AddXY(0,ymax);
  end;

  if (do_v and not sol) then
  begin
    if ((ymin<0) and (ymax<0)) then
    begin
      vert_0.AddXY(0,ymin);
      vert_0.AddXY(0,0);
    end;
    if ((ymin>0) and (ymax>0)) then
    begin
      vert_0.AddXY(0,0);
      vert_0.AddXY(0,ymax);
    end;
  end;

  if (sol) then
  begin
    edX1.Text:=floattostr(roots.x);
    edX2.Text:=floattostr(roots.y);
    edX1.Color:=clLime;
    edX2.Color:=clLime;
  end
  else
  begin
    edX1.Text:='NaN';
    edX2.Text:='NaN';
    edX1.Color:=clRed;
    edX2.Color:=clRed;
  end;

end;

end.

