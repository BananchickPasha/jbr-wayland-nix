{
  description = "A flake for EAP jetbrains releases with Wayland support";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      jbrOverlay = final: prev: {
        jetbrains = with prev; {
          jdk = callPackage ./jbr { };
          jdk-no-jcef = callPackage ./jbr { withJcef = false; };
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

      forSystem = system: with import nixpkgs
        {
          inherit system;
          overlays = [ jbrOverlay editorsOverlay ];
          config.allowUnfree = true;
        }; {
        jetbrains = jetbrains;
      };
    in
    {
      packages.x86_64-linux = forSystem "x86_64-linux";
      packages.aarch64-linux = forSystem "aarch64-linux";

      overlays.jbrOverlay = jbrOverlay;
      overlays.editorsOverlay = editorsOverlay;
    };
}
