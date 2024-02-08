{
  description = "A flake for EAP jetbrains releases with Wayland support";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      jbrOverlay = final: prev: {
        jetbrains = with prev; {
          jdk = callPackage ./jbr { };
          jcef = callPackage ./jbr/jcef.nix { };
          versions = lib.importJSON ./editors/bin/versions.json;
          vmopts = lib.readFile ./vmopts;
        };
      };
      editorsOverlay = final: prev: {
        jetbrains = with prev;
          (recurseIntoAttrs (callPackages ./editors {
            jdk = jetbrains.jdk;
            versions = jetbrains.versions;
            vmopts = jetbrains.vmopts;
          }) // jetbrains);
      };
    in {
      packages.x86_64-linux = with import nixpkgs {
        system = "x86_64-linux";
        overlays = [ jbrOverlay editorsOverlay ];
        config.allowUnfree = true;
      }; {
        jetbrains = jetbrains;
      };

      overlays.jbrOverlay = jbrOverlay;
      overlays.editorsOverlay = editorsOverlay;
    };
}
