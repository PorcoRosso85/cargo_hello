{
  description = "A flake for building a Rust application using rustPlatform.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # Nixpkgsの最新バージョンを指定
    flake-utils.url = "github:numtide/flake-utils";        # flake-utilsを使用
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = import nixpkgs { inherit system; };  # 指定したシステムに基づいてNixpkgsをインポート
      in {
        packages.cargo_hello = pkgs.rustPlatform.buildRustPackage {
            pname = "cargo_hello";  # パッケージ名
            version = "0.1.0";  # バージョン

            src = pkgs.fetchFromGithub {
                owner = "PorcoRosso85";
                repo = "cargo_hello";
                rev = "master";
            };  # ソースコードのパス

            cargoLock = {
              lockFile = ./Cargo.lock;  # Cargo.lockファイルの指定
            };

            nativeBuildInputs = [ pkgs.pkg-config ];  # ビルド時に必要な依存関係
            buildInputs = [ pkgs.openssl ];  # 実行時に必要なライブラリ
          };

        defaultPackage = packages.cargo_hello;  # デフォルトでビルドされるパッケージ
      }
    );
# }
