rm -f HelloPy.so uhellopy.ppu
fpc -gl -B -Xc HelloPy.pas \
&& mv libHelloPy.so HelloPy.so \
&& python hellopas.py
