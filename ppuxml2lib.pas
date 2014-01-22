{ ppuxml2lib : generated shared libraries from free pascal units
  --------------------------------------------------------------
  Copyright (c) 2014 michal j wallace <http://tangentstorm.com/>
  Available under the MIT license. See LICENSE file for details.
  -------------------------------------------------------------- }
{$mode objfpc}{$m+}{$h+}
program ppuxml2lib;
uses xpath, xmlread, DOM;

procedure help;
  begin
    writeln('usage:');
    writeln('ppuxml2lib [-py] [-h] dumpfile.xml');
    writeln('  -py  : generate python module');
    writeln('  -h   : show this help file');
    writeln('generate dumpfile with the ppudump program');
    writeln('that ships with free pascal 2.7.1 or newer');
    writeln('  ppudump -FX myunit.xml');
    halt;
  end;

const
  xpProcs = '/unit/interface//proc/name';

procedure main(dumpfile	: string; genpy: boolean);
  var doc : DOM.TXMLDocument; item : pointer;
  begin
    xmlread.ReadXMLFile( doc, dumpfile );
    for item in EvaluateXPathExpression( xpProcs, doc ).AsNodeSet do
      begin
	writeln( TDOMNode( item ).textContent );
      end;
  end;

var
  i : integer; genpy : boolean = false; dumpfile : string='';
begin
  if paramcount > 0 then for i := 1 to paramcount do
    case paramstr(i) of
      '-h'  : help;
      '-py' : genpy := true;
      else dumpfile := paramstr(i)
    end; { case }
  if dumpfile = '' then help else main(dumpfile, genpy)
end.
