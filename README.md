For simple use, run `nix run 'github:BananchickPasha/jbr-wayland-nix#jetbrains.<name-of-ide>'`

### Overlays

This flake provides two overlays:

* jbrOverlay - contains jbr21 runtime, as well as vmopts and versions of editors. 
* editorsOverlay - slightly modified code from `nixpkgs.jetbrains`, to allow configuring of jdk, versions and vmoptions using overlays.

For modifying jbr21, versions of IDEs, or vmoptions, you need to setup your overlay:
```nix
      myCustomOverlay = final: prev: {
        jetbrains = with prev;
          jetbrains // {
            jdk = prev.jetbrains.override {...};
            vmopts = "my opts";
            versions.x86_64-linux.rider = {
              "update-channel" = "Rider RELEASE";
              "url-template" =
                "https://download.jetbrains.com/rider/JetBrains.Rider-{version}.tar.gz";
              "version" = "2023.3.2";
              "sha256" =
                "22a35999146be6677260e603cf6af06dbbfa4c2d6e6ec653b2a9e322f954924d";
              "url" =
                "https://download.jetbrains.com/rider/JetBrains.Rider-2023.3.2.tar.gz";
              "build_number" = "233.13135.100";
            };
          };
      };
```

For setting it up, you need to put it between two overlays from this flake:

```nix
    let myCoolIde = 
with import nixpkgs {
      system = "x86_64-linux";
      overlays =
        with this-flake.overlays; [ jbrOverlay myCustomOverlay editorsOverlay ];
      config.allowUnfree = true;
    };
    jetbrains.my-ide;
```
