import { SystemTray, Widget } from '../../imports.js';

const SysTrayItem = item => Widget.Button({
    class_name: 'sys_button',
    setup: self => {
        const id = item.menu?.connect('popped-up', menu => {
            self.toggleClassName('active');
            menu.connect('notify::visible', menu => {
                self.toggleClassName('active', menu.visible);
            });
            menu.disconnect(id);
        });
        if (id)
            self.connect('destroy', () => item.menu?.disconnect(id));
    },
    child: Widget.Icon().bind('icon', item, 'icon'),
    tooltipMarkup: item.bind('tooltip_markup'),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
});

const sys_tray = () => Widget.Box({
    class_name: 'sys_box',
    children: SystemTray.bind('items').transform(i => i.map(SysTrayItem))
})

export default () => sys_tray();