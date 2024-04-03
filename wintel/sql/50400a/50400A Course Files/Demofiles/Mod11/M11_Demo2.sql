/* Create an endpoint on the principal server instance */

CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED 
    AS TCP (LISTENER_PORT=7022) 
    FOR DATABASE_MIRRORING (ROLE=PARTNER)
GO
--Partners under same domain user; login already exists in master.
--Create a login for the witness server instance,
USE master;
GO
CREATE LOGIN [NYC-SQL1\Ben Darton] FROM WINDOWS;
GO
-- Grant connect permissions on endpoint to login account of witness.
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [NYC-SQL1\Ben Darton];
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Create an endpoint on the partner server instance */

CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED 
    AS TCP (LISTENER_PORT=7022) 
    FOR DATABASE_MIRRORING (ROLE=ALL)
GO
--Partners under same domain user; login already exists in master.
--Create a login for the witness server instance,
--which is running as [NYC-SQL1\Ben Darton]:
USE master;
GO
CREATE LOGIN [NYC-SQL1\Ben Darton] FROM WINDOWS;
GO
--Grant connect permissions on endpoint to login account of witness.
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [NYC-SQL1\Ben Darton]
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Create an endpoint on the witness server instance */

CREATE ENDPOINT Endpoint_Mirroring
    STATE=STARTED 
    AS TCP (LISTENER_PORT=7022) 
    FOR DATABASE_MIRRORING (ROLE=WITNESS)
GO
--Create a login for the partner server instances,
--which are both running as [NYC-SQL1\Ben Darton]:
USE master;
GO
CREATE LOGIN [NYC-SQL1\Ben Darton] FROM WINDOWS;
GO
--Grant connect permissions on endpoint to login account of partners.
GRANT CONNECT ON ENDPOINT::Endpoint_Mirroring TO [NYC-SQL1\Ben Darton];
GO
