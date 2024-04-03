@echo off
sc stop DialogBlockingService
sc config DialogBlockingService start= disabled
exit