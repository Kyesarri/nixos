import { clock } from '../../variables.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export default ({
    format = '%H:%M',
    interval = 1000,
    ...rest
} = {}) => Widget.Label({
    class_name: 'clock',
    label: clock.bind('value').transform(time => {
        return time.format(format)}),
//        return time.format(format) || 'yer nar'; }),
    ...rest,
});