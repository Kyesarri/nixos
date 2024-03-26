/*
import Bar from './js/bar/main.js';
import Wallpaper from './js/wallpaper.js';

import { forMonitors } from './js/utils.js';

const Windows = () => [
    forMonitors(Bar),
    forMonitors(Wallpaper),
];

App.config({
    css: `${App.configDir}/style.css`,
    stackTraceOnError: true,
    windows: Windows().flat(1),
});
*/

export default (await import('./js/main.js')).default;
