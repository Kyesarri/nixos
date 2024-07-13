import { Widget } from '../../imports.js';

// define single dot, button in a box
const dots = () => Widget.Box({ 
    class_name: '____menu_dot',
    vpack: 'center',
    hpack: 'center',
    sensitive: 1,
    cursor: 'pointer',
    children: [
        Widget.Button({
            class_name: '_____menu_button',
            sensitive: 1,
            vpack: 'center',
            cursor: 'pointer',
        }),
    ],
});

// each dot gets their own class, used for individual theming
const left = () => Widget.EventBox({ 
    class_name: '___left',
    child: dots()
});
const middle = () => Widget.EventBox({
    class_name: '___middle',
    child: dots()
});
const right = () => Widget.EventBox({
    class_name: '___right',
    child: dots()
});

// combine all dots into a box, cant be eventbox - can only have child:
const combined_box = () => Widget.Box({
    class_name: '__menu_inner',
    children: [
        left({class_name: 'dot1',}),
        middle({class_name: 'dot2',}),
        right({class_name: 'dot3',}),
    ]
})

// export combined_box in an eventbox, for :hover
export default () => Widget.EventBox({
    //on_clicked: TODO
    class_name: '_menu_event',
    cursor: 'pointer',
    sensitive: 1,
    child: combined_box(),
})