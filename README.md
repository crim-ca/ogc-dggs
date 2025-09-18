# OGC11 DGGS - Discrete Global Grid System

General scripts and documentation of data preparation for DGGS representation.

## References

**Summary of most relevant resources/libraries**: https://github.com/opengeoshub/vgrid#references

---

**Extra References**

- `dggrid` - Core library to many other DGGS handlers/manipulators
  - https://github.com/sahrk/DGGRID
  - https://dggrid.readthedocs.io/latest/index.html
- `dggrid4py` - Python wrapper of `dggrid` with high-level functions used by `pydggsapi` and data manipulation tools
  - https://github.com/allixender/dggrid4py
- `xdggs-dggrid4py`, `rhealpixdggs-py`, `xdggs` - Wrapper/Plugins for Python `xarray` and `dask`
  - https://github.com/LandscapeGeoinformatics/xdggs-dggrid4py
  - https://github.com/manaakiwhenua/rhealpixdggs-py
  - https://github.com/xarray-contrib/xdggs
  - https://xdggs.readthedocs.io/
- `vgrid` - Main generator/converter of most DGGRS types and CLI tools for raster/vector data to DGGS slicing
  - https://github.com/opengeoshub/vgrid
  - https://vgrid.gishub.vn/
- `vgridpandas` - GeoPandas integration including `s2pandas`, `h3pandas`, etc. for filtering DGGS data
  - https://vgridpandas.gishub.vn/ 
- `raster2dggs` - Partial alternative to `vgrid` but limited to raster and only DGGRS: H3, rHEALPix, S2
  - https://github.com/manaakiwhenua/raster2dggs

## Important Notes

- `ISEA`: Icosahedral Snyder Equal Area
- `IGEO7`: this DGGRS is sometimes mentioned in libraries, but not mentioned across all implementations explicitly.
  However, `IGEO7` is simply an alias to `ISEA7H + 7Z`, ie: Hexagonal equal-area ISEA orientation with aperture 7
  specifically using the Z7 indexing system (hierarchical integer indexes using an  aperture 7
  Central Place Indexing Sahr) [https://agile-giss.copernicus.org/articles/6/32/2025/agile-giss-6-32-2025.pdf].
  Each hexagon "zoom-level" consists of 7 sub-hexagons of equal area.

## Installation

The [DGGRID](https://github.com/sahrk/DGGRID) software must be compiled to run the examples.
When compiling it, it must be configured with GDAL support.

To make this process simple, it can be performed using `conda` or `mamba`, as shown below.
This ensures that binaries and libraries are correctly linked and aligned with the same C++ ABI.
However, you can also invoke the gcc/g++ compilers directly if you prefer with the relevant dependencies installed.

```shell
mamba env create --file environment.yml
mamba activate ogc-dggs
```

```shell
git clone https://github.com/sahrk/DGGRID
mkdir -p DGGRID/build && cd DGGRID/build
cmake -DCMAKE_BUILD_TYPE=Release -DWITH_GDAL=ON ..
make -j $(nproc)
cp src/apps/dggrid/dggrid ${CONDA_PREFIX}/bin  # will be available from activated environment
```

## Execution

Ensure the `dggrid` executable can be found in the environment.
The following command should indicate whether the tool is found or not.
If not, you can enforce the path to the binary directly with `DGGRID_EXE` in your environment or `Makefile.config`.

```shell
make dggrid-info
```

Run the examples.
By default, this will combine any result that is missing outputs or when the corresponding `.meta` file changed.

```shell
make dggrid-run
```

To force execution, use:

```shell
make dggrid-run-force
```

## Examples

### Manitoba-Winnipeg Study Area

ISEA43H DGGS at levels 9 and 16 overlapping the input polygon as sample area of interest.

![Manitoba Study Area](./manitoba_study_area/images/result_dggs.png)
