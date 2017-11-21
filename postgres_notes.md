# PostgreSQL-Notes

## Vacuum notes

### vacuum verbose table_name;
This command will print stats about the table. Specifically it will point out if the table has 'bloat' meaning that the data in the table might not be releaseing objects that it no longer needs for some reason.
### vacuum full table_name;
Reclaim more space, but takes much longer and exclusively locks the table.

## Locks
https://wiki.postgresql.org/wiki/Lock_Monitoring
Sometimes I find these quries in the wiki to be a little heavy handed.
```sql
  SELECT blocked_locks.pid     AS blocked_pid,
         blocked_activity.usename  AS blocked_user,
         blocking_locks.pid     AS blocking_pid,
         blocking_activity.usename AS blocking_user,
         blocked_activity.query    AS blocked_statement,
         blocked_activity.xact_start AS blocked_xact_start,
         age(now(), blocked_activity.xact_start) AS blocked_xact_start_age,
         blocking_activity.query   AS current_statement_in_blocking_process,
         blocking_activity.xact_start   AS current_statement_xact_start,
         age(now(), blocking_activity.xact_start) AS current_statement_xact_start_age
   FROM  pg_catalog.pg_locks         blocked_locks
    JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
    JOIN pg_catalog.pg_locks         blocking_locks 
        ON blocking_locks.locktype = blocked_locks.locktype
        AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
        AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
        AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
        AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
        AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
        AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
        AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
        AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
        AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
        AND blocking_locks.pid != blocked_locks.pid
 
    JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
   WHERE NOT blocked_locks.GRANTED AND
   blocking_activity.xact_start < now() - interval '1 hour'
   ORDER BY current_statement_xact_start_age DESC;
```

## Long running transactions
```sql
select * from pg_stat_activity where xact_start < now() - interval '1 hour';
```

  Any query with a pg_stat_activity.state == 'idle in transaction' is bad news if they have been in that state for a long time.

### Killing a long running transaction
Once you get the pid from pg_stat_activity, you can kill the long running process (assuming a pid of 6319):
```sql
select pg_cancel_backend(6319);
```

## Replication
If you find that replication is behind, one possible cause is a long running transaction on one of the read-only replicas.

```sql
select * from pg_replication_slots;

select txid_current(), txid_current_snapshot();

select * from pg_stat_replication;
```
  pg_stat_replication.backend_xmin  -- This attribute can show if one of the replicas is beind the others.
