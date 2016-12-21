import subprocess 
import shlex 
from time import sleep
import datetime

def run_command(cmd, logfilename=None):
    if logfilename:
        with open(logfilename, "w") as logfile:
            p = subprocess.Popen(shlex.split(cmd), stdout=logfile)
    else:        
        subprocess.Popen(shlex.split(cmd))
        
def disp(message):
    print(str(datetime.datetime.now()) + ' ' +message)
    