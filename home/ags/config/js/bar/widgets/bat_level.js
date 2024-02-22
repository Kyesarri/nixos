import { Battery, Widget } from '../../imports.js';

const state = arg => Battery.bind('charging');

export default () => Widget.Box({
    class_name: 'bat_level',
    "visible": Battery.bind('available'),
    sensitive: 1,
    cursor: 'pointer',
    children: [
        Widget.ProgressBar({
            class_name: 'bat_progressbar',
            sensitive: 1,
            attribute: state(),
            vpack: 'center',
            cursor: 'pointer',
            show_text: false,
            fraction: Battery.bind('percent').transform(p => { return p > 0 ? p / 100 : 0; }),
        }),
    ],
});