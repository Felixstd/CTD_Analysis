import gsw
import numpy as np
import scipy.io as io
import matplotlib.pyplot as plt
import pandas as pd
import scienceplots

# Matplotlib global settings
plt.rcParams.update({'font.size': 16})
plt.style.use(['science', 'no-latex'])

# --------------------------------------------------------------------
#                       HELPER FUNCTIONS
# --------------------------------------------------------------------

def read_data_ctd(filename):
    """
    Reads CTD data from a .mat file.

    Parameters:
        filename (str): The file name of the .mat file containing CTD data.

    Returns:
        tuple: Salinity, Pressure, Depth, Temperature, and time arrays.
    """
    data_ctd = io.loadmat(filename)['RBR'][0][0]
    data = data_ctd[16]  # Data array
    time = data_ctd[15]  # Time array

    return data[:, 4], data[:, 2], data[:, 3], data[:, 1], time


def filter_data(Salinity, Temperature, Depth, Time, split=False, first_half=True, up_down='up'):
    """
    Filters and processes CTD data based on specific criteria.

    Parameters:
        Salinity, Temperature, Depth, Time (arrays): Input CTD data.
        first_half (bool): If True, processes the second half of the time series.
        up_down (str): 'up' to process ascending data, 'down' for descending.

    Returns:
        tuple: Filtered Salinity, Temperature, Depth, and Time arrays.
    """
    
    # Mostly if you took more than one sampling, it cut the data so you look at only one sounding
    if split == True:
        n = len(Salinity) // 2
        if first_half:
            Salinity, Temperature, Depth, Time = Salinity[n:], Temperature[n:], Depth[n:], Time[n:]
        else:
            Salinity, Temperature, Depth, Time = Salinity[:n], Temperature[:n], Depth[:n], Time[:n]

    # Mask invalid depths
    mask = Depth > 0
    Salinity, Temperature, Depth, Time = Salinity[mask], Temperature[mask], Depth[mask], Time[mask]

    # Split data into up and down casts
    depth_max_idx = np.argmax(Depth)
    if up_down == 'down':
        return Salinity[:depth_max_idx], Temperature[:depth_max_idx], Depth[:depth_max_idx], Time[:depth_max_idx]
    return Salinity[depth_max_idx:], Temperature[depth_max_idx:], Depth[depth_max_idx:], Time[depth_max_idx:]


def plot_profile(Temperature, Salinity, Depth, output_file):
    """
    Plots a single temperature and salinity profile.

    Parameters:
        Temperature, Salinity, Depth (arrays): Profile data.
        output_file (str): Path to save the plot.
    """
    fig, ax1 = plt.subplots(figsize=(6, 7))
    ax2 = ax1.twiny()

    ax1.plot(Temperature, Depth, color='b', linewidth=3)
    ax2.plot(Salinity, Depth, color='r', linewidth=3)

    ax1.set_xlabel('Temperature (°C)', color='b')
    ax2.set_xlabel('Salinity (PSU)', color='r')
    ax1.set_ylabel('Depth (m)')
    ax1.tick_params(axis='x', colors='b')
    ax2.tick_params(axis='x', colors='r')

    ax1.grid()
    ax1.invert_yaxis()
    ax1.invert_xaxis()
    plt.savefig(output_file, dpi=500, bbox_inches='tight')
    plt.close()


def plot_multiple_profiles(data_list, labels, xlabel, output_file):
    """
    Plots multiple profiles (temperature or salinity) on a single figure.

    Parameters:
        data_list (list): List of profile data arrays.
        labels (list): Labels for each profile.
        xlabel (str): Label for the x-axis.
        output_file (str): Path to save the plot.
    """
    fig, ax = plt.subplots(figsize=(6, 7))

    for data, label in zip(data_list, labels):
        ax.plot(data[0], data[1], linewidth=3, label=label)

    ax.set_xlabel(xlabel)
    ax.set_ylabel('Depth (m)')
    ax.legend()
    ax.grid()
    plt.gca().invert_yaxis()
    plt.savefig(output_file, dpi=500, bbox_inches='tight')
    plt.close()


def export_to_excel(data_dict, output_file):
    """
    Exports filtered data to an Excel file.

    Parameters:
        data_dict (dict): Dictionary containing CTD data arrays with labels.
        output_file (str): Path to save the Excel file.
    """
    all_data = []

    for label, (Salinity, Temperature, Depth, Time) in data_dict.items():
        mask = (Depth > 0) & (Depth < 7)
        df = pd.DataFrame({
            'Salinity': Salinity[mask],
            'Temperature': Temperature[mask],
            'Depth': Depth[mask],
            'Time': Time[mask],
            'Dataset': label
        })
        all_data.append(df)

    final_df = pd.concat(all_data, ignore_index=True)
    final_df.to_excel(output_file, index=False)

# --------------------------------------------------------------------
#                       MAIN SCRIPT
# --------------------------------------------------------------------

# File paths
filenames = [
    '018838_20241108_1449.mat',
    '018838_20241109_0938.mat',
    '018838_20241110_1005.mat',
    '018838_20241110_1632.mat'
]

# File names (labels)
names = [
    'Sea Ice',
    'Basic',
    'Volcano',
    'Bergy Bits'
]

datasets = {}
for i, filename in enumerate(filenames):
    Salinity, Pressure, Depth, Temperature, Time = read_data_ctd(filename)
    # If you don't know where your sampling was in the timeseries (approximately) and you only took one sampling
    #     ---> split=False
    datasets[names[i]] = filter_data(Salinity, Temperature, Depth, Time, split=True, first_half=True, up_down='up')


# Plot individual and multiple profiles
plot_profile(datasets[names[0]][1], datasets[names[0]][0], datasets[names[0]][2], 'profiles.png')

plot_multiple_profiles([(d[1], d[2]) for d in datasets.values()], names, 'Temperature (°C)', 'temperatures.png')
plot_multiple_profiles([(d[0], d[2]) for d in datasets.values()], names, 'Salinity (PSU)', 'salinities.png')

# Export data to Excel
#export_to_excel(datasets, 'salinity_temperature_data.xlsx')