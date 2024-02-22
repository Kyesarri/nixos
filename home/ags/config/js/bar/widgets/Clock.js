import { Widget } from '../../imports.js';
import GLib from 'gi://GLib';

export default () => Widget.Label({
    class_name: 'clock',
    label: GLib.DateTime.new_now_local().format("%H:%M"),
    setup: (self) => self.poll(5000, label => {
        label.label = GLib.DateTime.new_now_local().format("%H:%M");
    }),
});