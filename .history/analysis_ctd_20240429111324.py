import scipy.io as io
import matplotlib.pyplot as plt
from pyrsktools import RSK

"""
idx 15: Sampling times







"""
data_ctd = io.loadmat('12_09_2023_transect4.mat')
data = data_ctd['RBR'][0][0][16]

salinity = data[:, 4]
pressure = data[:, 2]

print(salinity)





# with open('018838_20240425_1127.hex', 'rb') as f:
#     hexdata = f.read().hex()
    
print(data_ctd['RBR'][0][0][16] )
# print(data_ctd["Temperature"])