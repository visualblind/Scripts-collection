-- Disable Trustworthy Database Property
-- CIS 2.9 Check (Surface Area Reduction)

ALTER DATABASE "$(DBName)" SET TRUSTWORTHY OFF;