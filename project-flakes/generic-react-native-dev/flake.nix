{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "react-native";
        buildInputs = with pkgs; [
          nodejs
          nodePackages.typescript-language-server
          nodePackages.expo-cli
          nodePackages.create-react-app
        ];
      };
    };
}

