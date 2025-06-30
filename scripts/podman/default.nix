{...}: {
  systemd.timers."podman-backup" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Tue 02:00:00";
      Unit = "podman-backup.service";
    };
  };

  systemd.services."podman-backup" = {
    script = ''
      #!/usr/bin/env bash

      # from https://gist.github.com/Nitrousoxide/43ed81840c542965b76c08c60b69b1da

      # using sudo here as podman containers in my configuration are started with sudo currently

      # Get a list of all volumes
      volumes=$(sudo podman volume ls -q)

      # get timestamp for unique filename
      timestamp=$(date +"%d.%m.%Y-%H%M")

      # Pause all running containers
      echo "Pausing containers for backup"
      sudo podman pause $(sudo podman ps -q)

      # cd into our backup location
      cd /etc/oci.cont.nvme/backup

      # Iterate over the volumes
      for volume in $volumes
      do

      # backup the listed vols
          echo "Backing up ''${volume}..."
          sudo podman volume export ''${volume} --output /etc/oci.cont.nvme/backup/''${volume}.tar
          # Check if the podman volume export was successful
          if [ $? -ne 0 ]; then
              echo "An error occurred while exporting podman volume ''${volume}"
              exit 1
          fi
      done

      # Unpause all paused containers
      echo "Resuming containers"
      sudo podman unpause $(sudo podman ps -aq)

      # Archive and compress all .tar files that do not match the pattern podman-backup_*.tar.gz
      echo "Combining volume archives into compressed tar..."
      tar cvzf podman-backup_''${timestamp}.tar.gz --exclude='podman-backup_*.tar.gz' *.tar

      # Check if the tar command was successful
      if [ $? -eq 0 ]; then
          # If the tar command was successful, remove the .tar files that do not match the pattern podman-backup_*.tar.gz
          echo "Archiving successful, removing individual .tar files..."
          find . -maxdepth 1 -type f -name "*.tar" ! -name "podman-backup_*.tar.gz" -exec rm -f {} \;
      else
          # If the tar command failed, print an error message
          echo "An error occurred during archiving, no files have been deleted."
          exit 1
      fi

      # Remove .tar.gz files older than a month that do not match the pattern podman-backup_*.tar.gz
      echo "Removing .tar.gz files older than a month..."
      find . -maxdepth 1 -type f -name "*.tar.gz" ! -name "podman-backup_*.tar.gz" -mtime +30 -exec rm -f {} \;

      # Check if the old files deletion was successful
      if [ $? -ne 0 ]; then
          echo "An error occurred while deleting old .tar.gz files."
          exit 1
      fi

      echo "Backup Complete"
      cd ~
      exit 0
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
