import Clock from './widgets/Clock.js';
import Date from './widgets/Date.js';

import Workspaces from './widgets/Workspaces.js';
import Separator from '../misc/Separator.js';

import { Widget } from '../imports.js';

import sys_tray from './widgets/sys_tray.js';
import menu from "./widgets/menu.js";

import bat_level from './widgets/bat_level.js';
import vol_level from './widgets/vol_level.js';

const Battery = () => Widget.Box({
    class_name: 'battery',
    hpack: 'start',
    children: [ 
        bat_level(), 
    ],
});

const Menu = () => Widget.Box({
    class_name: 'menu',
    hpack: 'start',
    children: [ 
        menu(), 
    ],
});

const Volume = () => Widget.Box({
    class_name: 'volume',
    hpack: 'start',
    children: [ 
        vol_level(),
    ],
});

const Left = () => Widget.Box({
    class_name: 'bar__left',
    orientation: 'horizontal',
    hpack: 'start',
    hexpand: true,
    children: [
        Workspaces(),
    ],
});

const Center = () => Widget.Box({
    class_name: 'bar__center',
    children: [
        Volume(),
        Separator(),
        Date(),
        Separator(),
        Clock(),
        Separator(),
        Battery(),
    ],
});

const Right = () => Widget.Box({
    class_name: 'bar__right',
    orientation: 'horizontal',
    hpack: 'end',
    children: [
        sys_tray(),
        Separator(),
        Menu(),
    ],
});

export default monitor => Widget.Window({
    name: `bar${monitor}`,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    monitor,
    hexpand: true,
    child: Widget.CenterBox({
        class_name: 'bar',
        startWidget: Left(),
        centerWidget: Center(),
        endWidget: Right(),
    }),
});
