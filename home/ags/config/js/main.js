import { USER } from 'resource:///com/github/Aylur/ags/utils.js';
import Bar from './bar/main.js';
import Wallpaper from './wallpaper.js';

import { forMonitors } from './utils.js';

const windows = () => [
    forMonitors(Bar),
    forMonitors(Wallpaper),
];

export default {
    windows: windows().flat(1),
    //windows: windows().flat(2),
    //maxStreamVolume: 1.5,
    //closeWindowDelay: {
    //    'quicksettings': 300,
    //    'dashboard': 300,
    //},
    style: `/home/${USER}/.config/ags/style.css`,
};