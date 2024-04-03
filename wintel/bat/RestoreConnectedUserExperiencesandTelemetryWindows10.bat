@echo off
sc config DiagTrack start= auto
sc start DiagTrack
exit