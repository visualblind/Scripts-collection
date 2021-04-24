Robocopy.exe "F:\Dept" "\\server1\h$\Dept" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-dept.log /tee
Robocopy.exe "F:\Applications" "\\server1\h$\Applications" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-applications.log /tee
Robocopy.exe "I:\Apps" "\\server1\h$\Apps" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-apps.log /tee
Robocopy.exe "H:\Clients" "\\server1\h$\Clients" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-clients.log /tee
Robocopy.exe "F:\Projects" "\\server1\h$\Projects" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-Projects.log /tee
Robocopy.exe "F:\Dev" "\\server1\h$\Dev" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-Dev.log /tee
Robocopy.exe "G:\Archives" "\\server1\h$\Archives" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-Archives.log /tee
Robocopy.exe "E:\Home" "\\server1\h$\Home" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-Home.log /tee
Robocopy.exe "G:\Archives" "\\server1\h$\Archives" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-Archives.log /tee
Robocopy.exe "F:\Projects" "\\server1\h$\Projects" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-SpectrumProject.log /tee
Robocopy.exe "D:\Profiles" "\\server1\h$\Profiles" /b /e /copyall /r:6 /xd dfsrprivate /log:robo-Profiles.log /tee

