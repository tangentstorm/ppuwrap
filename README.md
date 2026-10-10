# ppuwrap

Generate Python-callable shared libraries from Free Pascal units.

**State:** single-day spike (Jan 21, 2014) — the generator itself was never
implemented beyond a skeleton. The `ref/` directory holds a working manual
proof of concept of the approach.

## What it is

An experiment in bridging Free Pascal and Python: write a Pascal unit, and have
a tool (`ppuxml2lib`) automatically generate the boilerplate needed to compile
it into a `.so` shared library that Python can `import` directly — no
hand-written C wrapper.

## How it was supposed to work

1. Write a Pascal unit that exposes functionality through a class with a
   `published` section (RTTI on, `{$M+}`), e.g. `ref/uhellopy.pas`:
   ```pascal
   THelloPy = class
     published
       class function SumTwoIntegers(x, y : Int32) : Int32;
   end;
   ```
2. Compile it with Free Pascal, then dump the unit's interface metadata:
   `ppudump -FX uhellopy.xml` (ppudump ships with FPC 2.7.1+).
3. `ppuxml2lib` reads that XML, finds every published procedure via XPath
   (`/unit/interface//proc/name`), and generates:
   - a Pascal wrapper library (modeled on the hand-written `ref/HelloPy.pas`)
     that binds each function through `PyAPI.pas` (minimal Python C-API
     declarations), and
   - optionally a Python-side module (`-py` flag).
4. Compile the wrapper with `fpc -Xc`, rename `libHelloPy.so` → `HelloPy.so`,
   then `import HelloPy` from Python. `ref/hipy.sh` shows the manual pipeline;
   `ref/hellopas.py` shows the call from the Python side.

## Key files

| File | Role |
|---|---|
| `ppuxml2lib.pas` | The tool itself (Free Pascal). Parses CLI args, loads the ppudump XML, lists procedure names. **Code generation not implemented** — the `-py` flag is accepted and silently ignored. |
| `ref/uhellopy.pas` | Example input unit (the `THelloPy` class above). |
| `ref/HelloPy.pas` | Hand-written wrapper library — this is the *target output* the generator was meant to produce automatically. Uses `PyAPI`, exports `initHelloPy`. |
| `ref/PyAPI.pas` | Minimal Python C-API bindings (`Py_InitModule`, `PyArg_ParseTuple`, `PyInt_FromLong`), imported from the Free Pascal wiki article "Developing Python Modules with Pascal" (Phil "MacPgmr"). |
| `ref/uhellopy.xml` / `uhellopy.json` | Sample `ppudump` outputs (XML + JSON) for the example unit. |
| `ref/hellopas.py`, `ref/hipy.sh` | Python-2-era demo client and build script. |

## Current state

- **6 commits, all on 2014-01-21.** Nothing since.
- The README promises "generate shared libraries from pascal units, plus wrappers
  for python", but `ppuxml2lib` only *lists* procedure names — the actual
  generation step was never written. The `ref/` directory is the working manual
  proof that the *approach* is sound.
- Firmly Python-2 era: `PyAPI.pas` binds `python27.dll` / `libpython2.7.so`, and
  `hellopas.py` uses the `print` statement. The sample dump targets FreeBSD
  x86-64.
- MIT licensed.

## Notable findings

- The interesting artifact here isn't the tool (a skeleton) but the *recipe*:
  ppudump XML → XPath over published methods → emit a `PyAPI`-based wrapper.
  If this were ever revived, the generator would need a type-mapping table
  (Pascal types → `PyArg_ParseTuple` format codes / `PyInt_FromLong`-style
  constructors) — the hand-written `HelloPy.pas` shows exactly the shape of the
  output for the integer-only case.
- A modern revival would also need Python 3 bindings (`PyModuleDef` instead of
  `Py_InitModule`) — the C-API surface changed completely after 2.7.
