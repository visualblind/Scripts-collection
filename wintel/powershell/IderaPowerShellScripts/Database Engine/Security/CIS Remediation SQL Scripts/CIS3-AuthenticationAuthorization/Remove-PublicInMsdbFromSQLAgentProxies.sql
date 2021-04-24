-- Remove Public in MSDB from SQL Agent Proxies
-- CIS 3.11 Check (Authentication and Authorization)

USE [msdb]
GO
EXEC dbo.sp_revoke_login_from_proxy @name = N'public', @proxy_name = N'$(ProxyName)';
GO