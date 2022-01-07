{
  inputs.dream2nix.url = "github:nix-community/dream2nix";
  #inputs.dream2nix.inputs.node2nix.inputs.nixpkgs.follows.url 
  outputs = { self, nixpkgs, dream2nix }@inputs:
    let
      dream2nix = inputs.dream2nix.lib.init {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    in {
      packages.x86_64-linux.good-simple-site = (dream2nix.riseAndShine {
        source = self.outPath;
        packageOverrides = {
            simple-site = {
              yarn = {
                preBuild = ''
                  alias yarn=${./src/bad/yarn}
                  '';
              };
            };
        };
      }).defaultPackage.x86_64-linux;

      packages.x86_64-linux.bad-simple-site = (dream2nix.riseAndShine {
        source = self.outPath;
      }).defaultPackage.x86_64-linux;

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.good-simple-site;
    };
}
