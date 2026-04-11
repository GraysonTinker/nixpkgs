{
  rtl-sdr,
  fetchFromGitea,
}:

rtl-sdr.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "rtl-sdr-osmocom";
    version = "2.0.1";

    src = fetchFromGitea {
      domain = "gitea.osmocom.org";
      owner = "sdr";
      repo = "rtl-sdr";
      rev = "v${finalAttrs.version}";
      hash = "sha256-+RYSCn+wAkb9e7NRI5kLY8a6OXtJu7QcSUht1R6wDX0=";
    };
    meta = previousAttrs.meta // {
      longDescription = "Rtl-sdr library by the Osmocom project";
      homepage = "https://gitea.osmocom.org/sdr/rtl-sdr";
    };
  }
)
