{ This unit exposes a class with a published section,
  containing the methods we want to share with python. }
{$mode objfpc}{$M+}
unit uhellopy;
interface

type
  THelloPy = class
    published
      class function SumTwoIntegers(x, y : Int32) : Int32;
    end;

implementation

class function THelloPy.SumTwoIntegers(x,y : Int32) : Int32;
  begin
    result := x + y
  end;

begin
end.
