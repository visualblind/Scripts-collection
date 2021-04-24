-- Disable AUTO_CLOSE on contained databases
-- CIS 2.16 Check (Surface Area Reduction)

ALTER DATABASE "$(DBName)" SET AUTO_CLOSE OFF;