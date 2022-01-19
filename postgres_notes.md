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
  
## Locate index that appear oversized
```sql
SELECT nspname,relname,
       round(100 * pg_relation_size(indexrelid) / pg_relation_size(indrelid)) / 100
       as index_ratio,
       pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
       pg_size_pretty(pg_relation_size(indrelid)) as table_size
  FROM pg_index I
         left join pg_class C on (c.oid = i.indexrelid)
         left join pg_namespace N on (n.oid = c.relnamespace)
  WHERE nspname not in ('information_schema','pg_toast')
         and c.relkind='i'
         and pg_relation_size(indrelid) >0
         and pg_relation_size(indexrelid) >102400000 
  ORDER BY index_ratio DESC;
```

## Locate index in needs of vacuuming

```sql
SELECT psut.relname,
     to_char(psut.last_vacuum, 'YYYY-MM-DD HH24:MI') as last_vacuum,
     to_char(psut.last_autovacuum, 'YYYY-MM-DD HH24:MI') as last_autovacuum,
     to_char(pg_class.reltuples, '9G999G999G999') AS n_tup,
     to_char(psut.n_dead_tup, '9G999G999G999') AS dead_tup,
     to_char(CAST(current_setting('autovacuum_vacuum_threshold') AS bigint)
         + (CAST(current_setting('autovacuum_vacuum_scale_factor') AS numeric)
            * pg_class.reltuples), '9G999G999G999') AS av_threshold,
     CASE
         WHEN CAST(current_setting('autovacuum_vacuum_threshold') AS bigint)
             + (CAST(current_setting('autovacuum_vacuum_scale_factor') AS numeric)
                * pg_class.reltuples) < psut.n_dead_tup
         THEN '*'
         ELSE ''
     END AS expect_av
  FROM pg_stat_all_tables psut
     JOIN pg_class on psut.relid = pg_class.oid
  ORDER BY expect_av DESC;
```

# Estimate size of partitions

```
SELECT relid::regclass, n_live_tup FROM pg_stat_all_tables JOIN pg_inherits ON (relid = inhrelid) WHERE inhparent = 'screen_views'::regclass order by n_live_tup desc;
```
