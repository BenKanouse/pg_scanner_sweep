# PostgreSQL-Notes

## Vacuum notes

### vacuum verbose table_name;
This command will print stats about the table. Specifically it will point out if the table has 'bloat' meaning that the data in the table might not be releaseing objects that it no longer needs for some reason.
### vacuum full table_name;
Reclaim more space, but takes much longer and exclusively locks the table.

## Locks
https://wiki.postgresql.org/wiki/Lock_Monitoring
Sometimes I find these quries in the wiki to be a little heavy handed.


## Long running transactions
```
select * from pg_stat_activity where xact_start < now() - interval '1 hour';
```

  Any query with a pg_stat_activity.state == 'idle in transaction' is bad news if they have been in that state for a long time.
  
## Replication
```
select * from pg_replication_slots;

select txid_current(), txid_current_snapshot();

select * from pg_stat_replication;
```
  pg_stat_replication.backend_xmin  -- This attribute can show if one of the replicas is beind the others.
