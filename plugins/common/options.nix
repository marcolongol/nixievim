{lib, ...}:
with lib; {
  options.wKeyList = mkOption {type = types.listOf types.attrs;};
  options.nixievim = {
    mkKey = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
