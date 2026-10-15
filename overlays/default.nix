{...}: {
  # ponytail: root nixpkgs is nixos-unstable, so this is a passthrough alias.
  # Swap for `import inputs.nixpkgs-unstable {...}` if nixpkgs ever moves to a
  # release channel.
  flake.overlays.default = _final: prev: {
    unstable = prev;
  };
}
