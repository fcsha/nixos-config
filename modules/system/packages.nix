{ pkgs, inputs, ... }:

let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ghostty
    brave
    nautilus
    fastfetch
    llmAgents.opencode
    llmAgents.claude-code
    llmAgents.cc-switch-cli
    llmAgents.reasonix
    zenity
    fuzzel
    swaylock-effects
    swaybg
    nodejs_latest
    corepack
    bun
    gcc
    (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
      extensions = [ "rust-src" ];
    }))
  ];
}
