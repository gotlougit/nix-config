{ pkgs, ff-addons }: {
  isDefault = true;
  userChrome = builtins.readFile ./userChrome.css;
  search = {
    default = "brave";
    force = true;
    engines.brave = {
      urls =
        [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
    };
    engines.nix = {
      urls = [{
        template = "https://search.nixos.org/packages?query={searchTerms}";
      }];
      metadata.alias = "@nix";
    };
    engines.hm = {
      urls = [{
        template =
          "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
      }];
      metadata.alias = "@hm";
    };
    engines.aw = {
      urls = [{
        template =
          "https://wiki.archlinux.org/index.php?title=Special:Search&search={searchTerms}";
      }];
      metadata.alias = "@aw";
    };
    engines.source = {
      urls = [{ template = "https://sourcegraph.com/search?q={searchTerms}"; }];
      metadata.alias = "@source";
    };
    engines.github = {
      urls = [{
        template = "https://github.com/search?q={searchTerms}&ref=opensearch";
      }];
      metadata.alias = "@gh";
    };
    engines.Google.metadata.hidden = true;
    engines.Bing.metadata.hidden = true;
  };
  extensions = with ff-addons; [
    darkreader
    libredirect
    sidebery
    ublock-origin
    # vimfx
  ];
  settings = {
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # user chrome
    "extensions.autoDisableScopes" =
      0; # make our addons not disabled by default
    "extensions.installTrigger.enable" = false; # no bunch of popups

    # disable first run page
    "app.normandy.first_run" = false;
    "browser.aboutwelcome.enabled" = false;

    # "extensions.VimFx.config_file_directory" = "${./.}";

    # both home page and new tab blank
    "browser.startup.homepage" = "about:blank";
    "browser.newtabpage.enabled" = false;

    "browser.start.page" = 3; # browser restore

    "extensions.activeThemeID" =
      "firefox-compact-dark@mozilla.org"; # dark theme

    "browser.toolbars.bookmarks.visibility" = "never";

    "browser.uidensity" = 1; # compact mode
    "svg.context-properties.content.enabled" = true; # sideberry icons
    "devtools.toolbox.host" = "window"; # dev tools in new window
    "apz.gtk.kinetic_scroll.enabled" = false; # TODO: evaluate differences
    "browser.search.hiddenOneOffs" = "Google,Bing,Wikipedia (en)";
    "browser.display.background_color.dark" = "#181818";
    "browser.tabs.closeWindowWithLastTab" = false;
    "browser.tabs.insertAfterCurrent" = true;
    "browser.warnOnQuitShortcut" = false;
    "full-screen-api.transition.timeout" = 0;
    "full-screen-api.warning.delay" = 0;
    "full-screen-api.warning.timeout" = 0;
    "layout.css.prefers-color-scheme.content-override" = 0;
    "layout.css.scroll-behavior.spring-constant" = "250";

    "browser.aboutConfig.showWarning" = false;
    "browser.laterrun.enabled" = false;

    # Set download dir
    "browser.download.dir" = "/home/gotlou/Downloads/torbrowser";

    # Sort tabs by recently used
    "browser.ctrlTab.sortByRecentlyUsed" = true;

  };
}
