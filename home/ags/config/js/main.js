import { USER } from 'resource:///com/github/Aylur/ags/utils.js';
import Bar from './bar/Bar.js';

//import * as setup from './utils.js';
import { forMonitors } from './utils.js';

//setup.globalServices();

const windows = () => [
    forMonitors(Bar),
];

export default {
    windows: windows().flat(2),
    // maxStreamVolume: 1.5,
    closeWindowDelay: {
        'quicksettings': 300,
        'dashboard': 300,
    },
    style: `/home/${USER}/.config/ags/style.css`,
};