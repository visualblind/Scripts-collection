/* To copy with indexes and triggers do these 2 queries: */
CREATE TABLE wrd_optin_meta_backup LIKE wrd_optin_meta;
START TRANSACTION;
INSERT wrd_optin_meta_backup SELECT * FROM wrd_optin_meta;
COMMIT; /* or rollback */
ROLLBACK;
/* To copy just structure and data use this one: */
CREATE wrd_optin_meta_backup AS SELECT * wrd_optin_meta;