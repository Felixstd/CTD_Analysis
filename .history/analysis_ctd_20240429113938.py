import gsw
import numpy as np
import scipy.io as io
import matplotlib.pyplot as plt

"""
idx 15: Sampling times

"""

def read_data_ctd(filename):
    
    data_ctd = io.loadmat('12_09_2023_transect4.mat')
    
    data = data_ctd['RBR'][0][0][16]
    
    Salinity = data[:, 4]
    Pressure = data[:, 2]
    Depth =  data[:, 3]
    Temperature =  data[:,1]

    
    return Salinity, Pressure, Depth, Temperature



pression_atm = 992
Latitude = 70
Longitude= -130

Salinity, Pressure, Depth, Temperature = read_data_ctd('')

AS = gsw.SA_from_SP(salinity, pressure, Longitude, Latitude)
CT = gsw.CT_from_t(AS, Temperature,pressure)
Sig0 = gsw.sigma0(AS, CT)


plt.figure()
plt.plot(Temperature, Depth, color = 'r')
plt.grid()
plt.xlabel('Temperature (°C)')
plt.ylabel('Depth (m)')
plt.gca().invert_yaxis()
plt.savefig('temperature.png', dpi = 500, bbox_inches = 'tight')

