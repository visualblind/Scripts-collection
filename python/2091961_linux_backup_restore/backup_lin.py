#!/usr/bin/env python

import argparse
from os import path, remove, close
from subprocess import call, Popen, PIPE

POSTG_BIN_DIR  = "/opt/vmware/vpostgres/current/bin/"
PSQL           = path.join(POSTG_BIN_DIR, "psql")
PG_DUMP        = path.join(POSTG_BIN_DIR, "pg_dump")

parser = argparse.ArgumentParser()
parser.add_argument('-f',
                    action="store",
                    dest="backup_file",
                    required=True)
results = parser.parse_args()

fileOut = open("/tmp/backup_out.log", "a+")
fileError = open("/tmp/backup_err.log", "a+")

cmd = [PG_DUMP, "-a", "-Fc", "--disable-triggers", "-b", "-U", "postgres", "-f", results.backup_file, "VCDB"]
ret = call(cmd, stdout=fileOut, stderr=fileError)
fileOut.close()
fileError.close()

print ("Backup completed successfully.")