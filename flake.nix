{
  description = "A flake for EAP jetbrains releases with Wayland support";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      overlay = final: prev: {
        jetbrains = {
          jdk = prev.callPackage ./jbr {};
          jcef = prev.callPackage ./jbr/jcef.nix { };
        };
      };
    in {
      packages.x86_64-linux =
        with import nixpkgs { system = "x86_64-linux"; overlays = [overlay]; }; {
          jetbrains = (recurseIntoAttrs
            (callPackages ./editors {jdk = jetbrains.jdk;}) // {
            });
        };
    };
}
