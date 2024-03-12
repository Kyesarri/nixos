{
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    programs.vscode = {
      enable = true;
      /*
        userSettings = {
        "window.titleBarStyle" = "custom";
        "terminal.integrated.fontFamily" = "Hack Nerd Font Mono";
        "editor.fontFamily" = "Hack Nerd Font Mono";
        "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
      };
      */
      # titleBarStyle = custom for no crashy crashy in wayland
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        # enkia.tokyo-night # removed # TODO nix-colors theme
        yzhang.markdown-all-in-one
        kamadorueda.alejandra
        bbenoist.nix
        gruntfuggly.todo-tree
      ];
    };

    home.file.".config/hypr/per-app/codium.conf" = {
      text = ''
        windowrule = tile, title:VSCodium
        bind = $mainMod, K, exec, codium
      '';
    };
    home.file.".config/VSCodium/User/settings.json" = {
      text = ''
        {
          "editor.bracketPairColorization.independentColorPoolPerBracketType": true,
          "editor.fontFamily": "Hack Nerd Font Mono",
          "terminal.integrated.fontFamily": "Hack Nerd Font Mono",
          "window.titleBarStyle": "custom",
          "editor.renderWhitespace": "trailing",
          //
          "editor.tokenColorCustomizations": {
            "comments": "#24A8B499",
            "functions": "#E3E6EE",
            "keywords": "#B072D1",
            "strings": "#EFB993",
            "numbers": "#E93C58",
            "variables": "#E3E6EEff",
            "types": "#9DA0A2",
            "textMateRules": [
              { "scope": [ "entity.other.attribute-name.multipart.nix", ],
                "settings": { "foreground": "#EFAF8EFF", "fontStyle": "bold",},
              },
              { "scope": [ "constant.language.nix", "variable.parameter.name.nix", ],
                "settings": { "foreground": "#24A8B4", "fontStyle": "italic",},
              },
              { "scope": [ "string.quoted.other.nix", "string.quoted.double.nix", ],
              "settings": { "foreground": "#E58D7D", "fontStyle": "italic",},
              },
              { "scope": ["comment", "comment.block",],
                "settings": { "foreground": "#DF5273AA","fontStyle": "italic bold", }
              }
            ]
          },

          "workbench.colorCustomizations": {
            //
            "markdown.extension.print.theme": "dark",

            //
            /*
            "editorBracketHighlight.foreground1": "#ff6767",
            "editorBracketHighlight.foreground2": "#3de890",
            "editorBracketHighlight.foreground3": "#90e83d",
            "editorBracketHighlight.foreground4": "#903de8",
            "editorBracketHighlight.foreground5": "#3d90e8",
            "editorBracketHighlight.foreground6": "#e83d90",*/

            // menu
            "menubar.selectionForeground":"#E3E6EE",
            "menubar.selectionBackground":"#2E303E",
            "menubar.selectionBorder":"#00000000",
            //
            "menu.foreground":"#E3E6EE",
            "menu.background":"#232530",
            //
            "menu.selectionForeground":"#E3E6EE",
            "menu.selectionBackground":"#2E303E",
            "menu.separatorBackground":"#2E303E",
            "menu.border":"#00000000",
            //
            "foreground": "#E3E6EE",                        // directory listing text top, tab tooltip text
            //
            // titlebar
            "window.inactiveBorder": "#1C1E26",
            "window.activeBorder": "#0d0f17",
            "descriptionForeground": "#aafeee",             // lables and such
            //
            // editor
            "editor.background": "#1C1E26",                 // editor background
            "editor.foreground": "#DCDFE4",                 // basic text colour, , : ; and so forth
            //
            "editorCursor.foreground": "#E3E6EE",           // | this lad
            "editorWhitespace.foreground": "#E3E6EE",       // whitespace characters
            //
            "editor.lineHighlightBackground": "#B072D122",  // highlighted line, needs another transparency added 99 wont cut 44 good
            "editor.selectionBackground": "#DF527366",      // highlighted text, using same as above
            "editor.selectionHighlightBackground": "#E93C5866",
            //
            // toolbar
            "toolbar.activeBackground": "#B072D1",          //
            "toolbar.activeForeground": "#B072D1",            // unsure of these two for now
            //
            // activitybar / sidebars
            "activityBar.background": "#1C1E26",            // background colour
            "activityBar.foreground": "#DF5273",            // forefround colour, icons
            "activityBar.inactiveForeground": "#9DA0A2",    // inactive icon colour
            "activityBar.border": "#2E303E",              // divider between action bar and tree / explorer
            "activityBarBadge.background": "#DF5273",       // badge icon background colour
            "activityBarBadge.foreground": "#E3E6EE",       // badge text / icon colour
            "activityBar.activeBorder": "#DF5273",          // highlighted icon border colour
            "activityBar.activeBackground": "#2E303E",
            //
            // sidebar, tree and such
            "sideBar.background": "#232530",
            "list.hoverBackground": "#6F6F70",
            "list.hoverForeground": "#1C1E26",
            "list.dropBackground": "#1e202e",
            "sideBarSectionHeader.border": "#00000000",
            "sideBar.border": "#DF5273",
            "sideBar.dropBackground": "#B072D144",
            "sideBar.foreground": "#CBCED0",                // text colour
            "sideBarSectionHeader.background": "#2E303E",   // headers in sidebar
            "sideBarSectionHeader.foreground": "#E3E6EE",   // header text colour
            "focusBorder": "#ffffff",
            "list.focusAndSelectionOutline": "#DF5273",
            "list.activeSelectionBackground": "#6F6F70",
            "list.activeSelectionForeground": "#1C1E26",
            "statusBarItem.remoteBackground": "#24A8B4",
            "statusBarItem.remoteForeground": "#1C1E26",
            "statusBar.background": "#1C1E26",
            "statusBar.border": "#2E303E",
            "statusBar.foreground": "#CBCED0",
            //
            // tabs
            "editorGroupHeader.tabsBackground": "#1C1E26",
            "tab.activeBackground": "#2E303E",              // active tab background
            "tab.hoverBackground": "#2E303E",               // hover background
            "tab.inactiveBackground": "#232530",            // inactive tab background
            "tab.activeForeground": "#DCDFE4",              // text
            "tab.hoverForeground": "#E3E6EE",               // hover text
            "tab.activeBorder": "#00000000",                // border colour
            "tab.activeBorderTop": "#00000000",             // top border colour
            "tab.inactiveForeground": "#9DA0A2",            // inactive text
            "tab.border": "#00000000",                      // left / right hand borders
            "gitDecoration.stageModifiedResourceForeground": "#24A8B4",
            "gitDecoration.modifiedResourceForeground": "#EFAF8E",
            //
            "tab.unfocusedActiveForeground": "#E3E6EE",   // when using tab groups
            "tab.unfocusedInactiveForeground": "#9DA0A2", // same as above
            "tab.unfocusedActiveBorderTop": "#00000000",  //
            "tab.dragAndDropBorder": "#DF5273",
            "tab.unfocusedHoverBackground": "#2E303E",
            //
            "tab.unfocusedHoverForeground": "#E3E6EE",    // hover inactive text
            "tab.activeModifiedBorder": "#00000000",      // all transparent
            "tab.inactiveModifiedBorder": "#00000000",    //
            "tab.unfocusedActiveBorder": "#00000000",     //
            "tab.lastPinnedBorder": "#00000000",          //

            //
            // titlebar
            "titleBar.activeForeground": "#E3E6EE",       // text
            "titleBar.inactiveForeground": "#6F6F70",     // text inactive
            "titleBar.activeBackground": "#1C1E26",       // top-bar background
            "titleBar.inactiveBackground": "#232530",     // when inactive window, titlebar background
            "titleBar.border": "#2E303E",                 // border of titlebar, meh
            // random things i never added to a category
            "panel.background": "#1C1E26",
            "input.background": "#232530",
            "minimap.background": "#232530",              // big scroll boi background
            "minimap.selectionOccurrenceHighlight": "#E93C5844",
            "minimap.findMatchHighlight": "#E93C5899",
            "minimap.selectionHighlight": "#24A8B499",
            "button.background": "#DF5273",
            "badge.background": "#E93C58",
            "checkbox.background": "#1C1E26",
            "checkbox.foreground": "#6F6F70",
            "checkbox.border": "#232530",
            "dropdown.background": "#1C1E26",
            "textLink.foreground": "#E93C58"
          },
        }
      '';
    };
  };
}
