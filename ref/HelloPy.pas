library HelloPy;
{$MODE OBJFPC}
{ Minimal Python module (library) that includes a single function.

  Author: Phil (MacPgmr at fastermac.net).
  http://wiki.freepascal.org/Developing_Python_Modules_with_Pascal
  
  Modified by Michal J Wallace <http://tangentstorm.com/>
  - I moved the simple addition function into a separate unit,
    with the intent of regenerating this python module
    automatically based on the output of ppudump. }
uses
  SysUtils,
  uhellopy,
  PyAPI;

function SumTwoIntegers(Self : PyObject; Args : PyObject)
  : PyObject; cdecl;
var
  Arg1 : Integer;
  Arg2 : Integer;
begin
  // Get the two input arguments
  PyArg_ParseTuple(Args, 'ii', @Arg1, @Arg2);
  // Pass them to the pascal implementation:
  Result := PyInt_FromLong(THelloPy.SumTwoIntegers(Arg1, Arg2));
end;


var
  Methods : packed array [0..1] of PyMethodDef;

procedure initHelloPy;
  cdecl;
begin
  Methods[0].name := 'SumTwoIntegers';
  Methods[0].meth := @SumTwoIntegers;
  Methods[0].flags := METH_VARARGS;
  Methods[0].doc := 'Tests argument passing to and from module function';

  Methods[1].name := nil;
  Methods[1].meth := nil;
  Methods[1].flags := 0;
  Methods[1].doc := nil;

  Py_InitModule('HelloPy', Methods[0]);
end;


exports
  initHelloPy;

end.
