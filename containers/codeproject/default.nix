let
  hostName = "codeproject";
in
  {
    spaghetti,
    config,
    pkgs,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [32168];
    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "codeproject/ai-server";
      ports = ["32168:32168"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.docker/${hostName}/data:/etc/codeproject/ai"
        "/home/${spaghetti.user}/.docker/${hostName}/app:/app"
      ];
      extraOptions = [
        "--device=/dev/apex_0:/dev/apex_0"
      ];
    };
    /*
    home-manager.users.${spaghetti.user}.home.file.".docker/codeproject/data/modulesettings.json".text = ''
            {
        "Modules": {
          "FaceProcessing": {
            "LaunchSettings": {
              "AutoStart": false
            },
            "GpuOptions": {}
          },
          "ObjectDetectionYOLOv5-6.2": {
            "LaunchSettings": {
              "AutoStart": false
            },
            "GpuOptions": {}
          },
          "ObjectDetectionCoral": {
            "LaunchSettings": {
              "AutoStart": true
            },
            "GpuOptions": {}
          }
        }
      }
    '';
    */
  }
