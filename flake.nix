{
  description = "A flake for pam-fprint-grosshack";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = with import nixpkgs { system = "x86_64-linux"; }; {
      jetbrains = (recurseIntoAttrs
        (callPackages ./editors {
          jdk = jetbrains.jdk;
        }) // {
          jdk-no-jcef = callPackage ./jbr {
            withJcef = false;
          };
          jdk = callPackage ./jbr { };
          jcef =
            callPackage ./jbr/jcef.nix { };
        });
    };
  };
}
