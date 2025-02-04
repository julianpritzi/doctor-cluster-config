# Accessing the server

All servers in TU munich are accessible from within the TUM network i.e. eduroam and LAN.

Furthermore ls1 employes can use the il1 profile from
[here](https://vpn.rbg.tum.de). This vpn also gives access to the management
network. Students of the university can use the [lrz
openvpn](https://doku.lrz.de/display/PUBLIC/VPN+-+OpenVPN+Testbetrieb) to access
the servers.

All servers in TUM have public ipv6/ipv4 addresses and dns record following the format:

- `$hostname.dse.in.tum.de` for the machine itself.
- `$hostname-mgmt.dse.in.tum.de` for the IPMI/BMC interface.

i.e. bill has the addresses `bill.dse.in.tum.de` and `bill-mgmt.dse.in.tum.de`.

# Hosts

## AMD-Epyc servers

- [graham](graham.md)
- [ryan](ryan.md)

## Servers used for NFS/Services

- [bill](bill.md)
- [nardole](nardole.md)

# CI servers

Those serve as a github action runner for Systemprogramming + cloud systems lab

- [astrid](astrid.md)
- [dan](dan.md)
- [mickey](mickey.md)

## ARM64

- [yasmin](yasmin.md)
- [ethstick11](ethstick11.md): m1 mac mini, no ipmi, in Redhas office, accounts are created manually

## FPGA-servers

Each of these machines is equipped with an Alveo U50 FPGA card.  Those servers
are manually managed by [@atsushikoshiba](@atsushikoshiba). They run ubuntu -
that means that accounts/ssh keys added to this repos won't appear on those
machines.  Those machines also are not backed up.

- [hinoki](hinoki.md)
- sakura

# Storage

We have a shared nfs-based `/home` mounted. The nfs for /home is based on a NVME
disk on nardole and is limited to 1TB. If you need fast local disk access use
`/scratch/$YOURUSER` - however unlike `/home` and `/share` this directory are
not included in the backup. If you want to share larger datasets between
machines use `/share`, which is based on two hard disk (15TB capacity).

Both nfs export stored on `nardole` are also replicated to `bill` every 15
minutes using zfs replication based on
[znapzend](https://github.com/TUM-DSE/doctor-cluster-config/blob/master/modules/nfs/server-backup.nix).
In case there are hardware problems with `nardole`, `bill` can take over serving
the nfs.

# Backups and snapshots

ZFS is used on all machines whenever possible. We enable automatic snapshots of
the filesystem every 15 minutes. The snapshot can be accessed by entering the
`.zfs` directory of a zfs dataset (i.e. `/home/.zfs`, `/share/.zfs` or `/.zfs`).
Furthermore `/share` and `/home` are backed up daily to get RBG storage using
[borgbackup](https://github.com/TUM-DSE/doctor-cluster-config/blob/master/modules/nfs/server.nix)

# Networking

Our chair currently has two networks:

- `il01_16` for the machines:
  - order 10Gbit/s SFP+ connectors for fiber!
  - ipv4: 131.159.102.0/24
  - ipv6: 2a09:80c0:102::/64
- `il01_15` for management
  - usually 1Gbit/s RJ-45
  - ipv4: 172.24.90.0/24

To add a new machine send the MAC address of your host interface and your IPMI/management interface to `ls1.admin@in.tum.de`.
If the RGB group asks which networks to connect your machine to, tell them `il01_16` for the machine and `il01_15` for IPMI/BMC.

## Names left to pick

- sarah
- jackson
- christina
- adelaide
- wilfred
- river
- craig
- jack
