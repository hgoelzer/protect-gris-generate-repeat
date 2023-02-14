#!/usr/bin/env python
# Produce shuffled time series until 2500 based input until 2100
import xarray
import numpy
import netCDF4
import os
import sys
import glob
import random

def write_netcdf(ds, filename):
    fill_values = netCDF4.default_fillvals

    encoding_dict = {}
    variableNames = list(ds.data_vars.keys()) + list(ds.coords.keys())
    for variableName in variableNames:
        isNumeric = numpy.issubdtype(ds[variableName].dtype, numpy.number)
        if isNumeric and numpy.any(numpy.isnan(ds[variableName])):
            dtype = ds[variableName].dtype
            for fillType in fill_values:
                if dtype == numpy.dtype(fillType):
                    encoding_dict[variableName] = \
                        {'_FillValue': fill_values[fillType]}
                    break
        else:
            encoding_dict[variableName] = {'_FillValue': None}

    if 'time' in ds.dims:
        ds.encoding['unlimited_dims'] = {'time'}

    ds.to_netcdf(filename, encoding=encoding_dict)


def main():
    time_index_filename = 'time_indices_2301-2500_ext10.nc'

    numpy.random.seed(seed=1)
    
    shuffle_indices = []
    # Select what to draw from here last 10 years of projection
    indices=list(range(2091,2101,1))
    print(indices)

    # repeat shuffel up to 2500 10*20
    for i in range(0,20):
        numpy.random.shuffle(indices)
        print(indices)
        shuffle_indices = numpy.append(shuffle_indices, indices)

    print(shuffle_indices)

    ds = xarray.Dataset()
    # time axis relative to 1900-01-01
    ds['time'] = (('time',), 365.*numpy.arange(2301-1900, 2501-1900))
    ds.time.attrs['standard_name'] = 'time'
    ds.time.attrs['long_name'] = 'time'
    ds.time.attrs['units'] = 'days since 1900-01-01 00:00:00'
    ds.time.attrs['calendar'] = '365_day'
    ds.time.attrs['axis'] = 'T'
    ds['year'] = (('time',), 1.0*numpy.arange(2301, 2501))
    ds.year.attrs['standard_name'] = 'year'
    ds.year.attrs['long_name'] = 'Year'
    ds['shuffled_time_indices'] = (('time',), shuffle_indices)
    write_netcdf(ds, time_index_filename)

if __name__ == '__main__':
    main()
