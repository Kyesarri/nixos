{
  pkgs,
  config,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.nixd];

  home-manager.users.${spaghetti.user} = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        yzhang.markdown-all-in-one
        kamadorueda.alejandra
        bbenoist.nix
        gruntfuggly.todo-tree
        # schoofskelvin.vscode-sshfs # not packaged, reminder for myself here to install manually
      ];
    };
    # hyprland window rules / binds
    home.file.".config/hypr/per-app/codium.conf" = {
      text = ''
        # windowrule = tile, title:VSCodium # was causing pop-up / prompts to be full-screen
        bind = $mainMod, K, exec, codium
        windowrulev2 = bordercolor $cd99, initialClass:^(codium-url-handler)$
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
            "comments": "#${config.colorScheme.palette.base0C}99",
            "functions": "#${config.colorScheme.palette.base07}",
            "keywords": "#${config.colorScheme.palette.base08}",
            "strings": "#${config.colorScheme.palette.base0A}",
            "numbers": "#${config.colorScheme.palette.base0E}",
            "variables": "#${config.colorScheme.palette.base07}ff",
            "types": "#${config.colorScheme.palette.base04}",
            "textMateRules": [
              { "scope": [ "entity.other.attribute-name.multipart.nix", ],
                "settings": { "foreground": "#${config.colorScheme.palette.base07}", "fontStyle": "",},
              },
              { "scope": [ "keyword.other.nix", "keyword.other.inherit.nix", ],
                "settings": { "foreground": "#${config.colorScheme.palette.base0E}", "fontStyle": "italic",},
              },
              { "scope": [ "string.quoted.other.nix", ],
              "settings": { "foreground": "#${config.colorScheme.palette.base09}FF", "fontStyle": "italic",},
              },
              { "scope": [ "string.quoted.double.nix", ],
              "settings": { "foreground": "#${config.colorScheme.palette.base0A}", "fontStyle": "",},
              },
              { "scope": [ "comment", "comment.block", ],
                "settings": { "foreground": "#${config.colorScheme.palette.base0C}","fontStyle": "", }
              },
              { "scope": [ "entity.other.attribute-name.single.nix", ],
                "settings": { "foreground": "#${config.colorScheme.palette.base05}","fontStyle": "bold", }
              },
              { "scope": [ "constant.language.nix", ],
                "settings": { "foreground": "#${config.colorScheme.palette.base09}","fontStyle": "bold", }
              },
              { "scope": [ "variable.parameter.name.nix", ],
                "settings": { "foreground": "#${config.colorScheme.palette.base0D}","fontStyle": "italic", }
              },
            ]
          },

          "workbench.colorCustomizations": {
            "markdown.extension.print.theme": "dark",

            "editorBracketHighlight.foreground1": "#${config.colorScheme.palette.base0A}",
            "editorBracketHighlight.foreground2": "#${config.colorScheme.palette.base0E}",
            "editorBracketHighlight.foreground3": "#${config.colorScheme.palette.base0C}",
            "editorBracketHighlight.foreground4": "#${config.colorScheme.palette.base09}",
            "editorBracketHighlight.foreground5": "#${config.colorScheme.palette.base0E}",
            "editorBracketHighlight.foreground6": "#${config.colorScheme.palette.base0C}",

            // menu
            "menubar.selectionForeground":"#${config.colorScheme.palette.base07}",
            "menubar.selectionBackground":"#${config.colorScheme.palette.base02}",
            "menubar.selectionBorder":"#${config.colorScheme.palette.base0F}",
            //
            "menu.foreground":"#${config.colorScheme.palette.base07}",
            "menu.background":"#${config.colorScheme.palette.base01}",
            //
            "menu.selectionForeground":"#${config.colorScheme.palette.base07}",
            "menu.selectionBackground":"#${config.colorScheme.palette.base02}",
            "menu.separatorBackground":"#${config.colorScheme.palette.base02}",
            "menu.border":"#${config.colorScheme.palette.base0F}",
            //
            "foreground": "#${config.colorScheme.palette.base07}",                        // directory listing text top, tab tooltip text
            //
            // titlebar
            "window.inactiveBorder": "#${config.colorScheme.palette.base00}",
            "window.activeBorder": "#${config.colorScheme.palette.base0D}",
            "descriptionForeground": "#${config.colorScheme.palette.base05}",             // lables and such
            //
            // editor
            "editor.background": "#${config.colorScheme.palette.base00}",                 // editor background
            "editor.foreground": "#${config.colorScheme.palette.base06}",                 // basic text colour, , : ; and so forth
            //
            "editorCursor.foreground": "#${config.colorScheme.palette.base07}",           // | this lad
            "editorWhitespace.foreground": "#${config.colorScheme.palette.base07}",       // whitespace characters
            //
            "editor.lineHighlightBackground": "#${config.colorScheme.palette.base0E}22",  // highlighted line, needs another transparency added 99 wont cut 44 good
            "editor.selectionBackground": "#${config.colorScheme.palette.base0D}66",      // highlighted text, using same as above
            "editor.selectionHighlightBackground": "#${config.colorScheme.palette.base08}66",
            //
            // toolbar
            "toolbar.activeBackground": "#${config.colorScheme.palette.base0C}",          //
            "toolbar.activeForeground": "#${config.colorScheme.palette.base0D}",          // unsure of these two for now
            //
            // activitybar / sidebars
            "activityBar.background": "#${config.colorScheme.palette.base00}",            // background colour
            "activityBar.foreground": "#${config.colorScheme.palette.base0D}",            // forefround colour, icons
            "activityBar.inactiveForeground": "#${config.colorScheme.palette.base04}",    // inactive icon colour
            "activityBar.border": "#${config.colorScheme.palette.base02}",                // divider between action bar and tree / explorer
            "activityBarBadge.background": "#${config.colorScheme.palette.base0D}",       // badge icon background colour
            "activityBarBadge.foreground": "#${config.colorScheme.palette.base07}",       // badge text / icon colour
            "activityBar.activeBorder": "#${config.colorScheme.palette.base0D}",          // highlighted icon border colour
            "activityBar.activeBackground": "#${config.colorScheme.palette.base02}",
            //
            // sidebar, tree and such
            "sideBar.background": "#${config.colorScheme.palette.base01}",
            "list.hoverBackground": "#${config.colorScheme.palette.base03}",
            "list.hoverForeground": "#${config.colorScheme.palette.base00}",
            "list.dropBackground": "#${config.colorScheme.palette.base00}",
            "sideBarSectionHeader.border": "#${config.colorScheme.palette.base02}",
            "sideBar.border": "#${config.colorScheme.palette.base0D}",
            "sideBar.dropBackground": "#${config.colorScheme.palette.base0E}44",
            "sideBar.foreground": "#${config.colorScheme.palette.base05}",                // text colour
            "sideBarSectionHeader.background": "#${config.colorScheme.palette.base02}",   // headers in sidebar
            "sideBarSectionHeader.foreground": "#${config.colorScheme.palette.base07}",   // header text colour
            "focusBorder": "#ffffff",
            "list.focusAndSelectionOutline": "#${config.colorScheme.palette.base0D}",
            "list.activeSelectionBackground": "#${config.colorScheme.palette.base03}",
            "list.activeSelectionForeground": "#${config.colorScheme.palette.base00}",
            "statusBarItem.remoteBackground": "#${config.colorScheme.palette.base0C}",
            "statusBarItem.remoteForeground": "#${config.colorScheme.palette.base00}",
            "statusBar.background": "#${config.colorScheme.palette.base00}",
            "statusBar.border": "#${config.colorScheme.palette.base02}",
            "statusBar.foreground": "#${config.colorScheme.palette.base05}",
            //
            // tabs
            "editorGroupHeader.tabsBackground": "#${config.colorScheme.palette.base00}",  //
            "tab.activeBackground": "#${config.colorScheme.palette.base02}",              // active tab background
            "tab.hoverBackground": "#${config.colorScheme.palette.base02}",               // hover background
            "tab.inactiveBackground": "#${config.colorScheme.palette.base01}",            // inactive tab background
            "tab.activeForeground": "#${config.colorScheme.palette.base06}",              // text
            "tab.hoverForeground": "#${config.colorScheme.palette.base07}",               // hover text
            "tab.activeBorder": "#${config.colorScheme.palette.base0C}",                  // border colour
            "tab.inactiveForeground": "#${config.colorScheme.palette.base04}",            // inactive text
            "gitDecoration.stageModifiedResourceForeground": "#${config.colorScheme.palette.base0C}",
            "gitDecoration.modifiedResourceForeground": "#${config.colorScheme.palette.base0B}",
            //
            "tab.unfocusedActiveForeground": "#${config.colorScheme.palette.base07}",     // when using tab groups
            "tab.unfocusedInactiveForeground": "#${config.colorScheme.palette.base04}",   // same as above
            "tab.dragAndDropBorder": "#${config.colorScheme.palette.base0D}",
            "tab.unfocusedHoverBackground": "#${config.colorScheme.palette.base02}",
            //
            "tab.unfocusedHoverForeground": "#${config.colorScheme.palette.base07}",      // hover inactive text

            "tab.activeModifiedBorder": "#00000000",        // all transparent
            "tab.unfocusedActiveBorderTop": "#00000000",    //
            "tab.border": "#00000000",                                                    // left / right hand borders
            "tab.activeBorderTop": "#00000000",                                           // top border
            "tab.inactiveModifiedBorder": "#00000000",      //
            "tab.unfocusedActiveBorder": "#00000000",       //
            "tab.lastPinnedBorder": "#00000000",            //

            //
            // titlebar
            "titleBar.activeForeground": "#${config.colorScheme.palette.base07}",         // text
            "titleBar.inactiveForeground": "#${config.colorScheme.palette.base03}",       // text inactive
            "titleBar.activeBackground": "#${config.colorScheme.palette.base00}",         // top-bar background
            "titleBar.inactiveBackground": "#${config.colorScheme.palette.base01}",       // when inactive window, titlebar background
            "titleBar.border": "#${config.colorScheme.palette.base02}",                   // border of titlebar, meh
            // random things i never added to a category
            "panel.background": "#${config.colorScheme.palette.base00}",
            "input.background": "#${config.colorScheme.palette.base01}",
            // mipmap
            "minimap.background": "#${config.colorScheme.palette.base01}",                // big scroll boi background
            "minimap.selectionOccurrenceHighlight": "#${config.colorScheme.palette.base08}44",
            "minimap.findMatchHighlight": "#${config.colorScheme.palette.base08}99",
            "minimap.selectionHighlight": "#${config.colorScheme.palette.base0C}99",
            //
            //buttons and other fun things
            "button.background": "#${config.colorScheme.palette.base0D}",
            "badge.background": "#${config.colorScheme.palette.base08}",
            "checkbox.background": "#${config.colorScheme.palette.base00}",
            "checkbox.foreground": "#${config.colorScheme.palette.base03}",
            "checkbox.border": "#${config.colorScheme.palette.base01}",
            "dropdown.background": "#${config.colorScheme.palette.base00}",
            "textLink.foreground": "#${config.colorScheme.palette.base08}"
          },
          "editor.minimap.size": "fill",
          "chat.commandCenter.enabled": false, // byeeeee
        }
      '';
    };
  };
}
