import argparse
from os import path, close
from subprocess import call, Popen, PIPE
import sys
import os
import getopt
import shutil

sys.path.append(os.environ["VMWARE_PYTHON_PATH"])
from cis.defaults import get_cis_install_dir, get_cis_log_dir

CIS_HOME       = get_cis_install_dir()
CIS_LOG        = get_cis_log_dir()
PG_DUMP        = path.join(CIS_HOME, "vPostgres", "bin", "pg_dump.exe")
PG_PASS_FOLDER = path.join(os.environ['APPDATA'], "postgresql")
PG_PASS_FILE   = path.join(PG_PASS_FOLDER, "pgpass.conf")

def main():
   parser = argparse.ArgumentParser()
   parser.add_argument('-p',
                       action="store",
                       dest="password",
                       required=True)
   parser.add_argument('-f',
                       action="store",
                       dest="backup_file",
                       required=True)
   results = parser.parse_args()

   passExists = False
   folderExists = False
   linesCount = 0
   if path.isfile(PG_PASS_FILE):
      passExists = True
      linesCount = sum(1 for l in open(PG_PASS_FILE))

   if not passExists:
      if not os.path.exists(PG_PASS_FOLDER):
         os.makedirs(PG_PASS_FOLDER)
      else:
         folderExists = True

   with open(PG_PASS_FILE, 'a') as f:
      line = "\nlocalhost:5432:VCDB:vc:%s" % (results.password)
      f.write(line)

   fileOut = open(path.join(CIS_LOG, "backup_out.log"), "a+")
   fileError = open(path.join(CIS_LOG, "backup_err.log"), "a+")

   cmd = [PG_DUMP, "-a", "-Fc", "--disable-triggers", "-b", "-U", "vc", "-f", results.backup_file, "VCDB"]
   ret = call(cmd, stdout=fileOut, stderr=fileError)
   fileOut.close()
   fileError.close()

   if passExists:
      n = sum(1 for line in open(PG_PASS_FILE))
      if linesCount == n:
         return
      toDelete = n - linesCount
      with open(PG_PASS_FILE) as f:
         lines = f.readlines()
      with open(PG_PASS_FILE,"w") as f:
         f.writelines([item for item in lines[:-toDelete]])
   else:
      if folderExists:
         os.remove(PG_PASS_FILE)
      else:
         shutil.rmtree(PG_PASS_FOLDER)

   print ("Backup completed successfully.")

if __name__ == '__main__':
   main()