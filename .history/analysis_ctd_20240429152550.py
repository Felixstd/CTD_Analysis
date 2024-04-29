import gsw
import numpy as np
import scipy.io as io
import matplotlib.pyplot as plt

def read_data_ctd(filename):
    """
    This function is used to read the data taken from the CTD. It reads the 
    temperature, depth, pressure and salinity data. 
    
    To take the right array in the .mat file, we need to take the 0, 0, 16 indexes 
    such that it takes the array containg the data. 
    
    Units for the variables:
        Temperature -> °C
        Pressure    -> dBar
        Depth       -> m
        Salinity    -> PSU

    Inputs:
        filename (str): The file name of the .mat files containing the data
    
    Returns:
        Salinity     (array, time): contains the salinity data
        Pressure     (array, time): contains the pressure data
        Depth        (array, time): contains the depth data
        Temperature  (array, time): contains the temperature data
        
        
    """
    #reading the file
    data_ctd = io.loadmat(filename)
    
    #taking the data array
    data = data_ctd['RBR'][0][0][16]
    
    #taking the data
    Temperature = data[:, 1]
    Pressure    = data[:, 2]
    Depth       = data[:, 3]
    Salinity    = data[:, 4]

    return Salinity, Pressure, Depth, Temperature

#
pression_atm = 992
Latitude = 70
Longitude= -130

Salinity, Pressure, Depth, Temperature = read_data_ctd('12_09_2023_transect4.mat')

AS = gsw.SA_from_SP(Salinity, Pressure, Longitude, Latitude)
CT = gsw.CT_from_t(AS, Temperature, Pressure)
Sig0 = gsw.sigma0(AS, CT)

#------- Figures -------#

fig = plt.figure()
ax1 = plt.axes()
ax2 = ax1.twiny()

ax1.plot(Depth, Temperature)
ax2.plot(Depth, Salinity, label)




plt.figure()
plt.plot(Temperature, Depth, color = 'r')
plt.grid()
plt.xlabel('Temperature (°C)')
plt.ylabel('Depth (m)')
plt.gca().invert_yaxis()
plt.title('Temperature Profile')
plt.savefig('temperature.png', dpi = 500, bbox_inches = 'tight')

plt.figure()
plt.plot(Salinity, Depth, color = 'r')
plt.grid()
plt.xlabel('Salinity (PSU)')
plt.ylabel('Depth (m)')
plt.xlim(25, 35)
plt.gca().invert_yaxis()
plt.title('Salinity Profile')
plt.savefig('salinity.png', dpi = 500, bbox_inches = 'tight')

