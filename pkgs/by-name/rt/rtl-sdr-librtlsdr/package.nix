{
  rtl-sdr,
  fetchFromGitHub,
}:

rtl-sdr.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "rtl-sdr-librtlsdr";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "librtlsdr";
      repo = "librtlsdr";
      rev = "v${finalAttrs.version}";
      hash = "sha256-I1rbywQ0ZBw26wZdtMBkfpj7+kv09XKrrcoDuhIkRmw=";
    };
    meta = previousAttrs.meta // {
      longDescription = ''
        Fork of the rtl-sdr library by the Osmocom project. A list of differences
        can be found here: https://github.com/librtlsdr/librtlsdr/blob/master/README_improvements.md
      '';
      homepage = "https://github.com/librtlsdr/librtlsdr";
    };
  }
)
