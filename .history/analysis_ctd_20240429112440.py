import scipy.io as io
import matplotlib.pyplot as plt
import gsw


from pyrsktools import RSK

"""
idx 15: Sampling times



"""


pression_atm = 992
Latitude = 70
Longitude= -130

data_ctd = io.loadmat('12_09_2023_transect4.mat')
data = data_ctd['RBR'][0][0][16]

salinity = data[:, 4]
pressure = data[:, 2]
Depth =  data[:, 3]
Temperature =  data[:,1]


AS, in_ocean = gsw.gsw_SA_from_SP(salinity, pressure, Longitude, Latitude)
CT = gsw.gsw_CT_from_t(AS, Temperature,pressure)
Sig0 = gsw.gsw_sigma0(AS, CT)