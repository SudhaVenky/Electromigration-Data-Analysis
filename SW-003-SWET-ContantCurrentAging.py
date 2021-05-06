# -*- coding: utf-8 -*-
"""
Created on Thu Sep 26 13:23:50 2019
1. This program measures the voltage using a 10A DMM
    at constant current 
2. time is also recorded
Insturments:
    Circuit Specialist PS
    Hammatek PS
    KeySight NC6700
    2700 Multimeter
    10A DMM

@author: sazisurv
"""

#%% Reset All
from IPython import get_ipython
get_ipython().magic('reset -sf')


#%% Import packages required for this code
import visa
import time
import matplotlib.pyplot as plt
import subprocess
import scipy.io
from math import sqrt

#%% Close all plotting windows   
plt.close('all')

#%% Saving File Name Initialization, Change before Run!
sampleName = ' Microconstriction - 4W - SnCu - Fusion Example' 
fname=time.strftime("%y%m%d%H%M%S",time.localtime()) + sampleName
 
PRchange=0     
#%% Define Functions
def roots(a,b,c):
    # Don't Make Changes
    """
    This function uses quadratic formula to get the real root (positive and less than 300) 
    of an expression ax^2+bx+c=0 by entering (a,b,c). 
    Note that this function will return an error if trying to obtain an imaginary root 
    """
    disc = b**2 - 4*a*c #discriminant
    if disc >= 0:
        if ((-b + sqrt(disc))/(2*a))<300 and ((-b + sqrt(disc))/(2*a))>00:
            return (-b + sqrt(disc))/(2*a)
        elif ((-b - sqrt(disc))/(2*a))<300 and ((-b - sqrt(disc))/(2*a))>0:
            return (-b - sqrt(disc))/(2*a)
    else:
        return -10000000
#%% initialize variable 
n = 1
V = [[] for z in range(n)]
#V_check = [[] for z in range(n)]
I = [[] for z in range(n)]
I1 = []
I2 = []
t = []
T = []
A = 3.9083E-3               #Constants for tp1000 temperature sensor      
B = -5.775E-7               #Constants for tp1000 temperature sensor  
RealTimeReadings = 100      #Real time plotting that only show a window of this number of values 

#%% List of Channel number and corresponding color while plotting
channel=['@103']
#channel=['@101','@102','@103']
color=['b'] 
#color=['b','g','r'] 

#%% Call PyVisa's Resource Manager
rm = visa.ResourceManager() 

#%% Open GPIB Addresses, Change before Run!

Ammeter = rm.open_resource('USB0::0x2A8D::0x1301::MY59005695::0::INSTR')  #measure current across Circuit Specialist
N6700C = rm.open_resource('USB0::0x2A8D::0x0002::MY56008842::0::INSTR') # DC Power Supply
multiplexer = rm.open_resource('GPIB0::25::INSTR') # Multiplexer for Voltage measurement  
tempsensor = rm.open_resource('USB0::0x2A8D::0x1301::MY59005979::0::INSTR')  # measure voltage

Ammeter.write("SYSTem:REMote")
Ammeter.write("*RST")  # factory reset
Ammeter.write("*CLS")  # clear memory
Ammeter.write("CONFigure:CURRent:DC 10")  # sets the ammeter to measure at the 10A range

N6700C.write('*RST')
N6700C.write('*CLS')
N6700C.write('VOLT 8,(@1)')       
N6700C.write('CURR 0.1,(@1)')
N6700C.write('OUTPUT ON,(@1)')    

multiplexer.write('*RST')
multiplexer.write('*CLS')  
multiplexer.write('CONFigure:VOLTage') 

tempsensor.write("SYSTem:REMote")
tempsensor.write("*RST")  # factory reset
tempsensor.write("*CLS")  # clear memory
tempsensor.write("CONFigure:SCALar:FRESistance")  # 4-wire config. to measure temperature

#%% Start the Timer
tic = time.perf_counter()
testDone = 0

while testDone == 0:

    #Find the temperature value from the resistance reading from tp1000 according to the formula
    TRstr = tempsensor.query("READ?")  # The format of reading from temp. sensor is '### OHM'
    index = TRstr.find("OHM")  # Find the index of 'OHM' to only obtain the numbers before it
    TRvalue = float(TRstr[0:index])
    Tvalue = roots(B * 1000, A * 1000, 1000 - TRvalue)
    
#    Avalue1 = float(Ammeter.query("READ?"))
#    Avalue2 = float(N6700C.query('MEAS:CURR? (@1)'))
#    
    for i in range(n):
        
        Vvalue = -10000
#        while Vvalue == -10000:
#            try:
#                multiplexer.write(':ROUTe:OPEN (%s)' % ('@101:103')) # Open 3 channels
#                multiplexer.write(':ROUTe:CLOSe (%s)' % (channel[i])) #close channel for reading
#                rawstr = multiplexer.query('read?')
#                index = rawstr.find('VDC')
#                volstr = rawstr[0:index]
#            except:
#                    Vvalue = -10000;
        
        multiplexer.write(':ROUTe:OPEN:all') # Open all channels
        multiplexer.write(':ROUTe:CLOSe (%s)' % (channel[i])) #close a channel for reading
        rawstr = multiplexer.query('read?')
        index=rawstr.find('VDC')
        volStr = rawstr[0:index]                
        Vvalue = float(volStr)
        
        # Append voltage value of each channel to list
        V[i].append(Vvalue)
        
        #Append current value of each channel to list
        #Avalue3 = 1.96

    

        #I.append(Avalue2)               
             
    # End of For loop
 
    #saving found values
    #I[0].append(Avalue1)
#    I2.append(Avalue2)
#    I1.append(Avalue1)
    toc=time.perf_counter()
    T.append(Tvalue)
    t.append(toc-tic) 

 #%% Plot Tvst, Rvst in real-time
    
#    plt.ion()
#    f = plt.figure(1)
##            plt.cla() #clear the plots for real time readings
#    #Real time plotting
#    plt.plot(t[max(0, len(t)-RealTimeReadings):],T[max(0, len(t)-RealTimeReadings):],'b') 
#    plt.xlabel('Time [s]', fontsize=30)
#    plt.ylabel('Temperature [℃]', fontsize=30)
#    plt.rcParams['xtick.labelsize']=32
#    plt.rcParams['ytick.labelsize']=32
#    plt.show()
#    #Flush the data for the real time plotting window
#    f.canvas.draw()
#    f.canvas.flush_events() 

    data = {}
#    data['T'] = T
    data['t'] = t
    data['V'] = V
    data['T'] = T
#    data['V_check'] = V_check 
#    data['I1'] = I1
#    data['I2'] = I2

    scipy.io.savemat('%s.mat' % fname, data)
#End of While loop
  
#%% close instruments 
#A34411.close()
#tempsensor.close()
N6700C.write('OUTPUT OFF,(@1)')
N6700C.close()

