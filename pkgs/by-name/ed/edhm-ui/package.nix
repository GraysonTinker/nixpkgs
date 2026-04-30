# Elite Dangerous HUD Mod UI - GUI for managing HUD color modifications
# Note: Includes DLLs from the GPLv3-licensed 3Dmigoto project, and an unmodified redistributable Microsoft DirectX library
# - https://github.com/bo3b/3Dmigoto
# - See long description for more details
# Note: The underlying tool, EDHM, is restrictively licensed (see the 'edhm-custom' license)
# - Explicit redistribution permission granted by EDHM copyright holder for the purpose of inclusion in Nixpkgs only
# - https://github.com/psychicEgg/EDHM/blob/main/REDISTRIBUTION_EXCEPTION.md
{
  lib,
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  unzip,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  electron-bin,
  gtk3,
  libgbm,
  nss,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "edhm-ui";
  version = "3.0.64";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/BlueMystical/EDHM_UI/releases/download/v${finalAttrs.version}/edhm-ui-v3-linux-x64.zip";
    hash = "sha256-kBCaQKGO8ySpquEWh91GyqHfHCem5q1gyVdYuWdaMB8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libgbm
    nss
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "edhm-ui";
      exec = "edhm-ui";
      icon = "edhm-ui";
      desktopName = "EDHM UI";
      comment = "Elite Dangerous HUD Mod Manager";
      categories = [
        "Game"
        "Utility"
      ];
      startupWMClass = "edhm-ui-v3";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/edhm-ui

    # Symlink everything from electron to begin
    ln -s ${electron-bin}/libexec/electron/* $out/opt/edhm-ui

    # Remove non-generics
    rm $out/opt/edhm-ui/{*.bin,icudtl.dat,resources.pak,resources,locales}
    rm $out/opt/edhm-ui/electron # Source doesn't come with this

    # Copy application-specific resources
    install -m755 edhm-ui-v3 $out/opt/edhm-ui/edhm-ui-v3
    cp *.bin icudtl.dat resources.pak $out/opt/edhm-ui
    cp -r resources locales $out/opt/edhm-ui

    # Create symlink
    mkdir -p $out/bin
    ln -s $out/opt/edhm-ui/edhm-ui-v3 $out/bin/edhm-ui

    # Install icon
    install -Dm644 $out/opt/edhm-ui/resources/images/icon.png $out/share/icons/hicolor/256x256/apps/edhm-ui.png

    runHook postInstall
  '';

  meta = {
    description = "HUD modification manager for Elite Dangerous";
    homepage = "https://github.com/BlueMystical/EDHM_UI";
    license = [
      lib.licenses.gpl3Only
      {
        shortName = "edhm-custom";
        fullName = "EDHM Custom Restrictive License - Non-redistributable";
        free = false;
        redistributable = false;
      }
    ];
    maintainers = with lib.maintainers; [
      graysontinker
      michael-k-williams
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "edhm-ui";
    longDescription = ''
      EDHM UI is a GPL v3 licensed user interface for managing Elite Dangerous HUD modifications.
      It includes EDHM (Elite Dangerous HUD Mod) which has a custom restrictive license.

      Redistribution Permission: The copyright holder Fred89210 has granted explicit
      permission for EDHM to be redistributed as part of the EDHM-UI package in Nixpkgs
      (see REDISTRIBUTION_EXCEPTION.md in the EDHM repository).

      DLL Components: The package includes DLLs from the GPLv3-licensed 3Dmigoto project and an unmodified Microsoft DirectX library
      - d3dcompiler_46.dll (Microsoft DirectX Runtime v9.30.9200.20789, distributed as part of 3Dmigoto v1.3.16)
        - "You can redistribute this DLL to other computers with your application as a side-by-side DLL."
        - https://learn.microsoft.com/en-us/windows/win32/directx-sdk--august-2009-
      - d3d11.dll (from 3Dmigoto v1.3.16)
      - nvapi64.dll (from 3Dmigoto v1.3.16)
      The 3Dmigoto project can be found at https://github.com/bo3b/3Dmigoto

      Note: The underlying EDHM tool normally has a custom license with significant restrictions:
      - Personal and non-commercial use only unless otherwise agreed
      - No modification, redistribution, or reuse without explicit permission
      - All rights reserved by original authors (Fred89210 and psychicEgg)

      This is a fan-made modification for Elite Dangerous and is not affiliated with
      Frontier Developments plc.
    '';
  };
})
