select * from sjob where state='running'
update sjob set state='error' where job='JobGUID'