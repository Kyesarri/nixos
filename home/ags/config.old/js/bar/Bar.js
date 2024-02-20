import Clock from './widgets/Clock.js';
import Date from './widgets/Date.js';

import Workspaces from './widgets/Workspaces.js';
import Separator from '../misc/Separator.js';
import { App, Widget } from '../imports.js';

import * as battery from '../misc/battery.js';

import { ActiveApp } from './widgets/ActiveApp.js';
import SystemIndicators from './widgets/SystemIndicators.js';

const Battery = () => Widget.Box({
    class_name: 'battery',
    hpack: 'end',
    children: [
        battery.Indicator(),
        battery.LevelLabel(),
    ],
});

const Left = () => Widget.Box({
    class_name: 'bar__left',
    orientation: 'horizontal',
    hpack: 'start',
    hexpand: true,
    children: [
        Clock(),
        Separator(),
        Date(),
        Separator(),
        Workspaces(),
        Separator(),
    ],
});

const Center = () => Widget.Box({
    class_name: 'bar__center',
    child: ActiveApp(),
});

const Right = () => Widget.Box({
    class_name: 'bar__right',
    orientation: 'horizontal',
    hpack: 'end',
    children: [
        Separator(),
        SystemIndicators(),
        Separator(),
        Battery(),
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
