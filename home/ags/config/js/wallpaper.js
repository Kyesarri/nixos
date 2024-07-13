//import { SCREEN_HEIGHT, SCREEN_WIDTH } from '../variables.js';

export default () => Widget.Window({
    name: `desktopbackground`,
    layer: 'background',
    exclusivity: 'ignore',
    visible: true,
    child: Widget.Box({
      class_name: 'wallpaper',
      css: 'padding: 1920px 1080px;',
      child: Widget.Revealer(),
    }),
  })

  