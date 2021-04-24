-- Set CLR Assembly Permission to SAFE_ACCESS
-- CIS 6.2 Check (Application Development)

ALTER ASSEMBLY "$(AssemblyName)" WITH PERMISSION_SET = SAFE;
