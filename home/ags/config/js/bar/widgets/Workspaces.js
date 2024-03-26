import { Hyprland, Widget } from '../../imports.js';
import { range } from '../../utils.js';

const dispatch = arg => Hyprland.message(`dispatch workspace ${arg}`);

const ws = 0;

const Workspaces = () => {
    return Widget.Box({
        class_name: 'workspace_box',
        children: range(ws || 10).map(i => Widget.Button({
            class_name: 'workspace_button',
            attribute: i,
            cursor: 'pointer',
            sensitive: true,
            on_clicked: () => dispatch(i),
            child: Widget.Box({
                class_name: 'indicator',
                hpack: 'center',
            }),
            setup: self => self.hook(Hyprland, () => {
                self.toggleClassName('active', Hyprland.active.workspace.id === i);
                self.toggleClassName('multiple', (Hyprland.getWorkspace(i)?.windows || 0) > 1);
                self.toggleClassName('occupied', (Hyprland.getWorkspace(i)?.windows || 0) > 0);
            }),
        })),
        setup: box => {
            if (ws === 0) {
                box.hook(Hyprland.active.workspace, () => box.children.map(btn => {
                    btn.visible = Hyprland.workspaces.some(ws => ws.id === btn.attribute);
                }));
            }
        },
    });
};
export default () => Widget.EventBox({
    class_name: 'workspaces',
    child: Widget.Box({
        hpack: 'center',
        vpack: 'center',
        child: Widget.EventBox({
            class_name: 'eventbox',
            hpack: 'center',
            child: Workspaces(),
        }),
    }),
});