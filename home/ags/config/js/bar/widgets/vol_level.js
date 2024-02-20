import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default () => Widget.Box({
    class_name: 'vol_level',
    css: 'min-width: 75px', /* hate this */
    children: [  
        Widget.Slider({
            class_name: 'vol_slider',
            cursor: 'pointer',
            sensitive: true,
            vpack: 'center',
            inverted: true,
            draw_value: false,
            on_change: ({ value }) => Audio.speaker.volume = value,
            setup: self => self.hook(Audio, () => { self.value = Audio.speaker?.volume || 0; }, 'speaker-changed'),
        }),
    ],
});