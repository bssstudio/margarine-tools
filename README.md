# MargarineTools

A collection of tools to simplify tasks regarding Btrfs.


## Timesnap

Create a snapshot of a subvolume using current datetime for name and delete
oldest snapshots. Useful to have running in a cronjob every couple of minutes
so you always have a state to revert to if something bad happens.

Example

```bash
timesnap/timesnap.sh /mnt/btrfs-root __root/home timesnap__home 100
```

This will look into `/mnt/btrfs-root` and backup `__root/home` subvolume into
`timesnap__home/<TIMESTAMP>` deleting older snapshots when total number of
snapshots is over a 100.
