const OPTIONS = {
  "prevent_autofocus": true,
  "hints.chars": "fjdksla;ghrueiwonc mv",
  "scroll.repeat_timeout": 12,
  "mode.normal.focus_location_bar": "O",
  "mode.normal.focus_search_bar": "",
  "mode.normal.paste_and_go": "",
  "mode.normal.go_up_path": "",
  "mode.normal.go_home": "",
  "mode.normal.history_back": "h",
  "mode.normal.history_forward": "l",
  "mode.normal.history_list": "gh",
  "mode.normal.stop": "",
  "mode.normal.scroll_left": "",
  "mode.normal.scroll_right": "",
  "mode.normal.scroll_down": "D",
  "mode.normal.scroll_up": "S",
  "mode.normal.scroll_half_page_up": "s",
  "mode.normal.tab_new": "",
  "mode.normal.tab_new_after_current": "",
  "mode.normal.tab_select_previous": "gT",
  "mode.normal.tab_select_next": "gt",
  "mode.normal.tab_select_most_recent": "gl c",
  "mode.normal.tab_select_first": "t",
  "mode.normal.tab_select_first_non_pinned": "T",
  "mode.normal.focus_text_input": "i",
  "mode.normal.enter_mode_ignore": "gi",
  "mode.normal.edit_blacklist": "",
  "mode.normal.esc": "<force><escape> <force><f9>",
  "mode.hints.exit": "<f9>",
  "mode.ignore.exit": "<force><f1>",
  "mode.find.exit": "<f9>    <escape>    <enter>",
  "custom.mode.normal.tab_select_next": "J",
  "custom.mode.normal.custom_hint_command_example": "M",
  "custom.mode.normal.tab_select_previous": "K",
  "custom.mode.normal.mk_new_tab": "o",
  "custom.mode.normal.request_pip": "p",
  "custom.mode.normal.search_tabs": "t",
  "custom.mode.normal.show_bw": "gb",
  "custom.mode.normal.show_overflow": "ga",
  "custom.mode.normal.show_sidebar": "gs",
  "custom.mode.normal.show_toolbox": "gu",
  "custom.mode.normal.tab_select_next_sidebar": "j",
  "custom.mode.normal.tab_select_previous_sidebar": "k"
};

Object.entries(OPTIONS).forEach(([option, value]) => vimfx.set(option, value))

// allow permissions for sidebery
async function allow_sidebery_in_private() {
  const lazy = {};
  Components.utils.import("resource://gre/modules/XPCOMUtils.jsm", this);
  XPCOMUtils.defineLazyModuleGetters(lazy, {
    AddonManager: "resource://gre/modules/AddonManager.jsm",
    ExtensionParent: "resource://gre/modules/ExtensionParent.jsm",
    ExtensionPermissions: "resource://gre/modules/ExtensionPermissions.jsm",
  });
  const SIDEBERY_ID = "{3c078156-979c-498b-8990-85f7987dd929}";
  const PRIVATE_BROWSING_PERMS = {
    permissions: ["internal:privateBrowsingAllowed"],
    origins: [],
  };
  const addon = await lazy.AddonManager.getAddonByID(SIDEBERY_ID);
  let policy = lazy.ExtensionParent.WebExtensionPolicy.getByID(addon.id);
  let extension = policy && policy.extension;
  await lazy.ExtensionPermissions.add(
    addon.id,
    PRIVATE_BROWSING_PERMS,
    extension,
  );
}

allow_sidebery_in_private();
const { commands } = vimfx.modes.normal;

function search_tabs(args) {
  const gURLBar = args.vim.window.gURLBar;
  if (gURLBar._vim_hooked === undefined) {
    gURLBar._vim_hooked = true;
    const oldPickResult = Object.getPrototypeOf(gURLBar).pickResult;
    gURLBar.pickResult = function (result, event, element, browser) {
      commands.esc.run(args);
      oldPickResult.call(this, result, event, element, browser);
    };
  }
  commands.focus_location_bar.run(args);
  // Change the `*` on the text line to a `%` to search tabs instead of
  // bookmarks.
  gURLBar.value = "% ";
  gURLBar.search(gURLBar.value);
}

vimfx.addCommand(
  { name: "search_tabs", description: "Search tabs", category: "tabs" },
  search_tabs
);

let hideTimeout = null;
function showSidebar(args, timeout) {
  const window = args.vim.window;
  window.document
    .getElementById("sidebar-box")
    .classList.add("sidebar-selected");

  window.clearTimeout(hideTimeout);
  hideTimeout = window.setTimeout(function () {
    window.document
      .getElementById("sidebar-box")
      .classList.remove("sidebar-selected");
  }, timeout || 1000);
}

function after(cmd, func) {
  return function (args) {
    cmd.run(args);
    func(args);
  };
}

vimfx.addCommand(
  {
    name: "tab_select_next_sidebar",
    description: "Focus next tab Sidebar",
    category: "tabs",
  },
  after(commands.tab_select_next, showSidebar)
);

vimfx.addCommand(
  {
    name: "tab_select_previous_sidebar",
    description: "Focus previous tab Sidebar",
    category: "tabs",
  },
  after(commands.tab_select_previous, showSidebar)
);

vimfx.addCommand(
  {
    name: "show_sidebar",
    description: "Show Sidebar",
    category: "tabs",
  },
  (args) => {
    showSidebar(args, 10000);
  }
);

vimfx.addCommand(
  {
    name: "mk_new_tab",
    description: "Make new tab",
    category: "tabs",
    order: commands.tab_new.order + 1,
  },
  (args) => {
    const browser = args.vim.browser;
    if (
      browser.currentURI.spec == "about:blank" &&
      !browser.webProgress.isLoadingDocument
    ) {
      commands.focus_location_bar.run(args);
    } else {
      commands.tab_new.run(args);
    }
  }
);

vimfx.addCommand(
  {
    name: "request_pip",
    description: "Request Picture in Picture",
  },
  (args) => {
    args.vim.window.PictureInPicture.onCommand(args.event);
  }
);

vimfx.addKeyOverrides([
  (location) => location.href.match(/youtube.com\/watch/),
  ["f", "m", "<space>", "<s-space>"],
]);

let visible = false;
vimfx.addCommand(
  {
    name: "show_toolbox",
    description: "Show Toolbox",
  },
  (args) => {
    visible = !visible;
    if (visible) {
      args.vim.window.document.querySelector("#navigator-toolbox").setAttribute("vim_visible", "")
    } else {
      args.vim.window.document.querySelector("#navigator-toolbox").removeAttribute("vim_visible")
    }
  }
);

function btn_clicker(q) {
  return (args) => {
    args.vim.window.document.querySelector(q).click()
  }
}

vimfx.addCommand(
  {
    name: "show_overflow",
    description: "Show overflow menu",
  },
  btn_clicker("#nav-bar-overflow-button"),
);

// function del_key(id) {
//   document.querySelector(`key#${id}`).remove()
// }
// del_key("key_find");
// del_key("key_reload");
// del_key("goBackKb");
// del_key("goForwardKb");
