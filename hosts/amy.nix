{ lib, config, pkgs, ... }: {
  networking.hostName = "amy";
  networking.retiolum = {
    ipv4 = "10.243.29.181";
    ipv6 = "42:0:3c46:1551:1906:bc7c:801f:3c4";
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /home/ fd9a:5371:cd3f::/64(rw,nohide,insecure,no_subtree_check,no_root_squash)
  '';

  systemd.network.networks."08-dhcp-internal".extraConfig = ''
    [Match]
    MACAddress = 9c:69:b4:60:ba:cc
    Type = ether

    [Network]
    DHCPServer = yes
    IPv6SendRA = yes
    Address = 192.168.161.1/24
    Address = fd9a:5371:cd3f::1/64

    [DHCPServer]
    EmitRouter = no

    [IPv6Prefix]
    Prefix = fd9a:5371:cd3f::/64

    [IPv6SendRA]
    RouterPreference = low
    # don't act as a router
    RouterLifetimeSec = 0
  '';

  sops.secrets.edinburgh-borgbackup-ssh = {};
  sops.secrets.edinburgh-borgbackup-password = {};
  services.borgbackup.jobs.all-homes = {
    paths = [ "/home" ];
    exclude = [ "/home/dimitra/workspace/rocksdb-5.6-native" ];
    doInit = true;
    repo = "/mnt/backup/borgbackup";
    preHook = ''
      ${pkgs.sshfs}/bin/sshfs -oIdentityFile=${config.sops.secrets.edinburgh-borgbackup-ssh.path} -oPort=22222 s1443541@csce.datastore.ed.ac.uk:/csce/datastore/inf/users/s1443541 /mnt/backup
    '';
    postHook = ''
      cat > /var/log/telegraf/borgbackup-datastore <<EOF
      task,frequency=daily last_run=$(date +%s)i,state="$([[ $exitStatus == 0 ]] && echo ok || echo fail)"
      EOF
    '';
    encryption = {
      mode = "repokey";
      passCommand = "cat ${config.sops.secrets.edinburgh-borgbackup-password.path}";
    };
    compression = "auto,zstd";
    startAt = "daily";
    prune.keep = {
      within = "1d"; # Keep all archives from the last day
      daily = 7;
      weekly = 4;
      monthly = 0;
    };
  };
  # hide sshfs from the system
  systemd.services.borgbackup-job-all-homes.serviceConfig.PrivateMounts = true;
  systemd.services.borgbackup-job-all-homes.serviceConfig.ReadWritePaths = [ "/var/log/telegraf" ];

  fileSystems."/home" = {
    device = "zroot/root/home";
    fsType = "zfs";
  };

  system.stateVersion = "19.09";
}
