import { Hyprland, Utils, Widget } from '../../imports.js';

export const ActiveApp = () => Widget.Box({
    className: 'activeapp',
    children: [
        Widget.Label({
            xalign: 0,
            label: Hyprland.active.client.bind('title'),
            visible: Hyprland.active.client.bind('address')
            //.transform(addr => !!addr),
        }),
    ],
});
