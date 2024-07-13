{
  config,
  inputs,
  outputs,
  user,
  ...
}: {
  home-manager.users.${user}.home.file.".config/swaync/style.css" = {
    text = ''
      @define-color cc-bg rgba(0, 0, 0, 0.7);

      @define-color noti-border-color rgba(255, 255, 255, 0.15);
      @define-color noti-bg rgb(48, 48, 48);
      @define-color noti-bg-darker rgb(38, 38, 38);
      @define-color noti-bg-hover rgb(56, 56, 56);
      @define-color noti-bg-focus rgba(68, 68, 68, 0.6);
      @define-color noti-close-bg rgba(255, 255, 255, 0.1);
      @define-color noti-close-bg-hover rgba(255, 255, 255, 0.15);

      @define-color text-color rgb(255, 255, 255);
      @define-color text-color-disabled rgb(150, 150, 150);

      @define-color bg-selected rgb(0, 128, 255);

      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: @noti-bg-focus;
      }

      .notification {
        border-radius: 12px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
          0 2px 6px 2px rgba(0, 0, 0, 0.3);
        padding: 0;
      }

      /* Uncomment to enable specific urgency colors
      .low {
        background: yellow;
        padding: 6px;
        border-radius: 12px;
      }

      .normal {
        background: green;
        padding: 6px;
        border-radius: 12px;
      }

      .critical {
        background: red;
        padding: 6px;
        border-radius: 12px;
      }
      */

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 12px;
      }

      .close-button {
        background: @noti-close-bg;
        color: @text-color;
        text-shadow: none;
        padding: 0;
        border-radius: 100%;
        margin-top: 10px;
        margin-right: 16px;
        box-shadow: none;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        box-shadow: none;
        background: @noti-close-bg-hover;
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        color: @text-color;
        transition: all 0.15s ease-in-out;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: @noti-bg-hover;
      }

      .notification-default-action {
        border-radius: 12px;
      }

      /* When alternative actions are visible */
      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
      }

      .notification-action {
        border-radius: 0px;
        border-top: none;
        border-right: none;
      }

      /* add bottom border radius to eliminate clipping */
      .notification-action:first-child {
        border-bottom-left-radius: 10px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        border-right: 1px solid @noti-border-color;
      }

      .inline-reply {
        margin-top: 8px;
      }
      .inline-reply-entry {
        background: @noti-bg-darker;
        color: @text-color;
        caret-color: @text-color;
        border: 1px solid @noti-border-color;
        border-radius: 12px;
      }
      .inline-reply-button {
        margin-left: 4px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        border-radius: 12px;
        color: @text-color;
      }
      .inline-reply-button:disabled {
        background: initial;
        color: @text-color-disabled;
        border: 1px solid transparent;
      }
      .inline-reply-button:hover {
        background: @noti-bg-hover;
      }

      .image {
      }

      .body-image {
        margin-top: 6px;
        background-color: white;
        border-radius: 12px;
      }

      .summary {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: @text-color;
        text-shadow: none;
      }

      .time {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: @text-color;
        text-shadow: none;
        margin-right: 18px;
      }

      .body {
        font-size: 15px;
        font-weight: normal;
        background: transparent;
        color: @text-color;
        text-shadow: none;
      }

      .control-center {
        background: @cc-bg;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
      }

      .floating-notifications {
        background: transparent;
      }

      /* Window behind control center and on all other monitors */
      .blank-window {
        background: alpha(black, 0.25);
      }

      /*** Widgets ***/

      /* Title widget */
      .widget-title {
        margin: 8px;
        font-size: 1.5rem;
      }
      .widget-title > button {
        font-size: initial;
        color: @text-color;
        text-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
        border-radius: 12px;
      }
      .widget-title > button:hover {
        background: @noti-bg-hover;
      }

      /* DND widget */
      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
      }
      .widget-dnd > switch {
        font-size: initial;
        border-radius: 12px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
      }
      .widget-dnd > switch:checked {
        background: @bg-selected;
      }
      .widget-dnd > switch slider {
        background: @noti-bg-hover;
        border-radius: 12px;
      }

      /* Label widget */
      .widget-label {
        margin: 8px;
      }
      .widget-label > label {
        font-size: 1.1rem;
      }

      /* Mpris widget */
      .widget-mpris {
        /* The parent to all players */
      }
      .widget-mpris-player {
        padding: 8px;
        margin: 8px;
      }
      .widget-mpris-title {
        font-weight: bold;
        font-size: 1.25rem;
      }
      .widget-mpris-subtitle {
        font-size: 1.1rem;
      }

      /* Buttons widget */
      .widget-buttons-grid {
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
        background-color: @noti-bg;
      }

      .widget-buttons-grid>flowbox>flowboxchild>button{
        background: @noti-bg;
        border-radius: 12px;
      }

      .widget-buttons-grid>flowbox>flowboxchild>button:hover {
        background: @noti-bg-hover;
      }

      /* Menubar widget */
      .widget-menubar>box>.menu-button-bar>button {
        border: none;
        background: transparent;
      }

      /* .AnyName { Name defined in config after #
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      .AnyName>button {
        background: transparent;
        border: none;
      }

      .AnyName>button:hover {
        background-color: @noti-bg-hover;
      } */

      .topbar-buttons>button { /* Name defined in config after # */
        border: none;
        background: transparent;
      }

      /* Volume widget */

      .widget-volume {
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      .widget-volume>box>button {
        background: transparent;
        border: none;
      }

      .per-app-volume {
        background-color: @noti-bg-alt;
        padding: 4px 8px 8px 8px;
        margin: 0px 8px 8px 8px;
        border-radius: 12px;
      }

      /* Backlight widget */
      .widget-backlight {
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      /* Title widget */
      .widget-inhibitors {
        margin: 8px;
        font-size: 1.5rem;
      }
      .widget-inhibitors > button {
        font-size: initial;
        color: @text-color;
        text-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
        border-radius: 12px;
      }
      .widget-inhibitors > button:hover {
        background: @noti-bg-hover;
      }
    '';
  };
}
