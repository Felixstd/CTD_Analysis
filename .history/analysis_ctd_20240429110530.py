import scipy.io as io
import matplotlib.pyplot as plt
from pyrsktools import RSK


data_ctd = io.loadmat('12_09_2023_transect4.mat')


# with open('018838_20240425_1127.hex', 'rb') as f:
#     hexdata = f.read().hex()
    
print(data_ctd )
# print(data_ctd["Temperature"])