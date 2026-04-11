{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtl-sdr-blog";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "rtlsdrblog";
    repo = "rtl-sdr-blog";
    rev = finalAttrs.version;
    hash = "sha256-7FpT+BoQ2U8KiKwX4NfEwrO3lMBti7RX8uKtT5dFH8M=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  propagatedBuildInputs = [ libusb1 ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "-DINSTALL_UDEV_RULES=ON"
    "-DWITH_RPC=ON"
  ];

  doInstallCheck = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d" \
      --replace "VERSION_INFO_PATCH_VERSION git" "VERSION_INFO_PATCH_VERSION ${lib.versions.patch finalAttrs.version}"

    substituteInPlace rtl-sdr.rules \
      --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'
  '';

  meta = {
    description = "Software to turn the RTL2832U into a SDR receiver";
    longDescription = ''
      Fork of the rtl-sdr library by the Osmocom project. A list of differences
      can be found here: https://github.com/rtlsdrblog/rtl-sdr-blog/blob/master/README
    '';
    homepage = "https://github.com/rtlsdrblog/rtl-sdr-blog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      bjornfor
      skovati
      Tungsten842
    ];
    platforms = lib.platforms.unix;
    mainProgram = "rtl_sdr";
  };
})
