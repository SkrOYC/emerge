{ pkgs, lib, config, ... }:

{
  # https://devenv.sh/basics/
  env = {
    BUN_VERSION = "1.3.8";
    NODE_ENV = "development";
  };

  # https://devenv.sh/packages/
  # Bun runtime and core tooling
  # Bun handles TypeScript natively, no separate language config needed
  packages = [
    pkgs.bun
    pkgs.git
    pkgs.nss # Mozilla Network Security Services for SSL certs
  ];

  # https://devenv.sh/processes/
  # Development server with hot reload
  processes.dev.exec = "bun run --hot src/index.ts";

  # https://devenv.sh/scripts/
  scripts.check.exec = "bun check";
  scripts.fix.exec = "bun fix";
  scripts.test.exec = "bun test";

  # https://devenv.sh/basics/
  enterShell = ''
    echo "Emerge - LLM Dialogue Research Platform"
    bun --version
    git --version
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running test suite..."
    bun test
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.shellcheck.enable = true;

  # https://devenv.sh/services/
  # SQLite is built into bun:sqlite - no external service needed

  # See full reference at https://devenv.sh/reference/options/
}
