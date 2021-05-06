# -*- coding: utf-8 -*-
"""
Created on Thu Sep 26 13:23:50 2019
1. This program measures fusing current of a given sample 
   by stepping the current from 0.1A to 5A with a step of 0.1A
2. Time and voltage of the sample are recorded
Insturments:
    Keysight N6700C 5A Power Supply
    Keysight 34461A 10A DMM

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

#%% Close all plotting windows   
plt.close('all')

#%% Saving File Name Initialization, Change before Run!
sampleName = ' FusionTest - Microconstriction - 4W - T1' 
fname=time.strftime("%y%m%d%H%M%S",time.localtime()) + sampleName

SetCurrent = 0.1
cycleDone = 0   
t_step = 10
#%% initialize variable 
V = [] 
t = []
T = []
a = []

#%% Call PyVisa's Resource Manager
rm = visa.ResourceManager() 

#%% Open GPIB Addresses, Change before Run!
#ammeter = rm.open_resource('USB0::0x2A8D::0x1301::MY59005979::0::INSTR')

#A34411 = rm.open_resource('USB0::0x2A8D::0x1301::MY59005979::0::INSTR')  # measure voltage
DCsource = rm.open_resource('USB0::0x2A8D::0x0002::MY56008842::0::INSTR') # DC Power Supply
multiplexer = rm.open_resource('GPIB0::25::INSTR') # Multiplexer for Voltage measurement 


#A34411.write('SYSTem:REMote')
#A34411.write('*RST') #factory reset
#A34411.write('*CLS') #clear memory
#A34411.write('CONFigure:VOLTage:DC') #Setup to measure V

multiplexer.write('*RST')
multiplexer.write('*CLS')  
multiplexer.write('CONFigure:VOLTage') 

DCsource.write('*RST')
DCsource.write('*CLS')
DCsource.write('VOLT 8,(@1)')       
DCsource.write('CURR %s,(@1)' % (str(SetCurrent)))
DCsource.write('OUTPUT ON,(@1)')    

#%% Start the Timer
tic = time.perf_counter()
multiplexer.write(':ROUTe:OPEN:all') # Open all channels
multiplexer.write(':ROUTe:CLOSe (%s)' % ('@102')) #close a channel for reading
rawstr = multiplexer.query('read?')
index=rawstr.find('VDC')
volStr = rawstr[0:index]                
Vvalue = float(volStr)


while cycleDone == 0:

    for i in range (1, 31):   #Stepping from 0-3A
        
        StepStart = time.perf_counter()
        
        while time.perf_counter() - StepStart <t_step:
            DCsource.write('CURR %s,(@1)' % (str(i * SetCurrent)))
            multiplexer.write(':ROUTe:OPEN:all') # Open all channels
            multiplexer.write(':ROUTe:CLOSe (%s)' % ('@102')) #close a channel for reading
            rawstr = multiplexer.query('read?') 
            index=rawstr.find('VDC')
            volStr = rawstr[0:index]                
            Vvalue = float(volStr)
            toc=time.perf_counter()
            V.append(Vvalue)
            t.append(toc-tic) 
            
        # End of While loop   
        
    #End of For loop
    
    for i in range (1, 41):   #Stepping from 3A - 5A
        
        StepStart = time.perf_counter()
        
        while time.perf_counter() - StepStart <t_step:
            DCsource.write('CURR %s,(@1)' % (str(3 + i*0.05 )))
            multiplexer.write(':ROUTe:OPEN:all') # Open all channels
            multiplexer.write(':ROUTe:CLOSe (%s)' % ('@102')) #close a channel for reading
            rawstr = multiplexer.query('read?') 
            index=rawstr.find('VDC')
            volStr = rawstr[0:index]                
            Vvalue = float(volStr)
            toc=time.perf_counter()
            V.append(Vvalue)
            t.append(toc-tic) 
            
        # End of While loop
        
    #End of For loop
    
    
    DCsource.write('CURR 0.1,(@1)')
    DCsource.write('OUTPUT OFF,(@1)')
    
    data = {}
    data['t'] = t
    data['V'] = V
    cycleDone = 1

    scipy.io.savemat('%s.mat' % fname, data)
#End of While Loop    
#%% close instruments 
multiplexer.close()
DCsource.close()