{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;

    nativeMessagingHosts = with pkgs; [ keepassxc ];

    profiles.personal = {

      name = "personal";

      id = 0;

      isDefault = true;

      settings = {
        "browser.formfill.enable" = false;
        "browser.formfill.expire_days" = 0;
        "browser.newtabpage.enabled" = false;
        "browser.sessionstore.restore_tabs_lazily" = false;
        "browser.startup.homepage" = "about:blank";
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.uidensity" = 1;
        "datareporting.healthreport.uploadEnabled" = false;
        "devtools.cache.disabled" = true;
        "devtools.command-button-measure.enabled" = true;
        "devtools.command-button-screenshot.enabled" = true;
        "devtools.editor.keymap" = "vim";
        "devtools.responsive.leftAlignViewport.enabled" = true;
        "devtools.toolbox.host" = "right";
        "devtools.webconsole.timestampMessages" = true;
        "dom.webnotifications.enabled" = true;
        "extensions.pocket.enabled" = false;
        "font.name.monospace.x-western" = "Iosevka";
        "general.warnOnAboutConfig" = false;
        "privacy.firstparty.isolate" = false;
        "privacy.resistFingerprinting" = false;
        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "dom.webmidi.enabled" = true;
        "dom.webmidi.gated" = false; # otherwise webmidi requires an addon
      };

      userChrome = ''
        /*
          Hide horizontal tabs at the top of the window 
          https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#hide-horizontal-tabs-at-the-top-of-the-window-1349-1672-2147
        */
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
          opacity: 0;
          pointer-events: none;
        }
        #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
            visibility: collapse !important;
        }

        /*
          Reduce minimum width of the sidebar
          https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#reduce-minimum-width-of-the-sidebar-1373
        */
        #sidebar {
          min-width: 16px !important;
        }

        /*
          Auto-hide sidebar when fullscreen
          https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#auto-hide-sidebar-when-fullscreen-1548
        */
        #main-window[inFullscreen] #sidebar-box,
        #main-window[inFullscreen] #sidebar-splitter {
          display: none !important;
          width: 0px !important;
        }
      '';
    };
  };
}
